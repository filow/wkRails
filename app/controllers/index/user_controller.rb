class Index::UserController < IndexController

  def reg
  end

  # 申请手机验证码
  def validate
    phone = params[:tel_num]
    res = {failed: false, res: ""}
    if  (/^1(3[0-9]|5[012356789]|7[678]|8[0-9]|4[57])[0-9]{8}$/ =~ phone).nil?
      res[:failed] = true
      res[:res] = '请输入正确的手机号码'
    else
      # 开始检查手机号是否已经存在
      if params[:mode] != 'reset' && Manage::User.where(name: phone).count > 0
        res[:failed] = true
        res[:res] = '该手机号已被使用'
      else
        # 向手机发送短信验证码
        begin
          msg_service_client['requestSmsCode'].post(%Q{{"mobilePhoneNumber": "#{params[:tel_num]}"}})
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
    end
    render json: res
  end

  def create
    @user = Manage::User.new({
      name: params[:tel_num],
      realname: params[:tel_num],
      phone: params[:tel_num],
      password: params[:password]
      })
    # 调用这个只是为了让它生成对应的errors数组
    @user.valid?

    if params[:valicode].blank?
      @user.errors.add(:vcode, "没有填写")
    else
      begin #验证短信
        msg_service_client["verifySmsCode/#{params[:valicode]}?mobilePhoneNumber=#{params[:tel_num]}"].post ''
      rescue RestClient::Exception => e
        response = JSON.parse(e.response)
        if response['code'] == 603
          @user.errors.add(:vcode, response['error'])
        else
          @user.errors.add(:vcode, '输入错误')
        end
      end
    end

    # 如果账户信息有错，那就返回
    if @user.errors.any?
      render :reg
    else
      if @user.save
        session[:user_id] = @user.id
        redirect_to usercenter_path, notice: "#{@user.name}, 注册成功！"
      else
        render :reg
      end
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
    @user = Manage::User.find_by_name(params[:id])
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

  def email_verify
    user = Manage::User.find_by(email: params[:email])
    if user && !user.is_email_verified? && user.authenticated?(:activation, params[:id])
      user.activate
      redirect_to user
    else
      redirect_to root_url
    end
  end

  # 重置密码
  def reset
  end
  def reset_handler
    @user = Manage::User.find_by_name(params[:tel_num])
    @user.password = params[:password]
    # 调用这个只是为了让它生成对应的errors数组
    @user.valid?

    if params[:valicode].blank?
      @user.errors.add(:vcode, "没有填写")
    else
      begin #验证短信
        msg_service_client["verifySmsCode/#{params[:valicode]}?mobilePhoneNumber=#{params[:tel_num]}"].post ''
      rescue RestClient::Exception => e
        response = JSON.parse(e.response)
        if response['code'] == 603
          @user.errors.add(:vcode, response['error'])
        else
          @user.errors.add(:vcode, '输入错误')
        end
      end
    end

    # 如果账户信息有错，那就返回
    if @user.errors.any?
      render :reset
    else
      if @user.save
        redirect_to user_login_path, notice: "密码修改成功"
      else
        render :reset
      end
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
