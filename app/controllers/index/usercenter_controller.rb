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

    creation = Manage::Creation.generate(@user)
    redirect_to edit_creation_url(creation)

  end

  def creation_detail
    @creation = @user.creations.find(params[:id])
    p @creation.ppt.file
    respond_to do |format|
      # format.html {  }
      format.json
    end
  end


  def edit_creation
    @creation = @user.creations.find(params[:id])

  end

  def update_creation
    @creation = @user.creations.find(params[:id])
    creation_params = params.permit(:name, :thumb, :doc, :ppt, :desc)
    @creation.update(creation_params)
    @creation.authors = params[:authors]

    if @creation.errors.any?
      render :edit_creation
    else
      redirect_to usercenter_creations_path, notice: '作品已修改成功'
    end

  end

  def delete_creation
    @creation = @user.creations.find(params[:id])
    @creation.destroy
    render json: {code: 200}
  end

  def publish_creation
    @creation = @user.creations.find(params[:id])
    if @creation.request_publish
      render json: {success: true}
    else
      render json: {success: false, errors: @creation.errors}
    end
  end

  def unpublish_creation
    @creation = @user.creations.find(params[:id])
    if @creation.request_unpublish
      render json: {success: true}
    else
      render json: {success: false, errors: @creation.errors}
    end
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
