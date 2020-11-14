class CreateExtras < ActiveRecord::Migration[5.2]
  def change
    create_table :extras do |t|
      t.string :name, null: false, default:""
      t.text :description
      t.float :price, null: false, default: 0
      t.timestamps
    end

    add_index :extras, :name, unique: true 
  end
end
