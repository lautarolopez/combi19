class User < ApplicationRecord  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
 
  #Scopes
	scope :drivers, -> { where("role = ?", "driver") }
  
  # Validations
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: " no es válido."
  validates :name, presence: true
  validates :last_name, presence: true
  validates :dni, presence: true, uniqueness: true, numericality: { greater_than_or_equal_to: 0, less_than: 999999999 }
  validates :birth_date, presence: true
  validate :validate_age

  before_save :update_covid

  # Relations
  belongs_to :subscription_payment_method, class_name: "PaymentMethod", foreign_key: 'subscription_payment_method_id', optional: true
  has_many :driving_travels, class_name: "Travel", foreign_key: "driver_id", dependent: :restrict_with_exception
  has_many :tickets, dependent: :destroy
  has_many :travels, through: :tickets
  has_many :payment_methods, dependent: :destroy
  has_many :comments

  # Methods
  def validate_age 
    if birth_date.present? && birth_date > 18.year.ago.to_date
      errors.add(:birth_date, "no válida, tiene que ser mayor de 18 años.")
    end
  end

  def name_last_name
        "#{name.capitalize} #{last_name.capitalize}"
  end   

  def finished_travels
    past = []
    tickets.each do |ticket|
      if ticket.past?
        past.push(ticket.travel)
      end
    end
    return past
  end

  def rejected_travels
    rejected = []
    tickets.each do |ticket|
      if ticket.rejected?
        rejected.push(ticket.travel)
      end
    end
    return rejected
  end

  def absent_travels
    absent = []
    tickets.each do |ticket|
      if ticket.absent?
        absent.push(ticket.travel)
      end
    end
    return absent
  end

  def current_travel
    if role == "user"
      t = tickets.confirmed.first
      if t
        return t.travel
      else
        return nil
      end
    elsif role == "driver"
      return driving_travels.current.first
    end
  end

  def next_travel
    if role == "user"
      return travels.future.first
    elsif role == "driver"
      return driving_travels.future.first
    end
  end

  def update_covid
    if not_covid
      self.discharge_date = nil
    end
  end

  def covid
    return (!not_covid && discharge_date != nil && discharge_date > Date.today)
  end
end
