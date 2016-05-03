class CreateTagsEditions < ActiveRecord::Migration
  def change
    create_table :tags_editions do |t|
      t.references :tag, index: true, foreign_key: true
      t.references :edition, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
