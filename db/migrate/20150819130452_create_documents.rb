class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :edition, index: true, foreign_key: true
      t.string :title
      t.string :file
      t.boolean :public, default: false


      t.timestamps null: false
    end
  end
end
