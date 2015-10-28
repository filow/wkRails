class Manage::Admin < ActiveRecord::Base

  has_many :judges
  has_and_belongs_to_many :roles

	validates_presence_of :realname

	validates :name,presence: {value: true},
		uniqueness:  {value: true},
		#用户名长度以及内容规范应当按照国际惯例
		length: { minimum: 4,maximum: 16,message: "用户名长度必须在4—16个字符之间" },
		format: { with: /\A[a-zA-Z][0-9a-zA-Z]+\Z/,
			message: "用户名只能由数字和字母组成，且开头不能为数字" }

  # 密码至少8位
	validates_length_of :password,minimum: 8,maximum:16, allow_blank:true,on: [:create,:update]

  #更新用户信息前清空缓存
  before_update :clear_privilege_cache

  def child_nodes
     Manage::Node.joins(:roles).where("roles.id" => self.role_ids, "roles.is_enabled" => true).uniq
  end

  def can_access?(action,controller)
    init_cache
    nodes = @privilege_cache[self.id]
    nodes ||= set_admin_privileges
    nodes.include?(controller.to_s + '_' + action.to_s)
  end

  def with_access(privilege_name)
    if block_given? && can_access?(privilege_name)
      yield
    end
  end

  def without_access(privilege_name)
    if block_given? && !can_access?(privilege_name)
      yield
    end
  end

  def init_cache
    @privilege_cache ||= Cache.new("ManageAdminPrivileges")
  end

  def clear_privilege_cache
    init_cache
    @privilege_cache.delete(self.id)
  end

  private

    def set_admin_privileges
      nodes = child_nodes
      node_names = nodes.collect{|node| node.controller + "_" + node.action }
      init_cache

      @privilege_cache[self.id] = node_names
      node_names
    end


  # 使用插件建立用户密码验证体系
  has_secure_password
end
