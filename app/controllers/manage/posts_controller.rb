class Manage::PostsController < ManageController
  before_action :set_manage_post, only: [:show, :edit, :update, :destroy]

  # GET /manage/posts
  # GET /manage/posts.json
  def index
    @manage_posts = Manage::Post.all
  end

  # GET /manage/posts/1
  # GET /manage/posts/1.json
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
  # POST /manage/posts.json
  def create
    @manage_post = Manage::Post.new(manage_post_params)

    respond_to do |format|
      if @manage_post.save
        format.html { redirect_to @manage_post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @manage_post }
      else
        format.html { render :new }
        format.json { render json: @manage_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/posts/1
  # PATCH/PUT /manage/posts/1.json
  def update
    respond_to do |format|
      if @manage_post.update(manage_post_params)
        format.html { redirect_to @manage_post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @manage_post }
      else
        format.html { render :edit }
        format.json { render json: @manage_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/posts/1
  # DELETE /manage/posts/1.json
  def destroy
    @manage_post.destroy
    respond_to do |format|
      format.html { redirect_to manage_posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_post
      @manage_post = Manage::Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_post_params
      params.require(:manage_post).permit(:title, :content, :content_notag, :valid_from, :is_top, :is_hide)
    end
end
