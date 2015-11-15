class Index::CreationController < IndexController
  def index
  end

  def show
    @creation = Manage::Creation.find(params[:id])
  end

  def vote
  end

  def comment
  end
end
