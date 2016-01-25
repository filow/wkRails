class Manage::CfgController < ManageController
  before_action :check_permission

  def index
    @manage_cfgs = Cfg.where.not(key: 'index_intro')
  end

  def intro
    @intro = JSON.parse(Cfg.find_by_key('index_intro').value)
  end

  def add_intro
    new_intro = params.permit(:id, :name, :p_id, :anchor)
    if new_intro[:id].blank?
      redirect_to manage_cfg_intro_path, alert: '序号不能为空'
      return
    end

    Cfg.transaction do
      cfg_intro = Cfg.find_by_key('index_intro')
      intro = JSON.parse(cfg_intro.value)
      intro << new_intro
      # 根据序号排序
      intro.sort_by!{ |i| i['id'].to_i }

      if cfg_intro.update(value: intro.to_json)
        redirect_to manage_cfg_intro_path, notice: '添加成功'
      else
        redirect_to manage_cfg_intro_path, alert: '添加失败，请重试'
      end
    end
  end

  def delete_intro
    cfg_intro = Cfg.find_by_key('index_intro')
    intro = JSON.parse(cfg_intro.value)
    intro.delete_if{ |i| i['id'].to_i == params[:id].to_i }

    if cfg_intro.update(value: intro.to_json)
      redirect_to manage_cfg_intro_path, notice: '删除成功'
    else
      redirect_to manage_cfg_intro_path, alert: '删除失败，请重试'
    end
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
