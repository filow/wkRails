class Manage::SessionController < ApplicationController
  def index
  end

  def create
    p params
    redirect_to manage_login_path
  end

  def destroy
  end

  def vcode
    response.headers['Cache-Control'] = "private, max-age=0, no-store, no-cache, must-revalidate"
    response.headers['Pragma'] = "no-cache"
    response.headers['content-type'] = "image/png"
    image = VerifyCode.build()
    # 给session设置vcode
    session[:manage_vcode] = image[:code]
    render text: image[:blob]
  end

end
