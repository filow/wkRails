class Index::IndexController < IndexController
  def index
    @posts = Post.valid_posts.order(is_top: :desc, publish_at: :desc, id: :desc).select(:id, :title, :publish_at).limit(6)
  end

  def search
    @kw = params[:q]
    #搜索结果
    @result = {}
    @result[:posts] = Post.search @kw
    @result[:users] = Manage::User.search @kw
    @result[:creations] = Manage::Creation.search @kw
    #结果数量
    @count = { posts: 0, users: 0, creations: 0 }
    @count[:posts] = @result[:posts].count
    @count[:creations] = @result[:creations].count
    @count[:users] = @result[:users].count
  end
end
