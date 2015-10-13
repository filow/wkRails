class Manage::User < ActiveRecord::Base
  has_many :messages
  has_many :creations
  has_many :creation_comments
  mount_uploader :avatar, UserAvatarUploader
  
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

  def sex
    s = super
    if s.nil?
      ""
    elsif s == true
      "男"
    else
      "女"
    end
  end

  def sex=(new_sex)
    if new_sex == '男'
      super(true)
    elsif new_sex == '女'
      super(false)
    else
      super(new_sex)
    end
  end

end
