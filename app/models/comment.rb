class Comment < ApplicationRecord
	# Scopes
	default_scope -> { order(created_at: :desc)}
	#Validations
	validates :text, presence: true

	before_save :define_author

	#Relations
	belongs_to :travel
	belongs_to :user

	def define_author
		self.author = user.last_name +  ", "  + user.name
		author.capitalize
	end

end
