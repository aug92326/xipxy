class AddCatalogueRaisonneToEditions < ActiveRecord::Migration
  def change
    add_column :editions, :authenticator, :string
    add_column :editions, :authenticity_id, :integer
  end
end
