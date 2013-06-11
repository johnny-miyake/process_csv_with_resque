class ImportCsv
  @queue = :import_csv

  def self.perform(file)
    require "csv"
    CSV.foreach(file, headers: true) do |row|
      sleep 30
      Client.create(
        client_name: row[0],
        roman_name: row[1],
        tel: row[2]
      )
    end
  end
end
