class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
    	t.string :name, null: false, default:""
      	t.string :state, null: false, default:""

      	t.timestamps
    end
  end
end
