class Index::CreationController < IndexController
  before_action :set_creation, only: [:show, :vote, :unvote, :show_comment, :comment, :uncomment, :play]

  def index
    @creations = []
    if params['type'] == 'old'
      @creations = Manage::Creation.old
    else
      @creations = Manage::Creation.onshow
    end
    if params[:order]
      case params[:order]
      when 'vote'
        @creations = @creations.order(vote_count: :desc)
      when 'comment'
        @creations = @creations.order(comment_count: :desc)
      when 'view'
        @creations = @creations.order(view_count: :desc)
      else
        @creations = @creations.order(updated_at: :desc)
      end
    end
    if params[:history]
      @creations = @creations.where(version: params[:history])
    end
    @creations = @creations.page(params[:page])
  end

  def show
    @user = Manage::User.find_by_id session[:user_id]
    @creation.viewpage(request.remote_ip, request.user_agent, request.referer)
    # 如果作品目前不是发布状态，那么就无法显示
    unless @creation.published?
      redirect_to creations_path, notice: '该作品目前还未公开发布'
    end
    @other_creations = @creation.user.creations.onshow.where.not(id: @creation.id)
    @posts = Post.valid_posts.order(is_top: :desc, publish_at: :desc, id: :desc).select(:id, :title, :publish_at).limit(6)
    @comments = @creation.valid_comments.order(created_at: :desc).page(params[:page])
  end

  def vote
    user = Manage::User.find_by_id session[:user_id]
    if user
      if @creation.vote(user.id, request.remote_ip)
        render json: {status: true, msg: '投票成功', votes: @creation.vote_count}, status: :ok
      else
        render json: {status: false, msg: @creation.errors[:vote].join(' ')}, status: :ok
      end

    else
      render json: {status: false, msg: '您还未登录'}, status: :unauthorized
    end
  end

  def unvote
    user = Manage::User.find_by_id session[:user_id]
    if user
      @creation.unvote(user.id)
      render json: {status: true, msg: '取消投票成功', votes: @creation.vote_count - 1}, status: :ok
    else
      render json: {status: false, msg: '您还未登录'}, status: :unauthorized
    end
  end


  def show_comment
    @comments = @creation.creation_comments.where(is_hidden: false).order(created_at: :desc).page(params[:page]).per(10)
  end


  def comment
    user = Manage::User.find_by_id session[:user_id]
    if user
      if @creation.comment(user.id, request.remote_ip, params[:comment])
        render json: {status: 200, msg: '评论发表成功'}
      else
        render json: {status: 403, msg: @creation.errors[:comment].join("\n")}
      end
    else
      render json: {status: 401, msg: '您还未登录'}
    end
  end

  def uncomment
    user = Manage::User.find_by_id session[:user_id]
    if user
      @creation.uncomment(user.id, params[:cid])
      render json: {status: true, msg: '评论已删除', votes: @creation.comment_count - 1}, status: :ok
    else
      render json: {status: false, msg: '您还未登录'}, status: :unauthorized
    end
  end

  def play
    @creation = Manage::Creation.find_by_name(params[:id])
    @attach = @creation.creation_attaches.find(params[:attach_id])
  end

private
  def set_creation
    @creation = Manage::Creation.find_by_name!(params[:id])
  end
end
