class City < ApplicationRecord
	# Scopes
	default_scope -> { order(state: :asc, name: :asc)}

	# Validations
	validates :name, presence: :true, uniqueness: { scope: :state, case_sensitive: false }
	validates :state, presence: :true

	before_save :downcase
	before_destroy :check_travels, prepend: true

	# Relations
	has_many :routes_from, class_name: 'Route', foreign_key: "origin_id", dependent: :destroy
	has_many :routes_to, class_name: 'Route', foreign_key: "destination_id", dependent: :destroy

	# Methods
    def check_travels
    	#self.routes_from.each do |r|
    		#if (r.travels.count > 0)
				#errors[:base] << "Esta ciudad no se puede borrar porque tiene viajes asociados"
    			#errors.add(:routes_from, "Esta ciudad no se puede borrar porque tiene viajes asociados")
    			#throw :abort    		
    		#end
    	#end
    	#self.routes_to.each do |r|
    		#if (r.travels.count > 0)
    			#errors[:base] << "Esta ciudad no se puede borrar porque tiene viajes asociados"
    			#errors.add(:routes_to, "Esta ciudad no se puede borrar porque tiene viajes asociados")
    		#	throw :abort
    		#end
    	#end
    end

	def downcase
		name.downcase!
		state.downcase!
	end

	def name_state
		"#{name.titleize}, #{state.titleize}"
	end

end
