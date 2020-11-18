class AddCombiToTravels < ActiveRecord::Migration[5.2]
  def change
  	add_column :travels, :combi_id, :integer
  end
end
