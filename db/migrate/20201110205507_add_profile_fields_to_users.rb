class AddProfileFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :last_name, :string, null: false, default: ""
    add_column :users, :dni, :int, null: false, default: 0, limit: 8
    add_index :users, :dni, unique: true
    add_column :users, :birth_date, :date, null: false, default: Date.today
    add_column :users, :role, :string, null: false, default: "user"
    add_column :users, :suscribed, :boolean, null: false, default: false
  end
end
