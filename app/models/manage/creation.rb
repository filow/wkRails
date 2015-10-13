class Manage::Creation < ActiveRecord::Base
  belongs_to :user
  has_many :creation_authors
  has_many :judges
end
