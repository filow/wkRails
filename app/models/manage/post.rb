class Manage::Post < ActiveRecord::Base
  #在存储前添加content_notag
  before_save :add_content_notag

  #标题，内容，生效时间不允许空
  validates :title, :content, :valid_from, presence: true

  private
    #用于添加content_notag字段
    def add_content_notag
      self.content_notag=ApplicationController.helpers.strip_tags(self.content)
    end
end
