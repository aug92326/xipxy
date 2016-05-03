class CreatePriorOwnerships < ActiveRecord::Migration
  def change
    create_table :prior_ownerships do |t|
      t.references :edition, index: true, foreign_key: true
      t.string :owner
      t.decimal :purchase_price
      t.decimal :sale_price
      t.datetime :date_of_purchase
      t.datetime :date_of_sale

      t.timestamps null: false
    end

  end
end
