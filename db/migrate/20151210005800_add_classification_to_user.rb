class AddClassificationToUser < ActiveRecord::Migration
  def change
    add_column :users, :classification, :integer, default: 0, index: true
  end
end
