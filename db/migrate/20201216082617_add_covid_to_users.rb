class AddCovidToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :not_covid, :boolean, default: true
  end
end
