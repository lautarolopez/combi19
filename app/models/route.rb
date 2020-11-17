class Route < ApplicationRecord
	# Validations
	validates :origin, presence: :true, uniqueness: { scope: :destination, case_sensitive: false }
	validates :destination, presence: :true

	# Relations
	has_and_belongs_to_many :extras
	belongs_to :origin, class_name: 'City', foreign_key: 'origin_id'
	belongs_to :destination, class_name: 'City', foreign_key: 'destination_id'
	#has_many :travels

end
