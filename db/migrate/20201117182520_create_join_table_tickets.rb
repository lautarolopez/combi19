class CreateJoinTableTickets < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :travels do |t|
      t.references :user, foreign_key: true
      t.references :travel, foreign_key: true
    end
  end
end
