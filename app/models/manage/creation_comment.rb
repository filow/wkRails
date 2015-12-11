class Manage::CreationComment < ActiveRecord::Base
  belongs_to :creation, counter_cache: :comment_count
  belongs_to :user
  validates_length_of :message, maximum: 200, minimum: 10
end
