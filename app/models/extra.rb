class Extra < ApplicationRecord
	# Validations
    validates :name, presence: :true, uniqueness: true

    # Relations
    has_and_belongs_to_many :routes, dependent: :destroy

    # Methods
    def check_routes
    	self.routes.each do |r|
    		r.extras.delete(self)
    	end
	end

	def name_extra
		"#{name.titleize}"
	end
end
