class User < ApplicationRecord
  has_many :articles,dependent: :destroy  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  
  
  VALID_EMAIL_REGEX=/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email ,presence: true , length: {minimum: 8},uniqueness: { case_sensitive: false },format: { with:VALID_EMAIL_REGEX} 
 
end
