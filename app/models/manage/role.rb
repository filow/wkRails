class Manage::Role < ActiveRecord::Base
  has_and_belongs_to_many :nodes
  has_and_belongs_to_many :admins

  validates :name,presence: {value: true},
    uniqueness:  {value: true}
end
