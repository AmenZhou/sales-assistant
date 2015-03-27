class AddBoroughYelpGrabs < ActiveRecord::Migration
  def change
    add_column :yelp_grabs, :borough, :string
  end
end
