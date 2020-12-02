class Comment < ApplicationRecord
	#Validations
	validates :text, presence: true

	before_save :definir_autor

	#Relations
	belongs_to :travel
	belongs_to :user

	def definir_author
		self.author = user.last_name +  ", "  + user.name
		author.capitalize
	end

end
