class AddMediumToRecords < ActiveRecord::Migration
  def change
    add_column :records, :medium, :string, default: 'Painting'
  end
end
