class Travel < ApplicationRecord
	# Validations
	validates :driver_id, presence: :true
	validates :combi_id, presence: :true
	validates :route_id, presence: :true
	validates :occupied, presence: :true
	validates :capacity, presence: :true
	validates :date_departure, presence: :true
	validates :date_arrival, presence: :true
	validates :price, presence: :true

	before_destroy :refund_passsengers, prepend: true

	# Relations
	belongs_to :driver, class_name: 'User', primary_key: driver_id
	has_many :routes_from, class_name: 'Route', foreign_key: "origin_id", dependent: :destroy
	belongs_to :combi
	belongs_to :route
	has_and_belongs_to_many :passengers, class_name: 'User', dependent: :destroy


	# Methods
    def refund_passengers
    end
end
