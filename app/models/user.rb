class User < ApplicationRecord
  attr_accessor :remember_token

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\d+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255},
                      format: {  with: VALID_EMAIL_REGEX },
                      uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: { minimum:6 }
  has_secure_password

  #return the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost 
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember 
    #get random remember token
    self.remember_token = User.new_token
    # update and save encrypted remember token to column remember digest in database using update_attribute
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  #forget a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  #return true if the given token matches the digest
  def authenticated?(remember_token)
    # remember_digest = self.remember_digest( Active Record automatically create based on db column)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
