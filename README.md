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
1. Access to `http://localhost:3000`
2. Select a CSV file ( `http://localhost:3000/clients.csv` is available) and upload it.
3. Reload your browser and confirm that the data you have just uploaded has not been saved in DB.
4. Wait for 90 seconds.
5. Reload your browser and confirm that the data you have uploaded is shown in the list.
