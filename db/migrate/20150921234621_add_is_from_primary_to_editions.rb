class AddIsFromPrimaryToEditions < ActiveRecord::Migration
  def change
    add_column :editions, :is_from_primary, :boolean, default: false
  end
end
