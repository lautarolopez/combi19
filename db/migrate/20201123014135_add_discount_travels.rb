class AddDiscountTravels < ActiveRecord::Migration[5.2]
  def change
  	add_column :travels, :discount, :integer, default: 0
  end
end
