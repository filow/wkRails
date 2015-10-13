class Manage::Creation < ActiveRecord::Base
  belongs_to :user
  has_many :creation_authors
  has_many :creation_comments
  has_many :creation_views
  has_many :creation_votes
  has_many :judges
end
