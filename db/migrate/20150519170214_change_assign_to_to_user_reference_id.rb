class ChangeAssignToToUserReferenceId < ActiveRecord::Migration
  def up
    remove_column :yelp_grabs, :assign_to
    add_reference :yelp_grabs, :user, index: true, foreign_key: true
  end

  def down
    add_column :yelp_grabs, :assign_to, :string
    remove_reference :yelp_grabs, :user
  end
end
