class City < ApplicationRecord
	# Scopes
	default_scope -> { order(state: :asc, name: :asc)}

	# Validations
	validates :name, presence: :true, uniqueness: { scope: :state, case_sensitive: false }
	validates :state, presence: :true, uniqueness: { scope: :name, case_sensitive: false }

	before_save :downcase
	before_update :downcase

	# Relations
	has_many :routes_from, class_name: 'Route', foreign_key: "origin_id", dependent: :destroy
	has_many :routes_to, class_name: 'Route', foreign_key: "destination_id", dependent: :destroy

	# Methods
	def downcase
		name.downcase!
		state.downcase!
	end

	def name_state
		"#{name.titleize}, #{state.titleize}"
	end

end
