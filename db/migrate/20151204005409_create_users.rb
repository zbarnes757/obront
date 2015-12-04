class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :password_hash
      t.string :email
      t.boolean :looking_for_work, default: false
      t.boolean :admin, default: false

      t.timestamps null: false
    end
    add_index :users, :email
    add_index :users, :looking_for_work
    add_index :users, :admin
  end
end
