class CreateDetailsArtworks < ActiveRecord::Migration
  def change
    create_table :details_artworks do |t|
      t.references :edition, index: true, foreign_key: true
      t.string :manufacturer
      t.string :designer
      t.string :period
      t.string :packaging
      t.hstore :frame
      t.string :unique_marks
      t.string :additional_information

      t.timestamps null: false
    end

    add_index :details_artworks, :manufacturer
    add_index :details_artworks, :designer
  end
end
