class CreateTravels < ActiveRecord::Migration[5.2]
  def change
    create_table :travels do |t|
      t.integer :driver_id
      t.integer :route_id
      t.integer :occupied, default: 0
      t.integer :capacity, default: 0
      t.datetime :date_departure
      t.datetime :date_arrival
      t.float :price, default: 0

      t.timestamps
    end
  end
end
