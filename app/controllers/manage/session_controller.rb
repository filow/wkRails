class Manage::SessionController < ManageController
  skip_filter :check_login
  layout false
  def index
    @record = get_record

    if @record[:times] >= 5
      @forbidden = true
      flash[:alert] = "您已失败#{@record[:times]}次，请过段时间重试"
      flash[:notice] = nil
    elsif @record[:times] >= 1
      @show_vcode = true
      flash[:notice] = "您已经连续登录失败#{@record[:times]}次，超过5次您将暂时无法登陆"
    end
  end

  def create
    prms = params.permit(:username, :password)
    @record = get_record
    # 超过5次禁止登陆
    if @record[:times] >= 5
      redirect_to manage_login_path
    else
      admin = Manage::Admin.find_by_name(prms[:username]).try(:authenticate, prms[:password])
      # 如果验证失败
      if admin
        session[:admin_id] = admin.id
        session[:admin_realname] = admin.realname
        session[:admin_name] = admin.name
        redirect_to manage_path
      else
        @record = record_fail
        session[:last_login_user] = prms[:username]
        redirect_to manage_login_path
      end
    end

  end

  def destroy
    # 一般判断都只用一个 admin_id 就好了
    session[:admin_id] = nil
    redirect_to manage_login_path
  end

  def vcode
    response.headers['Cache-Control'] = "private, max-age=0, no-store, no-cache, must-revalidate"
    response.headers['Pragma'] = "no-cache"
    image = VerifyCode.build()
    # 给session设置vcode
    session[:manage_vcode] = image[:code]
    # 把二进制数据发送给服务器
    send_data image[:blob], type: "image/png", disposition: 'inline'
  end

private
  def record_fail
    expires = 10.minute;
    record = @cache[login_cache_key]
    if record
      new_record = {times: record[:times]+1, last_try: Time.now}
    else
      new_record = {times: 1, last_try: Time.now}
    end
    @cache[login_cache_key, expires] = new_record
    new_record
  end

  def get_record
    record = @cache[login_cache_key]
    if record
      record
    else
      {times: 0, last_try: Time.now}
    end
  end

  def login_cache_key
    'login_session' + request.remote_ip
  end

end