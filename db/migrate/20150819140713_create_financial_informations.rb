class CreateFinancialInformations < ActiveRecord::Migration
  def change
    create_table :financial_informations do |t|
      t.references :edition, index: true, foreign_key: true
      t.decimal :price
      t.decimal :insured_price
      t.string :insured_type
      t.text :policy

      t.timestamps null: false
    end
  end
end
