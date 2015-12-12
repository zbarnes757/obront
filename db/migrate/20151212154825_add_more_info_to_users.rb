class AddMoreInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :street, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zipcode, :string
    add_column :users, :payment_method, :string
    add_column :users, :payment_street, :string
    add_column :users, :payment_city, :string
    add_column :users, :payment_state, :string
    add_column :users, :payment_zipcode, :string
    add_column :users, :calendly_link, :string
    add_column :users, :background, :text
    add_column :users, :notes, :text
  end
end
