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

  def exp_video
    @videos = Manage::Expvideo.all
  end
  def delete_video
    video = Manage::Expvideo.find(params[:id])
    if video.destroy
      redirect_to manage_cfg_exp_video_url, notice: '删除成功'
    else
      redirect_to manage_cfg_exp_video_url, alert: "删除失败 #{video.errors.full_messages.join(' ')}"
    end
  end
  def upload_video
    video = Manage::Expvideo.new(name: params[:name], author: params[:author], video: params[:Filedata])
    if video.save
      render json: {success: true, message: '上传成功', id: video.id, url: video.video.url}
    else
      render json: {success: false, message: video.errors.full_messages.join(' ')}
    end
  end

  def screenshot
    exp = Manage::Expvideo.find(params[:id])
    movie_url = Rails.root.join('./public' + exp.video.url).to_s

    movie = FFMPEG::Movie.new(movie_url)

    spt_url = exp.video.url.split('.')
    spt_url[-1] = 'jpg'
    # /upload/exp_video/id/something.jpg
    image_url = spt_url.join('.')

    movie.screenshot(Rails.root.join('./public' + image_url).to_s, seek_time: params[:time], resolution: movie.resolution, preserve_aspect_ratio: :width)
    exp.thumb = true
    exp.save
    render json: {url: image_url}
  end
end
