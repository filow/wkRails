class Manage::CreationComment < ActiveRecord::Base
  belongs_to :creation, counter_cache: :comment_count
  belongs_to :user
end
