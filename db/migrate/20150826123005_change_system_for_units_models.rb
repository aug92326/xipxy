class ChangeSystemForUnitsModels < ActiveRecord::Migration
  def change
    change_column :records, :system, :string, default: BaseUnitSystem.default_system.label.downcase
    change_column :external_artworks, :system, :string, default: BaseUnitSystem.default_system.label.downcase
    change_column :artwork_multiple_objects, :system, :string, default: BaseUnitSystem.default_system.label.downcase

    remove_column :records, :weight
    remove_column :external_artworks, :weight
    remove_column :artwork_multiple_objects, :weight

    add_column :records, :weight, :hstore, default: BaseUnitSystem.nil_weight
    add_column :external_artworks, :weight, :hstore, default: BaseUnitSystem.nil_weight
    add_column :artwork_multiple_objects, :weight, :hstore, default: BaseUnitSystem.nil_weight

    change_column :records, :size, :hstore, default: BaseUnitSystem.nil_size
    change_column :external_artworks, :size, :hstore, default: BaseUnitSystem.nil_size
    change_column :artwork_multiple_objects, :size, :hstore, default: BaseUnitSystem.nil_size
    change_column :details_artworks, :frame, :hstore, default: BaseUnitSystem.nil_size
  end
end
