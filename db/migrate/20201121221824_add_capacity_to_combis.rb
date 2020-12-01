class AddCapacityToCombis < ActiveRecord::Migration[5.2]
  def change
  	add_column :combis, :capacity, :integer, default: 0
  end
end
