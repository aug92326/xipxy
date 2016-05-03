class AddSystemToDetailsArtworks < ActiveRecord::Migration
  def change
    add_column :details_artworks, :system, :string, default: BaseUnitSystem.default_system.label.downcase
  end
end
