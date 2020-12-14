class Travel < ApplicationRecord
	# Scopes
	default_scope -> { order(date_departure: :asc, date_arrival: :asc)}
	scope :future, -> { where("date_departure >= ?", DateTime.now).reorder(date_departure: :asc, date_arrival: :asc) }
	scope :previous, -> { where("date_arrival <= ?", DateTime.now).reorder(date_departure: :desc, date_arrival: :desc) }
	scope :current, -> { where("date_departure <= ? and date_arrival > ?", DateTime.now, DateTime.now).reorder(date_arrival: :asc, date_departure: :asc)}
	scope :pending, -> { where("date_arrival > ?", DateTime.now).reorder(date_departure: :asc, date_arrival: :asc) }

	# Validations
	validates :combi_id, presence: :true
	validates :route_id, presence: :true
	validates :date_departure, presence: :true
	validates :date_arrival, presence: :true
	validates :price, presence: :true, numericality: { greater_than_or_equal_to: 0 }
	validates :discount, :inclusion => 0..100
	#validate :validate_dates --> esta validación se hace en el controlador, tuve que borrarla del modelo para poder cargar seeds con fechas pasadas

	# Relations
	belongs_to :driver, class_name: 'User', foreign_key: "driver_id"
	belongs_to :combi
	belongs_to :route
	has_one :origin, through: :route
	has_one :destination, through: :route
	has_many :tickets, dependent: :destroy
	has_many :passengers, through: :tickets, source: :user
	has_many :comments, dependent: :destroy


	# Methods
	#def validate_dates
	#	if date_departure > date_arrival || date_departure < DateTime.current.beginning_of_day || date_arrival < DateTime.current.beginning_of_day
	#		errors.add(:date_departure, "Las fechas ingresadas son incorrectas.")
	#		errors.add(:date_arrival, "Las fechas ingresadas son incorrectas.")
	#	end
	#end

	def name
		"#{origin.name.titleize}, #{origin.state.titleize} - #{destination.name.titleize}, #{destination.state.titleize} el día #{I18n.l(date_departure, format: "%d de %B de %Y a las %H:%M hs.")}"
	end

	def occupied
		self.tickets.count
	end

	def current
		return ((date_departure <= DateTime.now) && (date_arrival > DateTime.now))
	end

	def future
		return (date_departure >= DateTime.now)
	end
end
