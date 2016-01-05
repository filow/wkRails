class Index::UsercenterController < IndexController
  before_action :set_sidebar

  def index
    @messages = @user.messages.order(created_at: :desc).limit(5)
    @current_creations = @user.creations.where(version: Cfg.version)
  end

  def set_read_msg
    @msg = @user.messages.find_by_id(params[:id])
    if @msg
      @msg.update_column(:is_readed, true)
      render json: {code: 200}
    else
      render json: {code: 403}
    end
  end

  def messages
    @messages = @user.messages.order(created_at: :desc)
  end

  def show_msg
    @msg = @user.messages.find_by_id(params[:id])
    if @msg
      @msg.update_column(:is_readed, true)
      render json: {code: 200, data: @msg}
    else
      render json: {code: 403, data: {}}
    end
  end

  def profile
  end

  def profile_handler
    param = params.permit(:realname, :password, :sex, :group, :department, :phone, :email, :avatar)
    @user.update(param)
    render :profile
  end

  def voted
    @voted = @user.creation_votes.order(created_at: :desc)
  end

  def commented
    @commented = @user.creation_comments.order(created_at: :desc)
  end

  def creations
    # 检查权限
    @user.validate_creation_upload_privilege
    @creations = @user.creations.where(version: Cfg.version)
    @creations_old = @user.creations.where('version != ?', Cfg.version)
  end

  def create_creation

    default_author = Manage::CreationAuthor.new({
      name: @user.realname,
      sex: @user.sex,
      department: @user.department,
      phone: @user.phone,
      email: @user.email
    })
    @authors = [default_author]

  end
private
  def set_sidebar
    if session[:user_id].blank?   #未登录
      redirect_to user_login_path, notice: '请先登陆'
      return
    end
    @user = Manage::User.find_by_id session[:user_id]
    unless @user    #没有登陆用户的信息
      redirect_to root_path
      return
    end
  end
end
