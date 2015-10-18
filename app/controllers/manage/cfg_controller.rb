class Manage::CfgController < ManageController
  def index
    @manage_cfgs = Cfg.all
  end

  def update
    @manage_cfg = Cfg.find(params[:cfg_id])
    if @manage_cfg.update( value: params[:cfg_value])
      redirect_to manage_cfgs_url, notice: '修改成功'
    else
      # render :index
      redirect_to manage_cfgs_url,notice: "#{@manage_cfg.errors[:value].first}"
    end
  end

end
