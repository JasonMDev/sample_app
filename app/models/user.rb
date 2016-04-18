class User < ActiveRecord::Base
  
  # Association with microposts
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower                                

	# Create an accessible attribute
	attr_accessor :remember_token, :activation_token, :reset_token
	before_save   :downcase_email
	before_create :create_activation_digest   

	# NAME VALIDATION	
	# | -- Original -- |
	validates :name, presence: true, length: { maximum: 50 }
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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

	# Forgets a user.
	def forget
	  update_attribute(:remember_digest, nil)
	end

	# Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  def feed
    # Full implementation.
    # More efficient feed implementation
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
    # Full implementation after refactoring
    # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #                following_ids: following_ids, user_id: id)
    # A first feed implementation
    # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
    # Defines a proto-feed.
    # Micropost.where("user_id = ?", id)
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

	private
    
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
    # | -- Bang Method -- |
    # before_save { email.downcase! }	
    # | -- Original Method -- |
    # before_save { self.email = email.downcase }

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
