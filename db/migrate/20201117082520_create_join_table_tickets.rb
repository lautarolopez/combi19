class CreateJoinTableTickets < ActiveRecord::Migration[5.2]
  def change
    create_join_table :passengers, :travels do |t|
      t.references :passenger, foreign_key: true
      t.references :travel, foreign_key: true
    end
  end
end
