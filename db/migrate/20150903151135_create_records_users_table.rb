class CreateRecordsUsersTable < ActiveRecord::Migration
  def change
    create_table :records_users do |t|
      t.references :record, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :owner, default: false

      t.timestamps null: false
    end
  end
end
