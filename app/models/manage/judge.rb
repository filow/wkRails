class Manage::Judge < ActiveRecord::Base
  belongs_to :admin
  belongs_to :creation

  validates :creation_id, uniqueness: {scope: :admin_id}
end
