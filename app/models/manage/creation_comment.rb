class Manage::CreationComment < ActiveRecord::Base
  belongs_to :creation, counter_cache: :comment_count
  belongs_to :user
  validates_length_of :message, maximum: 500, minimum: 15, allow_blank: false

  # 分页显示时每页的个数
  paginates_per 15
end
