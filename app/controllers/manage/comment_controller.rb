class Manage::CommentController < ManageController
  before_action :set_comment, only: [:show, :hide, :destroy]

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
  end

  def hide
  end

  def destroy
  end

  private
    def set_comment
      @comment = Manage::CreationComment.find(params[:id])
    end
end
