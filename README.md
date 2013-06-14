# process_csv_with_resque
This is a small example project of processing CSV file with Resque. Checkout this project and you can try it easily.

## Setup
```sh
(Install Redis before you run this app)
$ git clone git@github.com:johnny-miyake/process_csv_with_resque.git
$ cd process_csv_with_resque/
$ bundle install
$ rake db:migrate
$ bundle exec rake resque:work QUEUE="*"
(open another terminal and go to project dir)
$ rails s
```

## Usage
1. Open two tabs and access to `http://localhost:3000`(tab1) and `http://localhost:3000/resque`(tab2).
2. Select a CSV file ( `http://localhost:3000/clients.csv` is available) and upload it.
3. Reload tab1 and confirm that the data you have just uploaded has not been saved in DB yet.
4. Reload tab2 and confirm that a background job is being executed.
5. Wait for 30 seconds.
6. Reload tab1 again and confirm that the data you have uploaded is shown in the list.

* Relaunch the Resque worker every time you modify a worker script (e.g. `app/workers/import_csv.rb`).


## Explanation
Followings are explanations of some principal files on this application.

### configuration files
* `config/redis/development.conf`
This is the configuration file for redis. It is used for launching Redis server
and also used for initializing Resque client in `config/initializers/resque.rb`.
`config/initializers/resque.rb`.
```ruby
daemonize yes
port 6379
logfile ./log/redis_development.log
dbfilename ./db/development.rdb
```

* `config/initializers/redis.rb`
This is an initialize
```ruby
require "redis"
redis_conf_path = Rails.root.join("config/redis", "#{Rails.env}.conf")
redis_conf = File.read(redis_conf_path)
port = /port.(\d+)/.match(redis_conf)[1]
host = "localhost"
`redis-server #{redis_conf_path}`
res = `ps aux | grep redis-server`
unless res.include?("redis-server") && res.include?(redis_conf_path.to_s)
  raise "Couldn't start redis"
end
# You can do below if you use Redis directly in your application.
# $redis = Redis.new(host: host, port: port)
```

* `config/initializers/resque.rb`
This script initializes a Resque client.
```ruby
redis_conf_path = Rails.root.join("config/redis", "#{Rails.env}.conf")
redis_conf = File.read(redis_conf_path)
port = /port.(\d+)/.match(redis_conf)[1]
host = "localhost"
Resque.redis = Redis.new(host: host, port: port)
```

* `lib/tasks/resque.rake`
This is a Rake task used by Resque.
```ruby
require "resque/tasks"
task "resque:setup" => :environment
```

### Worker
`app/workers/import_csv.rb`
This is the worker for processing CSV file. It starts processing CSV after 30
seconds later it is called.
```ruby
class ImportCsv
  @queue = :default

  def self.perform(file)
    require "csv"
    sleep 30
    CSV.foreach(file, headers: true) do |row|
      Client.create(
        client_name: row[0],
        roman_name: row[1],
        tel: row[2]
      )
    end
  end
end
```

### Controller
`app/controllers/clients_controller.rb`
This is the controller for uploading CSV file. Job for uploading CSV file is
enqueued in create_by_csv action.

```ruby
class ClientsController < ApplicationController
  def index
    @clients = Client.all
  end

  def create_by_csv
    path = "tmp/clients.csv"
    File.open path, "wb" do |f|
      f.puts params[:csv].read
    end
    Resque.enqueue ImportCsv, path
    redirect_to clients_path, notice: "enqueued."
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    redirect_to clients_path
  end
end
```

## Operation check
This sample project is performed an operation check on `ruby 1.9.3p392` and `Rails 3.2.13`.
