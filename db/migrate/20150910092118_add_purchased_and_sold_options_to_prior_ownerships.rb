class AddPurchasedAndSoldOptionsToPriorOwnerships < ActiveRecord::Migration
  def change
    add_column :prior_ownerships, :purchased_through, :string
    add_column :prior_ownerships, :sold_through, :string
  end
end
