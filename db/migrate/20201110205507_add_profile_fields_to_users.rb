class AddProfileFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :last_name, :string, null: false
    add_column :users, :dni, :int, null: false
    add_index :users, :dni, unique: true, null: false
    add_column :users, :birth_date, :date, null: false
    add_column :users, :role, :string, null: false
    add_column :users, :suscribed, :boolean, null: false
  end
end
