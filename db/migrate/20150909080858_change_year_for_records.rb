class ChangeYearForRecords < ActiveRecord::Migration
  def up
    remove_column :records, :year
    add_column :records, :year, :hstore, default: {estimated: false, value: nil}
  end

  def down
    remove_column :records, :year
    add_column :records, :year, :integer
  end
end
