class Manage::CommentController < ManageController
  def index
    @unviewed_comments = Manage::CreationComment.where(is_viewed: false).order(created_at: :desc).page(params[:page])
    @viewed_comments = Manage::CreationComment.where(is_viewed: true, is_hidden: false).order(created_at: :desc).page(params[:page])
    @hidden_comments = Manage::CreationComment.where(is_hidden: true).order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def update
  end

  def destroy
  end
end
