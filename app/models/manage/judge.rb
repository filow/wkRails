class Manage::Judge < ActiveRecord::Base
  belongs_to :admin
  belongs_to :creation

  validates :creation_id, uniqueness: {scope: :admin_id}
  validates :rank, numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: 100}
end
