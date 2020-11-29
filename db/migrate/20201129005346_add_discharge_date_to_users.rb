class AddDischargeDateToUsers < ActiveRecord::Migration[5.2]
  def change
  	    add_column :users, :discharge_date, :date
  end
end
