## Setup
```sh
$ git clone git@github.com:johnny-miyake/process_csv_with_resque.git
$ cd process_csv_with_resque/
$ bundle install
$ rake db:migrate
$ bundle exec rake resque:work QUEUE="*" &
$ rails s
```

## Usage
1. Open two tabs and access to `http://localhost:3000`(tab1) and `http://localhost:3000/resque`(tab2).
2. Select a CSV file ( `http://localhost:3000/clients.csv` is available) and upload it.
3. Reload tab1 and confirm that the data you have just uploaded has not been saved in DB yet.
4. Reload tab2 and confirm that a background job is being executed.
5. Wait for 30 seconds.
6. Reload tab1 again and confirm that the data you have uploaded is shown in the list.
