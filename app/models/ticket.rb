class Ticket < ApplicationRecord
	# Scopes 
	default_scope -> { order(status: :asc)}

	# Validations

	# Relations
	belongs_to :user
	belongs_to :travel
    has_and_belongs_to_many :extras

    # Methods
    def date
    	self.travel.date_departure
    end

    enum status: [:pending, :confirmed, :rejected, :absent]

end
