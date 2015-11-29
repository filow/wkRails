class Index::IndexController < IndexController
  def index
    @posts = Post.valid_posts.order(is_top: :desc, publish_at: :desc, id: :desc).select(:id, :title, :publish_at).limit(6)

    #用户
    unless session[:user_id].blank?
      @user = Manage::User.find_by_id session[:user_id]
      if @user.nil?
        session.delete(:user_id)
      end
    end

    #下面处理海报列表
    @posters = Cfg.get_all('broadcast_img').reject{|x| x.blank?}
    if @posters.empty?
      @posters.push('index/poster.jpg')
    end
    # 排行榜
    @opus_rank = Manage::Creation.ranklist.limit(7)
    @user_rank = Manage::User.ranklist.limit(7)

    # 示例视频
    @exp_video = Manage::Expvideo.all


    # 作品展示
    @random_video = Manage::Creation.random.limit(4)
  
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
