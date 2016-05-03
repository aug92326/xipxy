class AddCountryToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :country, :text
  end
end
