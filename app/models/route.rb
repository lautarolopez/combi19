class Route < ApplicationRecord
	# Validations
	validates :origin, presence: :true, uniqueness: { scope: :destination, case_sensitive: false }
	validates :destination, presence: :true, uniqueness: { scope: :origin, case_sensitive: false }

	# Relations
	has_and_belongs_to_many :extras
	belongs_to :origin, class_name: 'City', foreign_key: 'origin_id'
	belongs_to :destination, class_name: 'City', foreign_key: 'destination_id'
	has_many :travels, dependent: :restrict_with_exception

	def name
		"#{origin.name.titleize}, #{origin.state.titleize} - #{destination.name.titleize}, #{destination.state.titleize}"
	end
	
end
