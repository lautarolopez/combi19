class AddProfileFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :last_name, :string
    add_column :users, :dni, :int
    add_index :users, :dni, unique: true
    add_column :users, :birth_date, :date
    add_column :users, :role, :string
    add_column :users, :suscribed, :boolean
  end
end
