class Manage::AdminsController < ManageController
  before_action :set_manage_admin, only: [:show, :edit, :update, :destroy]

  # GET /manage/admins
  def index
    unless can?("list")
      # 需要修改，合适的反馈错误的方案
      redirect_to manage_url, alert: "您没有查看管理员的权限"
    else
      @manage_admins = Manage::Admin.all
      @manage_roles  = Manage::Role.all
    end
  end

  # GET /manage/admins/1
  def show
    unless can?("show")
      redirect_to manage_admins_url, alert: "您没有该项权限"
    else
      @manage_admin_permissions = @manage_admin.child_nodes
    end
  end

  # GET /manage/admins/new
  def new
    unless can?("add")
      redirect_to manage_admins_url, alert: "您没有添加管理员的权限"
    else
      @manage_admin = Manage::Admin.new
    end
  end

  # GET /manage/admins/1/edit
  def edit
    redirect_to manage_admins_url, alert: "您没有编辑管理员的权限" unless can?("edit")
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
    #验证原密码
    admin = @admin.try(:authenticate, prms[:old_password])
    if admin
      #原密码正确
      if @admin.update(manage_admin_params)
        session[:admin_realname] = @admin.realname
        redirect_to manage_admins_edit_self_path, notice: '修改成功'
      else
        render :edit_self
      end
    else
      #原密码错误
      redirect_to manage_admins_edit_self_path, alert: '原密码错误，修改个人信息失败'
    end
  end

  # POST /manage/admins
  def create
    # 没有权限则直接跳转回管理员列表
    return redirect_to manage_admins_url, alert: "您没有新建管理员的该项权限" unless can?("add")
    #如果有权限则继续
    @manage_admin = Manage::Admin.new(manage_admin_params)
    if @manage_admin.save
      if params[:new_roles] == nil #如果没有传回数组，则当做没有角色
        redirect_to manage_admins_url, notice: "新的管理员 #{@manage_admin.name} 创建成功！"
      elsif @manage_admin.roles << Manage::Role.find(params[:new_roles])
        redirect_to manage_admins_url, notice: "新的管理员 #{@manage_admin.name} 创建成功！"
      else
        redirect_to manage_admins_url, alert: "#{@manage_admin.errors[:name].first}"
      end
    else
      render :new
    end
  end

  # PATCH/PUT /manage/admins/1
  def update
    #避免“切换锁定”跳过 admins#edit
    return redirect_to manage_admins_url, alert: "您没有该项权限" unless can?("edit")
    #如果有权限则继续
    if @manage_admin.update(manage_admin_params)
      #如果成功更新了信息，并且没有更改锁定状态,则清空admin.roles，否则不更新admin.roles
      @manage_admin.roles.clear if manage_admin_params[:is_forbidden] == nil
      if params[:new_roles] == nil #如果没有传回数组，则当做没有角色
        redirect_to manage_admins_url, notice: '修改角色成功'
      elsif @manage_admin.roles << Manage::Role.find(params[:new_roles])
        redirect_to manage_admins_url, notice: '修改角色成功'
      else
        redirect_to manage_admins_url, alert: "#{@manage_admin.errors[:name].first}"
      end
    else
      render :edit
    end
  end

  # DELETE /manage/admins/1
  def destroy
    unless can?("delete")
      redirect_to manage_admins_url, alert: '您没有删除管理员的权限权限'
    else
      @manage_admin.destroy
      redirect_to manage_admins_url, notice: '管理员账户删除成功'
    end
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
      redirect_to manage_admins_url, alert: "#{@manage_role.errors[:name].first}"
    end
  end

  #更新角色权限
  def update_role
    @manage_role = Manage::Role.find(params[:id])
    @manage_role.nodes.clear
    if params[:new_nodes] == nil#如果没有传回数组，则当做没有权限
      redirect_to manage_admins_url, notice: '修改角色权限成功'
    elsif  @manage_role.nodes << Manage::Node.find(params[:new_nodes])
      redirect_to manage_admins_url, notice: '修改角色权限成功'
    else
      redirect_to manage_admins_url, alert: "#{@manage_role.errors[:name].first}"
    end
    @manage_role.save
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
