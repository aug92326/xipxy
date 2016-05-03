class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :edition, index: true, foreign_key: true
      t.text :copyright_holder
      t.text :licensing_agency
      t.text :resolution
      t.text :credit_line
      t.text :licensing_fee
      t.boolean :download, default: true

      t.string :image
      t.hstore :crop
      t.string :temp_image

      t.timestamps null: false
    end
  end
end
