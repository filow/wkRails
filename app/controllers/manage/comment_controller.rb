class Manage::CommentController < ManageController
  def index
    @manage_comments = Manage::CreationComment.order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def update
  end

  def destroy
  end
end
