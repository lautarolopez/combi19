class Travel < ApplicationRecord
	# Validations
	validates :driver_id, presence: :true
	validates :combi_id, presence: :true
	validates :route_id, presence: :true
	validates :capacity, presence: :true
#	validates :date_departure, presence: :true
#	validates :date_arrival, presence: :true
	validates :price, presence: :true

	# Relations
	belongs_to :driver, class_name: 'User', foreign_key: "driver_id"
	belongs_to :combi
	belongs_to :route
	has_and_belongs_to_many :passengers, class_name: 'User', dependent: :destroy
end
