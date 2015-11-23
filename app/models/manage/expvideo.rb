class Manage::Expvideo < ActiveRecord::Base
  mount_uploader :video, ExpvideoUploader
  before_destroy :delete_thumb


  def thumb_url
    video_url_spt = video.url.split('.')
    video_url_spt[-1] = 'jpg'
    video_url_spt.join('.')
  end

  def delete_thumb
    thumb_path = Rails.root.join('./public' + thumb_url)
    File.delete(thumb_path)
    true
  end
end
