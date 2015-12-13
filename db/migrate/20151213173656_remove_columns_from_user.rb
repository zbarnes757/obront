class RemoveColumnsFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :payment_city
    remove_column :users, :payment_state
    remove_column :users, :payment_zipcode
    remove_column :users, :background
    rename_column :users, :payment_street, :payment_address
  end
end
