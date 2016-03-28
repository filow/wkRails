class Index::CreationController < IndexController
  before_action :set_creation, only: [:show, :vote, :unvote, :comment, :uncomment, :play]

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
    @other_creations = @creation.user.creations.where.not(id: @creation.id)
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

  def comment
    user = Manage::User.find_by_id session[:user_id]
    if user
      if @creation.comment(user.id, request.remote_ip, params[:comment])
        redirect_to :back, notice: '评论发表成功'
      else
        redirect_to :back, alert: @creation.errors[:comment].join("\n")
      end
    else
      redirect_to :back, alert: '您还未登录'
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
    @creation = Manage::Creation.find_by_name(params[:id])
  end
end
