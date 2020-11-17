class City < ApplicationRecord
	validates :name, presence: :true, uniqueness: { scope: :state, case_sensitive: false }
	validates :state, presence: :true

	before_save :downcase

	def downcase
		name.downcase!
		state.downcase!
	end
end
