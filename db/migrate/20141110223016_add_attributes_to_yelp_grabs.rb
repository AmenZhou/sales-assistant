class AddAttributesToYelpGrabs < ActiveRecord::Migration
  def change
    add_column :yelp_grabs, :city, :string
    add_column :yelp_grabs, :zipcode, :string
    add_column :yelp_grabs, :street, :string
    add_column :yelp_grabs, :genre, :string
    add_column :yelp_grabs, :rating, :string
  end
end
