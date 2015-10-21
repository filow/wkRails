class Index::IndexController < IndexController
  def index
    @posts = Post.valid_posts.order(is_top: :desc, publish_at: :desc, id: :desc).select(:id, :title, :publish_at).limit(6)
  end
end
