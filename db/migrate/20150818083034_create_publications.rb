class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.references :edition, index: true, foreign_key: true
      t.string :source
      t.string :title
      t.string :author

      t.datetime :date
      t.text :link

      t.timestamps null: false
    end
  end
end
