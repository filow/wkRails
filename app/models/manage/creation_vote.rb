class Manage::CreationVote < ActiveRecord::Base
  belongs_to :creation
  belongs_to :user
end
