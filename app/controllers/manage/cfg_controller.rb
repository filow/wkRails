class Manage::CfgController < ManageController
  def index
    @manage_cfgs = Cfg.all
  end

  def update
    @manage_cfg = Cfg.find(params[:id])
    if @manage_cfg.field_type == 'img'
      uploader = PosterUploader.new
      #先删除原图片
      uploader.retrieve_from_store! @manage_cfg.value unless @manage_cfg.value.blank?
      uploader.remove! unless uploader.file.nil?
      #存储图片
      uploader.store! params[:cfg_value]
      #更新文件名，以便下面修改数据
      params[:cfg_value] = uploader.filename
    end
    if @manage_cfg.update(value: params[:cfg_value])
      redirect_to manage_cfgs_url, notice: '修改成功'
    else
      redirect_to manage_cfgs_url,notice: "#{@manage_cfg.errors[:value].first}"
    end
  end

end
