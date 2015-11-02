class Index::UserController < IndexController
  def reg
  end

  def login
    unless session[:user_id].blank?
      redirect_to root_path
    end
  end

  def show
  end

  def create
    prms = params.permit(:username, :password)

    user = Manage::User.find_by_name(prms[:username]).try(:authenticate, prms[:password])
    if user   #帐号密码正确
      if user.is_forbidden?   #用户被禁用
        redirect_to user_login_path, notice: "您的账户已被锁定"
      else    #为其登陆
        session[:user_id] = user.id
        redirect_to root_path
      end
    else
      redirect_to user_login_path, notice: "用户名或密码错误，请重试"
    end
  end

  def edit
      user = Manage::User.find_by(email: params[:email])
    if user && !user.is_email_verified? && user.authenticated?(:activation, params[:id])
      user.activate
      redirect_to user
    else
      redirect_to root_url
    end
  end
end
