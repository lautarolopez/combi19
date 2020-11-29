class CreatePaymentMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_methods do |t|
      t.integer :user_id
      t.integer :card_number, :limit => 8
      t.string :name
      t.integer :expire_month
      t.integer :expire_year
      t.integer :verification_code
      t.string :company

      t.timestamps
    end
  end
end
