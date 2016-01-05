class Manage::CreationAuthor < ActiveRecord::Base
  belongs_to :creation
  enum sex: [:male, :female]
  
end
