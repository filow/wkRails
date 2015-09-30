class ManageController < ApplicationController
  before_action :build_manage_cache
  before_action :check_login
  before_action :set_nav

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
        redirect_to manage_login_url,:alert => "您的账户已被禁用"
      end
    else
      redirect_to manage_login_url
    end
  end

  def set_nav
    @navs = @cache.get 'nav',nil,true do
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
