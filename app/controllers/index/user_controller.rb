class Index::UserController < IndexController

  def reg
    unless session[:user_id].blank?
      redirect_to usercenter_path
      return
    end
  end

  def validate
    res = {}
    if  (/^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/ =~ params[:tel_num]).nil?
      res[:failed] = true
      res[:res] = '请输入正确的手机号码'
    else
      begin
        msg_service_client['requestSmsCode'].post(%Q{{"mobilePhoneNumber": "#{params[:tel_num]}"}})
        res[:failed] = false
      rescue RestClient::Exception => e
        res[:failed] = true
        response = JSON.parse(e.response)
        if response['code'] == 601  #短信数目超过限制的错误
          res[:res] = response['error']
        else  #其他错误
          res[:res] = '验证码发送失败！请稍后再试'
        end
      end
    end
    render json: res
  end

  def create
    if params[:password].length < 6 #验证密码长度
      flash[:alert] = '密码长度必须不小于6位!'
      render :reg
      return
    end
    begin #验证短信
      if params[:valicode].blank?
        flash[:alert] = '请填写验证码!'
        render :reg
        return
      end
      msg_service_client["verifySmsCode/#{params[:valicode]}?mobilePhoneNumber=#{params[:tel_num]}"].post ''
    rescue RestClient::Exception => e
      response = JSON.parse(e.response)
      if response['code'] == 603
        redirect_to user_reg_path, notice: response['error']
        return
      else
        flash[:notice] = '您输入的信息有有误，请重试！'
        render :reg
        return
      end
    end
    #生成用户并存储
    @user = Manage::User.new
    @user.name = params[:tel_num]
    @user.realname = params[:tel_num]
    @user.phone = params[:tel_num]
    @user.password = params[:password]
    if @user.save
      redirect_to usercenter_path, notice: "#{@user.name}, 注册成功！"
    else
      render :reg
    end
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

    def msg_service_client
      # 设置LeanCloud的鉴权参数
      timestamp = Time.now.to_datetime.strftime('%Q')
      app_id = '6k9Tdww1dlF4IzhWGGHVbQD9'
      app_key = 'F9xrSOYuwitFJyFz9OdT87s4'
      md5 = Digest::MD5.new
      md5 << timestamp + app_key
      sign = md5.hexdigest
      # 设置请求头
      headers = {
          X_LC_Id: app_id,
          X_LC_Sign: [sign, timestamp].join(','),
          Content_Type: 'application/json'
      }

      resource = RestClient::Resource.new('https://leancloud.cn/1.1', headers: headers)
    end
end
