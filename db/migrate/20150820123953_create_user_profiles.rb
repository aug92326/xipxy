class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.references :user, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :mailing_address
      t.string :country
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :phone
      t.string :alternative_email

      t.timestamps null: false
    end
  end
end
