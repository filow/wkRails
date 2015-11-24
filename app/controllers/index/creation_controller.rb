class Index::CreationController < IndexController
  def index
  end

  def show
    @creation = Manage::Creation.find_by_name(params[:id])
  end

  def vote
  end

  def comment
  end
end
