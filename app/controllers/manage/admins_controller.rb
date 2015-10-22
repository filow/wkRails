class Manage::AdminsController < ManageController
  before_action :set_manage_admin, only: [:show, :edit, :update, :destroy]

  # GET /manage/admins
  def index
    @manage_admins = Manage::Admin.all
    @manage_roles  = Manage::Role.all
  end

  # GET /manage/admins/1
  def show
  end

  # GET /manage/admins/new
  def new
    @manage_admin = Manage::Admin.new
  end

  # GET /manage/admins/1/edit
  def edit
  end

  def edit_self
  end

  def update_self
    prms = params.permit(:old_password, :vcode)
    # 要检查验证码是否正确
    if prms[:vcode].nil? || prms[:vcode].upcase != session[:manage_vcode]
      redirect_to manage_admins_edit_self_path, alert: '请输入正确的验证码'
      return
    end
    admin = @admin.try(:authenticate, prms[:old_password])
    # 如果验证失败
    if admin
      if @admin.update(manage_admin_params)
        redirect_to manage_admins_edit_self_path, notice: '修改成功'
      else
        render :edit_self
      end
    else
      redirect_to manage_admins_edit_self_path, alert: '原密码错误，修改个人信息失败'
    end
  end

  # POST /manage/admins
  def create
    @manage_admin = Manage::Admin.new(manage_admin_params)

    if @manage_admin.save
      redirect_to @manage_admin, notice: "新的管理员 #{@manage_admin.name} 创建成功！"
    else
      render :new
    end
  end

  # PATCH/PUT /manage/admins/1
  def update
    if @manage_admin.update(manage_admin_params)
      redirect_to manage_admins_url, notice: '修改成功'
    else
      render :edit
    end
  end

  # DELETE /manage/admins/1
  def destroy
    @manage_admin.destroy
    redirect_to manage_admins_url, notice: '管理员账户删除成功'
  end

  #查看角色权限
  def show_role
    @manage_role = Manage::Role.find(params[:id])
    render :show_role, layout: false
  end

  #创建角色
  def create_role
    @manage_role = Manage::Role.new(name: params[:name])
    if @manage_role.save
      redirect_to manage_admins_url, notice: "新的角色 #{@manage_role.name} 创建成功！"
    else
      redirect_to manage_admins_url, notice: "#{@manage_role.errors[:name].first}"
    end
  end

  #更新角色权限
  def update_role
    @manage_role = Manage::Role.find(params[:id])
    @manage_role.nodes.clear
    p @new_nodes
    if params[:new_nodes] && @manage_role.nodes << Manage::Node.find(params[:new_nodes])
      redirect_to manage_admins_url, notice: '修改角色权限成功'
    else
      redirect_to manage_admins_url, notice: "#{@manage_role.errors[:name].first}"
    end
  end

  #删除角色
  def destroy_role
    @manage_role = Manage::Role.find(params[:id])
    @manage_role.destroy
    redirect_to manage_admins_url,notice: '角色删除成功'
  end

  #修改角色权限
  def edit_role_permission
    @manage_role = Manage::Role.find(params[:id])
    # render :edit_role_permission,layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_admin
      @manage_admin = Manage::Admin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_admin_params
      params.require(:manage_admin).permit(:name, :password, :realname, :is_forbidden)
    end
    def manage_role_params
      params.require(:manage_role).permit(:name, :is_enabled)
    end
end
