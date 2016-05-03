class RemoveArtistIdFromRecords < ActiveRecord::Migration
  def up
    remove_column :records, :artist_id
  end

  def down
    add_column :records, :artist_id
  end
end
