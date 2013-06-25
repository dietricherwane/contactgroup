class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
 :remember_me, :firstname, :lastname, :age, :gender, :published, :msisdn, :prefix, :authentication_token
 
	before_save :ensure_authentication_token
 
	has_many :messages
	has_many :groups
	has_many :demands
	has_many :links
end
