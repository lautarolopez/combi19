class AddStatusToTravels < ActiveRecord::Migration[5.2]
  def change
  	add_column :travels, :status, :integer, default: 0
  end
end
