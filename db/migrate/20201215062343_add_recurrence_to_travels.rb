class AddRecurrenceToTravels < ActiveRecord::Migration[5.2]
  def change
  	add_column :travels, :recurrence, :integer, default: 0
  	add_column :travels, :recurrence_name, :string
  end
end
