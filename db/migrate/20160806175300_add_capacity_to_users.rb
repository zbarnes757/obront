class AddCapacityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_capacity, :integer, default: 0
    add_column :users, :next_capacity, :integer, default: 0
  end
end
