class Manage::CfgController < ManageController
  before_action :check_permission
  
  def index
    @manage_cfgs = Cfg.all
  end

  def update
    @manage_cfg = Cfg.find(params[:id])
    if @manage_cfg.update(value: params[:cfg_value])
      redirect_to manage_cfgs_url, notice: '修改成功'
    else
      redirect_to manage_cfgs_url,notice: "#{@manage_cfg.errors[:value].first}"
    end
  end

end
