class CreateExhibitionHistories < ActiveRecord::Migration
  def change
    create_table :exhibition_histories do |t|
      t.references :edition, index: true, foreign_key: true
      t.string :displayed_by
      t.string :displayed_at
      t.string :title

      t.datetime :start_date
      t.datetime :end_date

      t.timestamps null: false
    end
  end
end
