class CreateRecordsCollections < ActiveRecord::Migration
  def change
    create_table :records_collections do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.boolean :public, default: true

      t.timestamps null: false
    end
  end
end
