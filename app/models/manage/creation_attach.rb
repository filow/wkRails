class Manage::CreationAttach < ActiveRecord::Base
  mount_uploader :filename, CreationVideoUploader
  enum stat: [ :wait, :transcoding, :done, :fail ]
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
