class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :brand, null: false, default: ""
      t.string :country
      t.integer :founded
      t.integer :closed

      t.timestamps null: false
    end

    add_index :artists, :brand
  end
end
