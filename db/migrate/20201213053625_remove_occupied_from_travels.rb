class RemoveOccupiedFromTravels < ActiveRecord::Migration[5.2]
  def change
  	remove_column :travels, :occupied
  end
end
