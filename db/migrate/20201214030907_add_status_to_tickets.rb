class AddStatusToTickets < ActiveRecord::Migration[5.2]
  def change
  	add_column :tickets, :status, :integer, default: 0
  end
end
