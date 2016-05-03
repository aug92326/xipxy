class CreateRecordsArtists < ActiveRecord::Migration
  def change
    create_table :records_artists do |t|
      t.string :brand, null: false, default: ""
      t.references :record, index: true, foreign_key: true
      t.string :country
      t.integer :founded
      t.integer :closed

      t.timestamps null: false
    end

    add_index :records_artists, :brand
  end
end
