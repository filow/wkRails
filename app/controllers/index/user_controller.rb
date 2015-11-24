class Index::UserController < IndexController

  def reg
    unless session[:user_id].blank?
      redirect_to usercenter_path
      return
    end
  end

  def validate
    if  (/^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/ =~ params[:tel_num]).nil?
      redirect_to user_reg_path, notice: '请输入正确的手机号码'
      return
    end
    redirect_to user_reg_path, alert: '号码格式正确'
  end

  def create
    # @user = Manage::User.new(user_params)
    #
    # if @user.save
    #   @user.send_activation_email
    #   redirect_to @user, notice: "#{@user.name}, 注册成功！"
    # else
    #   render :reg
    # end
    redirect_to user_reg_path
  end

  def login
    unless session[:user_id].blank?
      redirect_to usercenter_path
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path
  end

  def show
  end

  def do_login
    prms = params.permit(:username, :password)

    user = Manage::User.find_by_name(prms[:username]).try(:authenticate, prms[:password])
    if user   #帐号密码正确
      if user.is_forbidden?   #用户被禁用
        redirect_to user_login_path, notice: "您的账户已被锁定"
      else    #为其登陆
        session[:user_id] = user.id
        redirect_to usercenter_path
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

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:manage_user).permit(:name, :realname, :sex, :idcard, :group, :department, :phone, :email, :avatar, :password)
    end
end
