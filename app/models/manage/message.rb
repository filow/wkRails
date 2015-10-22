class Manage::Message < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence:true
  validates :from, presence:true
  validates :title, presence:true
  validates :content, presence:true

end
