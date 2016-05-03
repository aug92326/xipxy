class RenameTagsEditionsToEdtionsTags < ActiveRecord::Migration
  def change
    rename_table :tags_editions, :editions_tags
  end
end
