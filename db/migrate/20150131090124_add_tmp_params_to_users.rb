class AddTmpParamsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tmp_params, :string, default: {}
  end
end
