class Index::UsercenterController < IndexController
  def index
    if session[:user_id].blank?   #未登录
      redirect_to user_login_path, notice: '请先登陆'
      return
    end
    @user = Manage::User.find_by_id session[:user_id]
    unless @user    #没有登陆用户的信息
      redirect_to root_path
      return
    end
    version = Cfg.get 'current_version'
    @current_creations = @user.creations.where(version: version)
    @original_creations = @user.creations.where.not(version: version)
  end
end
