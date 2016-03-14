class Manage::CreationAttach < ActiveRecord::Base
  mount_uploader :filename, CreationVideoUploader
  before_save :transcode
  enum stat: [ :wait, :transcoding, :done ]
  StatMap = {
    wait: '等待转码',
    transcoding: '转码中',
    done: '正常'
  }
  def stat_cn
    StatMap[self.stat.to_sym]
  end

  def transcode
    if mime =~ /^video/
      errors.add(:filename, 'Video!')
    else
      self.stat = :done
    end
  end
end
