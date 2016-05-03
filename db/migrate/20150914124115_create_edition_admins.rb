class CreateEditionAdmins < ActiveRecord::Migration
  def change
    create_table :edition_admins do |t|
      t.references :edition, index: true, foreign_key: true
      t.string :xipsy_artwork_id
      t.string :xipsy_record_number
      t.string :inventory_number
      t.datetime :record_date
      t.string :copyright
    end
  end
end
