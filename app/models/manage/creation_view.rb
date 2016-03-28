class Manage::CreationView < ActiveRecord::Base
  belongs_to :creation, counter_cache: :view_count
  validates_uniqueness_of :ip, scope: [:creation_id]
end
