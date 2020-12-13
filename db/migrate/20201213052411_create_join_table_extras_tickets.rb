class CreateJoinTableExtrasTickets < ActiveRecord::Migration[5.2]
  def change
    create_join_table :extras, :tickets do |t|
      t.references :extra, foreign_key: true
      t.references :ticket, foreign_key: true
    end
  end
end
