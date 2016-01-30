class User < ActiveRecord::Base
	# Create an accessible attribute
	attr_accessor :remember_token

	# NAME VALIDATION
	# | -- Bang Method -- |
	before_save { email.downcase! }	
	# | -- Original -- |
	validates :name, presence: true, length: { maximum: 50 }
	# | -- Original Method -- |
	#before_save { self.email = email.downcase }
	# | -- Equivalent -- |
	#validates(:name, presence: true)

	# EMAIL VALIDATION
	# | -- Does check "..com" emails -- |
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 }, 
										format: { with: VALID_EMAIL_REGEX },
										uniqueness: {case_sensitive: false }
	# | -- Doesn't check "..com" emails -- |
	#VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	# PASSWORD VALIDATION
	# | -- Make sure password is secure and is validated.
	has_secure_password	
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true	

	# Returns the hash disgest of the given string.
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
																									BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Returns a random token.
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# Remembers a user in the database for use in persistent sessions.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Returns true if the given token matches the digest.
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	# Forgets a user.
	def forget
		update_attribute(:remember_digest, nil)
	end

end
