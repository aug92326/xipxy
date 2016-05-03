class SomeClearTables < ActiveRecord::Migration
  def up
    remove_column :editions, :location_id
    add_column :locations, :edition_id, :integer
  end

  def down
    add_column :editions, :location_id, :integer
    remove_column :locations, :edition_id
  end
end
