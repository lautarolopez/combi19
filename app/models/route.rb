class Route < ApplicationRecord
	# Relations
	has_and_belongs_to_many :extras
	belongs_to :origin, class_name: 'City', foreign_key: 'origin_id'
	belongs_to :destination, class_name: 'City', foreign_key: 'destination_id'
end
