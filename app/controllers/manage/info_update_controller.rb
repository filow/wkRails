class Manage::InfoUpdateController < ManageController
  before_action :set_manage_admin

  def index
  end

  def update
    prms = params.permit(:old_password, :vcode)
    # 要检查验证码是否正确
    if prms[:vcode].nil? || prms[:vcode].upcase != session[:manage_vcode]
      redirect_to manage_info_update_path, notice: '请输入正确的验证码'
      return
    end
    admin = Manage::Admin.find_by_name(@manage_admin.name).try(:authenticate, prms[:old_password])
    # 如果验证失败
    if admin
      if @manage_admin.update(manage_admin_params)
        render :success
      else
        render :index
      end
    else
      redirect_to manage_info_update_path, notice: "原密码错误，修改个人信息失败"
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_manage_admin
    @manage_admin = Manage::Admin.find(session[:admin_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def manage_admin_params
    params.require(:manage_admin).permit(:name, :password, :realname, :is_forbidden)
  end
end
