class Combi < ApplicationRecord
<<<<<<< HEAD
	# Scopes
	default_scope -> { order(licence_plate: :asc)}

	#Validations
	validates :licence_plate, presence: true, uniqueness: true,length:{minimum:6,maximun:7}
	validates :category, presence:true, length:{minimun:0, maximum:50}

	before_save :upcase

	#Relations
	has_many :travels, dependent: :restrict_with_exception

	#Methods
	def upcase
		licence_plate.upcase!
	end

end
