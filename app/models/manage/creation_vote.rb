class Manage::CreationVote < ActiveRecord::Base
  belongs_to :creation, counter_cache: :vote_count
  belongs_to :user
end
