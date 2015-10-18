class Manage::CfgController < ManageController
  def index
    @manage_cfgs = Cfg.all
  end

  def update
    if @manage_cfgs.update(cfg_params)
      redirect_to manage_cfgs_url, notice: '修改成功'
    else
      render :edit
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_cfg
      @manage_cfg = Cfg.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_cfg_params
      params.require(:manage_cfg).permit(:value)
    end

end
