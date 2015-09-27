class Manage::User < ActiveRecord::Base
  mount_uploader :avatar, UserAvatarUploader
end
