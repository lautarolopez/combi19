class Combi < ApplicationRecord
	#Validations
	validates :licence_plate, presence: true, uniqueness: true,length:{minimum:6,maximun:7}
	validates :category, presence:true, length:{minimun:0, maximum:50}

	before_save :upcase

	#Relations
	belongs_to :travel

	#Methods
	def upcase
		licence_plate.upcase!
	end

end
