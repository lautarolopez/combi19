class User < ApplicationRecord  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
 
  # Validations
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: " no es válido."
  validates :name, presence: true
  validates :last_name, presence: true
  validates :dni, presence: true, uniqueness: true
  validates :birth_date, presence: true
  validate :validate_age

  # Relations
  has_many :driving_travels, class_name: "User", foreign_key: "driver_id"
  has_and_belongs_to_many :travels

  # Methods
  def validate_age 
    if birth_date.present? && birth_date > 18.year.ago.to_date
      errors.add(:birth_date, "Sólo podés registrarte teniendo más de 18 años.")
    end
  end

  def name_last_name
        "#{name.capitalize} #{last_name.capitalize}"
  end
  
   
end
