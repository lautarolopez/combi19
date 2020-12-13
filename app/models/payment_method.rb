class PaymentMethod < ApplicationRecord
	# Validations
	validates :card_number, presence: true, uniqueness: true
	validates :name, presence: true
	validates :expire_month, presence: true
	validates :expire_year, presence: true, numericality: { greater_or_equal_than: Date.today.year }
	validates :verification_code, presence: true, numericality: {greater_than: 99, less_than: 10000} 
	validates :company, presence: true
	validate :validate_date
	validate :validate_card

	# Relations
	belongs_to :user
	has_many :tickets

	# Methods
	def validate_date
		if expire_year == Date.today.year && expire_month < Date.today.month
			errors.add(:expire_month, "debe ser mayor o igual al actual")
		end
	end

	def card
		number = card_number.to_s
		length = number.length
		"#{company} - #{encrypted_number} - #{name}"
	end

	def encrypted_number
		number = card_number.to_s
		length = number.length
		"#{number[0..3]} **** #{number[(length-4)..(length-1)]}"
	end

	def validate_card
		valid = true
		if card_number != nil 
	        number = card_number.to_s
	        if number.length < 14 || number.length > 19
	            errors.add(:card_number, 'es inválido, debe contener entre 14 y 19 dígitos')
	            valid = false
	        end
	        if number[0] < '3' || number[0] > '5'
	            errors.add(:card_number, 'es inválido, debe comenzar en 3, 4 o 5')
	            valid = false
	        end
	    end
        if valid
            return true
        else
            return false
        end
    end
end
