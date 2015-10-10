class Manage::Post < ActiveRecord::Base
  #在存储前添加content_notag
  before_save :add_content_notag

  #标题，内容，生效时间不允许空
  validates :title, :content, :publish_at, presence: true
  #标题不允许重复
  validates :title, uniqueness: true

  def self.valid_posts
    where 'publish_at >= ? and is_hide = ?', Date.today, false
  end

  def published?
    # 如果publish非空就判断是否比今天的时间小，在nil的情况下认为所有的都发布了
    unless publish_at.nil?
      publish_at <= Date.today
    else
      true
    end
  end
  private
    #用于添加content_notag字段
    def add_content_notag
      self.content_notag=ApplicationController.helpers.strip_tags(self.content)
    end
end
