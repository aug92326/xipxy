class AddPublicToAttachments < ActiveRecord::Migration

  def change
    add_column :attachments, :public, :boolean, default: false
  end

end
