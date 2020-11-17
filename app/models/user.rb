class User < ApplicationRecord  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
 
  # Validations
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "is not valid"
  validates :name, presence: true
  validates :last_name, presence: true
  validates :dni, presence: true, uniqueness: true
  validates :birth_date, presence: true
  validate :validate_age

  # Relations
  has_and_belong_to_many :travels

  # Methods
  def validate_age 
    if birth_date.present? && birth_date > 18.year.ago.to_date
      errors.add(:birth_date, 'should make at least 18 years old')
    end
  end
  
   
end
