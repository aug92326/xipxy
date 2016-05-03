class CreateArtworkMultipleObjects < ActiveRecord::Migration
  def change
    create_table :artwork_multiple_objects do |t|
      t.references :record, index: true, foreign_key: true
      t.string :name, null: false, default: ""
      t.string :material
      t.string :system
      t.hstore :size
      t.integer :weight
      t.integer :duration

      t.timestamps null: false
    end
  end
end
