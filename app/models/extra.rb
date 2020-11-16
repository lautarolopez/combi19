class Extra < ApplicationRecord
	# Validations
    validates :name, presence: :true, uniqueness: true

    before_destroy :check_routes, prepend: true

    # Relations
    has_and_belongs_to_many :routes

    # Methods
    def check_routes
    	self.routes.each do |r|
    		r.extras.delete(self)
    	end
	end
end
