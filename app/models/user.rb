# frozen_string_literal: true
class User < ApplicationRecord
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  attr_accessor :remember_token

  attr_reader :activation_token

  validates :name, presence: true, length: { maximum: 50 }
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6, maximum: 15 }, allow_nil: true

  # Inside the User model the self keyword is optional on the RHS
  before_save :downcase_email

  has_secure_password

  before_create :create_activation_digest

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil) if !remember_digest.nil?
  end

  # token_type is a symbol
  def authenticated?(token_type, token)
    digest =
      case token_type
      when :remember
        self.remember_digest
      when :activation
        self.activation_digest
      else
        puts "Unsupported token type #{token_type}"
        nil
      end
    digest ? BCrypt::Password.new(digest).is_password?(token) : false
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def create_activation_digest
    @activation_token = User.new_token
    self.activation_digest = User.digest(@activation_token)
  end

  def downcase_email
    self.email = email.downcase
  end
end
