class Combi < ApplicationRecord
	# Scopes
	default_scope -> { order(licence_plate: :asc)}

	#Validations
	validates :licence_plate, presence: true, uniqueness: { case_sensitive: false}, length:{minimum:6,maximum:7}
	validates :category, presence:true, length:{minimun:0, maximum:50}
	validates :capacity, presence: :true, numericality: { greater_than: 0 }

	before_save :upcase

	#Relations
	has_many :travels, dependent: :restrict_with_exception

	#Methods
	def upcase
		licence_plate.upcase!
	end

end
