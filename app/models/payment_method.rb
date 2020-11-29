class PaymentMethod < ApplicationRecord
	# Validations
	validates :card_number, presence: true, uniqueness: true
	validates :name, presence: true
	validates :expire_month, presence: true
	validates :expire_year, presence: true, numericality: { greater_or_equal_than: Date.today.year }
	validates :verification_code, presence: true, numericality: {greater_than: 99, less_than: 10000} 
	validates :company, presence: true
	validate :validate_date

	# Relations
	belongs_to :user

	# Methods
	def validate_date
		if expire_year == Date.today.year && expire_month < Date.today.month
			errors.add(:expire_month, "debe ser mayor o igual al actual")
		end
	end

	def card
		number = card_number.to_s
		length = number.length
		"#{company} #{number[0..3]} ... #{number[(length-4)..(length-1)]}"
	end
end
