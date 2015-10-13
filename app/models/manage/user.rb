class Manage::User < ActiveRecord::Base
  has_many :messages
  has_many :creations
  has_many :creation_comments
  mount_uploader :avatar, UserAvatarUploader

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
