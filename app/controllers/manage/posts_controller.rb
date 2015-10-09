class Manage::PostsController < ManageController
  before_action :set_manage_post, only: [:show, :edit, :update, :destroy]

  # GET /manage/posts
  def index
    @manage_posts = Manage::Post.order(valid_from: :desc).all
  end

  # GET /manage/posts/1
  def show
  end

  # GET /manage/posts/new
  def new
    @manage_post = Manage::Post.new
  end

  # GET /manage/posts/1/edit
  def edit
  end

  # POST /manage/posts
  def create
    @manage_post = Manage::Post.new(manage_post_params)

    if @manage_post.save
      redirect_to @manage_post, notice: "成功添加#{@manage_post.title}"
    else
      render :new
    end
  end

  # PATCH/PUT /manage/posts/1
  def update
    if @manage_post.update(manage_post_params)
      redirect_to manage_posts_url, notice: '修改成功'
    else
      render :edit
    end
  end

  # DELETE /manage/posts/1
  def destroy
    @manage_post.destroy
    redirect_to manage_posts_url, notice: '删除成功'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_post
      @manage_post = Manage::Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_post_params
      params.require(:manage_post).permit(:title, :content, :valid_from, :is_top, :is_hide)
    end
end
