class Ticket < ApplicationRecord
	# Scopes 
	default_scope -> { order(status: :asc)}
	scope :pending, -> { where(status: :pending)}
	scope :confirmed, -> { where(status: :confirmed)}
	scope :rejected, -> { where(status: :rejected)}
	scope :absent, -> { where(status: :absent)}
	scope :past, -> { where(sttus: :past)}


	# Validations

	# Relations
	belongs_to :user
	belongs_to :travel
    has_and_belongs_to_many :extras

    # Methods
    def date
    	self.travel.date_departure
    end

    enum status: [:pending, :confirmed, :rejected, :absent, :past]

end
