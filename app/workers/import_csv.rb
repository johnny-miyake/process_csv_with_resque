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
