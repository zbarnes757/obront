class AddEmployedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :employed, :boolean, default: false
  end
end
