class Index::CreationController < IndexController
  before_action :set_creation, only: [:show, :vote, :unvote, :comment, :uncomment]

  def index
    @creations = []
    if params['type'] == 'old'
      @creations = Manage::Creation.where 'version < ?', Cfg.get('current_version')
    else
      @creations = Manage::Creation.where version: Cfg.get('current_version').to_i
    end
  end

  def show
    @creations = @creation.user.creations.where.not(id: @creation.id)
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
private
  def set_creation
    @creation = Manage::Creation.find_by_name(params[:id])
  end
end
