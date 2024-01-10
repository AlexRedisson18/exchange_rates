class CreateExchangeRates < ActiveRecord::Migration[7.1]
  def change
    create_table :exchange_rates do |t|
      t.string :currency, null: false
      t.decimal :price, precision: 6, scale: 2, null: false
      t.date :date, null: false

      t.timestamps
    end
    add_index :exchange_rates, %i[currency date], unique: true
  end
end
