class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :sublocation
      t.text :location_notes

      t.timestamps null: false
    end
  end
end
