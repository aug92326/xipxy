class CreateRecordsCollectionsLists < ActiveRecord::Migration
  def change
    create_table :records_collections_lists do |t|
      t.references :record, index: true, foreign_key: true
      t.references :records_collection, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
