class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.text :content
      t.string :image
      t.integer :category_id
      t.string :media_type

      t.timestamps null: false
    end
  end
end
