class Manage::CreationView < ActiveRecord::Base
  belongs_to :creation, counter_cache: :view_count
end
