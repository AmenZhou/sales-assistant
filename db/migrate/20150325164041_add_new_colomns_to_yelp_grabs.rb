class AddNewColomnsToYelpGrabs < ActiveRecord::Migration
  def change
    add_column :yelp_grabs, :account_name, :string
    add_column :yelp_grabs, :description, :text
    add_column :yelp_grabs, :revenue, :float
    add_column :yelp_grabs, :employees, :integer
    add_column :yelp_grabs, :ownership, :string
    add_column :yelp_grabs, :primary_industry, :string
    add_column :yelp_grabs, :state, :string
    add_column :yelp_grabs, :country, :string
    add_column :yelp_grabs, :lead_source, :string
    add_column :yelp_grabs, :parent_name, :string
    add_column :yelp_grabs, :address_remark, :text
    add_column :yelp_grabs, :remark, :text
    add_column :yelp_grabs, :assign_to, :string
  end
end
