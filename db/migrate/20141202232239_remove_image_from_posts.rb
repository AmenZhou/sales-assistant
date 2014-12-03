class RemoveImageFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :image
  end

  def down
    add_column :posts, :image, :string
  end
end
