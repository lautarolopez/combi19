class CreateCombis < ActiveRecord::Migration[5.2]
  def change
    create_table :combis do |t|
      t.string :category
      t.string :licence_plate

      t.timestamps
    end
  end
end
