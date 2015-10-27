class Manage::User < ActiveRecord::Base
  has_many :messages
  has_many :creations
  has_many :creation_comments
  mount_uploader :avatar, UserAvatarUploader
  attr_accessor :activation_token
  before_create :create_activation_digest

  enum sex: [:male, :female]
  enum group: [:student, :teacher]
  validates :name, presence:true,length:{maximum:30}
  validates :realname, presence:true,length:{maximum:15}
  # validates :idcard, presence:true
  validates :phone, presence:true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/
  validates :email, length:{maximum:255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness:{case_senstive: false},
            allow_blank:true
  has_secure_password
  validates_length_of :password,minimum: 6, allow_blank:true,on: [:update]
  validates_length_of :password,minimum: 6, on: [:create]

  def send_message(options)
    m = Manage::Message.create(options.merge({"user_id"=> id}))
    count = messages.where(is_readed: false).count
    update_column(:msg_unread, count)
    m
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_attribute(:is_email_verified,true)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  def authenticated?(attribute,token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  private
  def create_activation_digest
    self.activation_token = Manage::User.new_token
    self.activation_digest = Manage::User.digest(activation_token)
  end

end
