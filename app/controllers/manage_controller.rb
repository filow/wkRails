class ManageController < ApplicationController
  before_action :build_manage_cache
  before_action :check_login
  before_action :set_nav
  before_action :option_record ,only:[:create,:update,:destroy,:update_self,:create_role,:update_role,:destroy_role]

  @@permission_alias_store = Hash.new

  def can?(action, controller=nil)
    controller ||= params[:controller].split('/')[-1]
    key = controller + Manage::Admin.Spliter + action.to_s
    # 如果存在别名，就映射到对应的另外一个权限上
    if @@permission_alias_store[key]
      new_key = @@permission_alias_store[key]
      action = new_key.split('_')[-1]
    end
    @admin.can_access?(action, controller)
  end

  protected
  # 设置权限别名，比如让检查dest的
  def self.permission_alias(src, dest)
    # self = Manage::AdminController
    # self.to_s.underscore = "manage/admins_controller"
    controller = self.to_s.underscore.split(/[\/_]/)[-2]
    src_full = controller + Manage::Admin.Spliter + src.to_s
    dest_full = controller + Manage::Admin.Spliter + dest.to_s
    @@permission_alias_store[dest_full] = src_full
    p @@permission_alias_store
  end

  private
  def build_manage_cache
    @cache = Cache.new("wkRails-Manage-")
  end

  def check_login
    if session[:admin_id]
      # 从数据库中读取用户信息
      # TODO: 把 Admin 放入缓存中,这样可以减少对数据库的访问,提高性能
      @admin=Manage::Admin.find(session[:admin_id])
      # 如果用户已经被禁用也直接跳转
      if @admin.is_forbidden?
        #判断被禁用后直接关掉session，避免重定向循环
        session[:admin_id] = nil
        redirect_to manage_login_url,:alert => "您的账户已被禁用"
      end
    else
      redirect_to manage_login_url
    end
  end

  def option_record
    admin_id = session[:admin_id]
    target = params[:controller]+"/"+params[:action]
    record = Manage::OptionRecord.new(admin_id: admin_id,target: target)
    case params[:controller]

    when 'manage/users'
      case params[:action]
      when 'create'
        record.hash_params = params[:manage_user]
        record.save
      when 'update'
        record.hash_params = params[:manage_user]
        record.hash_params[:id] = params[:id]
        record.save
      when 'destroy'
        record.hash_params = {id: params[:id]}
        record.save
      end

    when 'manage/messages'
      case params[:action]
      when "create"
        record.hash_params = params[:message]
        record.hash_params[:id] = params[:user_id]
        record.save
      end

    when 'manage/admins'
      case params[:action]
      when "create"
        record.hash_params = params[:manage_admin]
        record.save
      when "update"
        record.hash_params = params[:manage_admin]
        record.hash_params[:id] = params[:id]
        record.save
      when "destroy"
        record.hash_params = {id: params[:id]}
        record.save
      when "update_self"
        record.hash_params = params[:manage_admin]
        record.save
      when "create_role"
        record.hash_params = {name: params[:name]}
        record.save
      when "update_role"
        record.hash_params = {new_nodes: params[:new_nodes]}
        record.hash_params[:id] = params[:id]
        record.save
      when "destroy_role"
        record.hash_params = {id: params[:id]}
        record.save
      end
    end
  end

  def set_nav
    # 如果在开发模式下nav在每次页面加载时都会刷新
    @navs = @cache.get 'nav', nil, Rails.env.development? do
      result = []
      raw = YAML.load(File.read('config/ext/manage_nav.yml'))["nav"]
      raw.each do |item|
        controller, action = item["path"].split('/')
        result << {text: item["text"], icon: item["icon"], options: {controller: 'manage/' + controller, action: action}}
      end
      result
    end
  end
end
