class Manage::User < ActiveRecord::Base
  has_many :messages
  has_many :creations
  has_many :creation_comments
  mount_uploader :avatar, UserAvatarUploader

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


end
