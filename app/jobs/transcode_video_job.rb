class TranscodeVideoJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # 设置成转码中
    attach = Manage::CreationAttach.find(args[0])
    attach.stat = :transcoding
    attach.save
    # 源文件地址和目标文件
    url = './public' + attach.filename.url.to_s
    dest = url.sub(/\.\w+$/,'_trans.mp4')

    movie = FFMPEG::Movie.new(url)
    puts "#{Time.now.to_s} 开始转码ID为#{args[0]}的视频，原视频名称为：#{attach.original_filename}, 编码：#{movie.video_codec}，分辨率#{movie.resolution}"
    options = {
      video_codec: "libx264",
      resolution: "720x576",
      preserve_aspect_ratio: :width,
      x264_vprofile: "high",
      threads: 2
    }
    
    if movie.valid?
      movie.transcode(dest, options) do |progress|
        attach.progress = progress * 100
        attach.save
      end
      puts "#{Time.now.to_s} 转码完成"
      attach.stat = :done
      # 把新文件挪过去
      File.open(dest) {|f| attach.filename = f; attach.save}
      # 删除多余文件
      File.unlink(dest)
    else
      puts "视频有问题，转码失败"
      attach.stat = :fail
      attach.save
    end

  end
end
