class User < ActiveRecord::Base
	#----Original Method----
	#before_save { self.email = email.downcase } 
	#----Bang Method----
	before_save { email.downcase! }
	
	#----Original----
	validates :name, presence: true, length: { maximum: 50 }
	#----Equivalent----
	#validates(:name, presence: true)

	#---- Doesn't check "..com" emails----
	#VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	#---- Does check "..com" emails----
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	
	validates :email, presence: true, length: { maximum: 255 }, 
										format: { with: VALID_EMAIL_REGEX },
										uniqueness: {case_sensitive: false }

	has_secure_password	
	validates :password, presence: true, length: { minimum: 6 }								

end
