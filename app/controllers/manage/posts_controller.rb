class Manage::PostsController < ManageController
  before_action :set_manage_post, only: [:show, :edit, :update, :destroy]

  # GET /manage/posts
  def index
    @posts = Post.order(publish_at: :desc).page(params[:page])
  end

  # GET /manage/posts/1
  def show
  end

  # GET /manage/posts/new
  def new
    @post = Post.new(publish_at: Date.today)
  end

  # GET /manage/posts/1/edit
  def edit
  end

  # POST /manage/posts
  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to [:manage, @post], notice: "成功添加#{@post.title}"
    else
      render :new
    end
  end

  # PATCH/PUT /manage/posts/1
  def update
    if @post.update(post_params)
      redirect_to manage_posts_url, notice: '修改成功'
    else
      render :edit
    end
  end

  # DELETE /manage/posts/1
  def destroy
    @post.destroy
    redirect_to manage_posts_url, notice: '删除成功'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :publish_at, :is_top, :is_hide)
    end
end
