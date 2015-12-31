class Manage::CommentController < ManageController
  before_action :set_comment, only: [:show, :hide, :destroy, :view]

  def index
    @unviewed_comments = Manage::CreationComment.where(is_viewed: false).order(created_at: :desc).page(params[:page])
  end

  def viewed
    @viewed_comments = Manage::CreationComment.where(is_viewed: true, is_hidden: false).order(created_at: :desc).page(params[:page])
  end

  def hidden
    @hidden_comments = Manage::CreationComment.where(is_hidden: true).order(created_at: :desc).page(params[:page])
  end

  def show
    @creation = @comment.creation
    @user = @comment.user
  end

  def hide
    if @comment.update(is_viewed: true, is_hidden: !@comment.is_hidden)
      redirect_to :back
    else
      redirect_to :back, alert: '操作失败，请重试！'
    end
  end

  def view
    if @comment.update(is_viewed: true)
      redirect_to :back
    else
      redirect_to :back, alert: '操作失败，请重试！'
    end
  end

  def destroy
    @comment.destroy
    redirect_to :back, alert: '删除成功！'
  end

  private
    def set_comment
      @comment = Manage::CreationComment.find(params[:id])
    end
end
