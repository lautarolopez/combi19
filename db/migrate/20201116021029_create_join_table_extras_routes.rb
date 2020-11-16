class CreateJoinTableExtrasRoutes < ActiveRecord::Migration[5.2]
  def change
    create_join_table :extras, :routes do |t|
      t.references :extra, foreign_key: true
      t.references :route, foreign_key: true
    end
  end
end
