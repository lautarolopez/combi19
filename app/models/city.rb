class City < ApplicationRecord
	# Validations
	validates :name, presence: :true, uniqueness: { scope: :state, case_sensitive: false }
	validates :state, presence: :true

	before_save :downcase
	before_destroy :check_travels, prepend: true

	# Relations
	has_many :routes_from, class_name: 'Route', foreign_key: "origin_id", dependent: :destroy
	has_many :routes_to, class_name: 'Route', foreign_key: "destination_id", dependent: :destroy

	# Methods
	def downcase
		name.downcase!
		state.downcase!
	end

    def check_travels
    	#self.routes_from.each do |r|
    		#if (r.travels.count > 0)
    		#	throw :abort
    		#end
    	#end
    	#self.routes_to.each do |r|
    		#if (r.travels.count > 0)
    		#	throw :abort
    		#end
    	#end
	end
end
