class Manage::CreationAttach < ActiveRecord::Base
  mount_uploader :filename, CreationVideoUploader
  enum stat: [ :wait, :transcoding, :done, :fail ]
  validates :filename, file_size: {:less_than => Cfg.get('upload_max_size').to_i.megabytes.to_i, only: [:create]}
  StatMap = {
    wait: '等待转码',
    transcoding: '转码中',
    done: '正常',
    fail: '转码失败'
  }
  def stat_cn
    StatMap[self.stat.to_sym]
  end

  def transcode
    self.stat = :wait
    self.save
    TranscodeVideoJob.perform_later(self.id)
  end

end
