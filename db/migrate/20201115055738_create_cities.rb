class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
    	t.string :name, null: false, default:""
      	t.string :state, null: false, default:""

      	t.timestamps
    end

#    add_index :cities, :name, :state, unique: true 
  end
end
