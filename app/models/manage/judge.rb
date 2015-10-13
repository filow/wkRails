class Manage::Judge < ActiveRecord::Base
  belongs_to :admin
  belongs_to :creation
end
