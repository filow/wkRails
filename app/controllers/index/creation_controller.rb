class Index::CreationController < IndexController
  def index
    @creations = []
    if params['type'] == 'old'
      @creations = Manage::Creation.where 'version < ?', Cfg.get('current_version')
    else
      @creations = Manage::Creation.where version: Cfg.get('current_version').to_i
    end
  end

  def show
    @creation = Manage::Creation.find_by_name(params[:id])
  end

  def vote
  end

  def comment
  end
end
