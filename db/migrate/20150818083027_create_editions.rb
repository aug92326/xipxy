class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.references :record, index: true, foreign_key: true
      t.references :location, index: true, foreign_key: true
      t.string :primary_status
      t.string :secondary_status
      t.text :notes
      t.string :type

      t.timestamps null: false
    end
  end
end
