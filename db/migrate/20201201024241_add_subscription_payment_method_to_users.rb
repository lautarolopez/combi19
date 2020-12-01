class AddSubscriptionPaymentMethodToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :subscription_payment_method_id, :integer
  end
end
