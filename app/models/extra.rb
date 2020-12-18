class Extra < ApplicationRecord
	# Validations
    validates :name, presence: :true, uniqueness: { case_sensitive: false }
	validates :price, presence: :true, numericality: { greater_than_or_equal_to: 0 }

	before_save :downcase

    # Relations
    has_and_belongs_to_many :routes, dependent: :destroy
    has_and_belongs_to_many :tickets

    # Methods
	def downcase
		name.downcase!
	end
end
