class ChangeTypeToEditionTypeOnEditions < ActiveRecord::Migration
  def change
    rename_column :editions, :type, :edition_type
  end
end