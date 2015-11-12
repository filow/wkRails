class Manage::Creation < ActiveRecord::Base
  before_save :add_summary

  belongs_to :user
  has_many :creation_authors
  has_many :creation_comments
  has_many :creation_views
  has_many :creation_votes
  has_many :judges

  validates_presence_of :name, :desc

  enum status: [ :draft, :publishing, :published, :unpublishing ]

  mount_uploader :thumb, CreationThumbUploader
  #分页显示每页的个数
  paginates_per 10

  #用于前台的搜索功能
  def self.search(key_word)
    rs = where('name LIKE ? AND summary LIKE ?', "%#{key_word}%", "%#{key_word}%")
  end

  # 筛选出所有目前在前台展示的作品
  def self.onshow
    where(status: self.statuses[:published]).where(version: Cfg.version)

  end


  def self.ranklist
    onshow.order(popularity: :desc, vote_count: :desc, created_at: :desc)
  end

  #生成作品作者组成的字符串
  def authors_str
    names = self.creation_authors.select 'name'
    names.join(',')
  end

  def status_cn
    #翻译映射
    t = {
        draft: '草稿',
        publishing: '发布审核',
        published: '已发布',
        unpublishing: '撤销审核'
    }
    t[self.status.to_sym]
  end


  private
    #生成简介
    def add_summary
      #除去html标记
      desc = ApplicationController.helpers.strip_tags(self.desc)
      #截取desc
      self.summary = desc[0..83] << '...'
    end
end
