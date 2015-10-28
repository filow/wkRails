class Manage::Role < ActiveRecord::Base
  has_and_belongs_to_many :nodes
  has_and_belongs_to_many :admins

  validates :name,presence: {value: true},
    uniqueness:  {value: true}

  #更新用户的角色前清空缓存
  before_save do
    self.admins.each do |a|
      a.clear_privilege_cache
    end
  end
end
