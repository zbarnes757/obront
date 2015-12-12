class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :pretty_name

      t.timestamps null: false
    end
    add_index :categories, :name
    add_index :categories, :pretty_name
  end
end
