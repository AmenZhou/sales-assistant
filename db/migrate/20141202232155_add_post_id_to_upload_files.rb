class AddPostIdToUploadFiles < ActiveRecord::Migration
  def change
    add_column :upload_files, :post_id, :integer
  end
end
