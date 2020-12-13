class Ticket < ApplicationRecord
	# Validations

	# Relations
	belongs_to :user
	belongs_to :travel
	belongs_to :payment_method
    has_and_belongs_to_many :extras, dependent: :destroy

    # Methods
    def date
    	self.travel.date_departure
    end

end
