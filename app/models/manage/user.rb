class Manage::User < ActiveRecord::Base
  mount_uploader :avatar, UserAvatarUploader
  enum sex:[:male,:female]
  validates :name, presence:true,length:{maximum:30}
  validates :realname, presence:true,length:{maximum:15}
  validates :idcard, presence:true
  validates :phone, presence:true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/
  validates :email, presence: true,length:{maximum:255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness:{case_senstive: false}
  has_secure_password
  validates :password,length:{minimum:6}
end
