class CreateUnitSystemsTable < ActiveRecord::Migration
  def up
    create_table :base_unit_systems do |t|
      t.string :label
      t.timestamps
    end

    BaseUnitSystem.reset_column_information

    labels = UnitSystem.all.map(&:label)
    labels.each do |label|
      sys = BaseUnitSystem.new
      sys.label = label
      sys.save!
    end
  end

  def down
    drop_table :base_unit_systems
  end
end
