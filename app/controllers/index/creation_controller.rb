class Index::CreationController < IndexController
  before_action :set_creation, only: [:show, :vote, :comment]

  def index
  end

  def show
  end

  def vote
    user = Manage::User.find_by_id session[:user_id]
    if user
      if @creation.vote(user, request.remote_ip)
        render json: [status: true, msg: '投票成功'], status: :ok
      else
        render json: [status: false, msg: @creation.errors[:vote].join(' ')], status: :ok
      end

    else
      render json: [status: false, msg: '您还未登录'], status: :unauthorized
    end
  end

  def comment
  end
private
  def set_creation
    @creation = Manage::Creation.find_by_name(params[:id])

  end
end
