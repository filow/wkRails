class Index::PassageController < ApplicationController
  def show
    # 设置页面标题为文章标题
    @post = Post.find(params[:id])
    @title = @post.title
  end
end
