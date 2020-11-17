class Route < ApplicationRecord
	# Validations
	validates :origin, presence: :true, uniqueness: { scope: :destination, case_sensitive: false }
	validates :destination, presence: :true

	before_destroy :check_travels, prepend: true

	# Relations
	has_and_belongs_to_many :extras
	belongs_to :origin, class_name: 'City', foreign_key: 'origin_id'
	belongs_to :destination, class_name: 'City', foreign_key: 'destination_id'
	#has_many :travels


	# Methods
    def check_travels
    	#if (self.travels.count > 0)
    		#errors[:base] << "Esta ruta no se puede borrar porque tiene viajes asociados"
    		#errors.add(:travels, "Esta ruta no se puede borrar porque tiene viajes asociados")
    	#	throw :abort
    	#end
	end
end
