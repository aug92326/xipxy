class CreateExternalArtworks < ActiveRecord::Migration
  def change
    create_table :external_artworks do |t|
      t.references :artist, index: true, foreign_key: true
      t.string :model, null: false, default: ""
      t.integer :year
      t.string :material
      t.string :system
      t.hstore :size
      t.integer :weight
      t.integer :duration

      t.timestamps null: false
    end

    add_index :external_artworks, :model
  end
end
