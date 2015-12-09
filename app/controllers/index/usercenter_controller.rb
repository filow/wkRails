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
    @messages = @user.messages.order(created_at: :desc).limit(5)
    @current_creations = @user.creations.where(version: Cfg.version)
  end
end
