class ChangeSuscribedForSubscribedAtUsers < ActiveRecord::Migration[5.2]
  def change
  	rename_column :users, :suscribed, :subscribed
  end
end
