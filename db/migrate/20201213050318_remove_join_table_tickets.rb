class RemoveJoinTableTickets < ActiveRecord::Migration[5.2]
  def change
  	drop_table :travels_users
  end
end
