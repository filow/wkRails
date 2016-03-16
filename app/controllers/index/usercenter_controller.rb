class Index::UsercenterController < IndexController
  before_action :set_sidebar
  before_action :set_creation, only: [:creation_detail, :edit_creation, :update_creation, :edit_attach, :submit_attach, :transcode_attach, :delete_attach, :delete_creation, :publish_creation, :unpublish_creation]
  before_action :check_version, only: [:edit_creation, :update_creation, :edit_attach, :submit_attach, :transcode_attach, :delete_attach, :delete_creation, :delete_creation, :publish_creation, :unpublish_creation]

  def index
    @messages = @user.messages.order(created_at: :desc).limit(5)
    @current_creations = @user.creations.where(version: Cfg.version)
  end

  # 消息箱相关
  def messages
    @messages = @user.messages.order(created_at: :desc)
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

  def show_msg
    @msg = @user.messages.find_by_id(params[:id])
    if @msg
      @msg.update_column(:is_readed, true)
      render json: {code: 200, data: @msg}
    else
      render json: {code: 403, data: {}}
    end
  end

  # 修改个人信息
  def profile
  end

  def profile_handler
    param = params.permit(:realname, :password, :sex, :group, :department, :phone, :email, :avatar)
    @user.update(param)
    render :profile
  end

  # 已投票的作品
  def voted
    @voted = @user.creation_votes.order(created_at: :desc)
  end

  #  已评论的作品
  def commented
    @commented = @user.creation_comments.order(created_at: :desc)
  end

  # ======== 作品相关 ========
  def creations
    # 检查权限
    @user.validate_creation_upload_privilege
    @creations = @user.creations.where(version: Cfg.version)
    @creations_old = @user.creations.where('version != ?', Cfg.version)
  end

  # 新建一个作品
  def create_creation
    creation = Manage::Creation.generate(@user)
    redirect_to edit_creation_url(creation)
  end

  # 查看作品详情
  def creation_detail
    respond_to do |format|
      # format.html {  }
      format.json
    end
  end

  # 编辑作品信息
  def edit_creation
  end

  def update_creation
    creation_params = params.permit(:name, :thumb, :doc, :ppt, :desc)
    @creation.update(creation_params)
    @creation.authors = params[:authors]

    if @creation.errors.any?
      render :edit_creation
    else
      redirect_to edit_attach_path(@creation), notice: '作品已修改成功'
    end

  end

  # 作品附件
  def edit_attach
    @videos = @creation.creation_attaches
  end

  def submit_attach
    unless @creation.creation_attaches.count >= Cfg.get('upload_max_count').to_i
      file = params[:Filedata]
      attach = Manage::CreationAttach.new(filename: file, original_filename: file.original_filename, mime: file.content_type, creation_id: @creation.id)
      attach.stat = :done
      if attach.save
        render json: {success: true, message: '上传成功'}
      else
        render json: {success: false, message: attach.errors.full_messages.join(' ')}
      end
    else
      render json: {success: false, message: '您上传的文件数量已经满额'}
    end
  end

  # 转码
  def transcode_attach
    attach = @creation.creation_attaches.find(params[:attach_id])
    attach.transcode
    redirect_to edit_attach_url(creation), notice: '申请转码成功'
  end

  # 删除附件
  def delete_attach
    @attach = @creation.creation_attaches.find(params[:attach_id])
    if @attach.destroy
      redirect_to edit_attach_url(@creation), notice: '删除成功'
    else
      redirect_to edit_attach_url(@creation), alert: '删除失败'
    end
  end

  # 删除作品
  def delete_creation
    @creation.destroy
    render json: {code: 200}
  end

  # 发布和取消发布
  def publish_creation
    if @creation.request_publish
      render json: {success: true}
    else
      render json: {success: false, errors: @creation.errors}
    end
  end

  def unpublish_creation
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

  def set_creation
    @creation = @user.creations.find(params[:id])
  end

  def check_version
    if @creation.version != Cfg.version
      redirect_to usercenter_creations_path, notice: '抱歉，您不能编辑往届作品'
    end
  end
end
