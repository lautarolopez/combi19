class Extra < ApplicationRecord
	# Validations
    validates :name, presence: :true, uniqueness: { case_sensitive: false }

	before_save :downcase

    # Relations
    has_and_belongs_to_many :routes, dependent: :destroy

    # Methods
	def downcase
		name.downcase!
		state.downcase!
	end
end
