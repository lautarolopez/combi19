class User < ApplicationRecord  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
 
  # Validations
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: " no es válido."
  validates :name, presence: true
  validates :last_name, presence: true
  validates :dni, presence: true, uniqueness: true, numericality: { greater_than_or_equal_to: 0, less_than: 999999999 }
  validates :birth_date, presence: true
  validate :validate_age

  # Relations
  belongs_to :subscription_payment_method, class_name: "PaymentMethod", foreign_key: 'subscription_payment_method_id', optional: true
  has_many :driving_travels, class_name: "Travel", foreign_key: "driver_id" #, dependent: :restrict_with_exception
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
end
