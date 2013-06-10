class ImportCsv
  @queue = :import_csv

  def self.perform(file)
    require "csv"
    CSV.foreach(file, headers: true) do |row|
      Client.create(
        client_name: row[0],
        roman_name: row[1],
        tel: row[2],
        contract_flg: row[3],
        contract_type: row[4],
        person_charge: row[5],
        person_sale: row[6]
      )
    end
  end
end
