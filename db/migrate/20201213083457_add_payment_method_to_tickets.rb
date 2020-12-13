class AddPaymentMethodToTickets < ActiveRecord::Migration[5.2]
  def change
  	add_column :tickets, :payment_method, :string
  end
end
