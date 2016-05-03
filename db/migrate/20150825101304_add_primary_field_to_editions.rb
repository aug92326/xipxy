class AddPrimaryFieldToEditions < ActiveRecord::Migration
  def change
    add_column :editions, :primary, :boolean, default: false
  end
end
