class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :client_name
      t.string :roman_name
      t.string :tel

      t.timestamps
    end
  end
end
