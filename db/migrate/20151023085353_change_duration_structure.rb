class ChangeDurationStructure < ActiveRecord::Migration
  def up
    remove_column :external_artworks, :duration
    remove_column :records, :duration
    remove_column :artwork_multiple_objects, :duration

    add_column :external_artworks, :duration, :hstore, default: {hours: 0, minutes: 0, seconds: 0}
    add_column :records, :duration, :hstore, default: {hours: 0, minutes: 0, seconds: 0}
    add_column :artwork_multiple_objects, :duration, :hstore, default: {hours: 0, minutes: 0, seconds: 0}
  end

  def down
    remove_column :external_artworks, :duration
    remove_column :records, :duration
    remove_column :artwork_multiple_objects, :duration

    add_column :external_artworks, :duration, :integer
    add_column :records, :duration, :integer
    add_column :artwork_multiple_objects, :duration, :integer
  end
end
