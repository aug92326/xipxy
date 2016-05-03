class AddInsuranceProviderToFinancialInformations < ActiveRecord::Migration
  def change
    add_column :financial_informations, :insurance_provider, :string
  end
end
