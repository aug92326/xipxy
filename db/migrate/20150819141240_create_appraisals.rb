class CreateAppraisals < ActiveRecord::Migration
  def change
    create_table :appraisals do |t|
      t.references :financial_information, index: true, foreign_key: true
      t.string :name
      t.decimal :appraisal_price
      t.datetime :appraisal_at

      t.timestamps null: false
    end
  end
end
