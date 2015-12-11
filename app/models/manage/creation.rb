class Manage::Creation < ActiveRecord::Base
  before_save :add_summary
  # 统计字段不能手动更改
  attr_readonly :vote_count, :comment_count, :view_count

  belongs_to :user
  has_many :creation_authors, dependent: :destroy
  has_many :creation_comments, dependent: :destroy
  has_many :creation_views, dependent: :destroy
  has_many :creation_votes, dependent: :destroy
  has_many :judges

  validates_presence_of :name, :desc
  validates :name, uniqueness: true

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

  def self.random
    onshow.order('rand()')
  end

  def self.ranklist
    onshow.order(popularity: :desc, vote_count: :desc, created_at: :desc)
  end
  # 是否已被当前用户投过票
  def is_voted?(user_id)
    unless user_id.nil?
      votes = creation_votes.where user_id: user_id
      return !votes.empty?
    end
    # 先不考虑未登录游客的情况
    false
  end

  # 是否已评审
  def judged(admin_id)
    not judges.where(admin_id: admin_id).empty?
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

  # 为作品投票
  def vote(user, ip)
    if Cfg.can_vote?
      exists = creation_votes.where(user_id: user.id).count > 0
      if exists
        errors.add(:vote, "您已经投过票了")
        false
      else
        vote_obj = Manage::CreationVote.new({
          user_id: user.id,
          ip: ip
          })
        creation_votes.push(vote_obj)
      end
    else
      errors.add(:vote, "目前不在投票时间内")
      false
    end
  end

  def unvote(user)
    votes = creation_votes.where(user_id: user.id)
    votes.each do |v|
      v.destroy
    end
  end

  def uncomment(user, id)
    comments = creation_comments.where(user_id: user.id, id: id)
    comments.each do |v|
      v.destroy
    end
  end
  
  private
    #生成简介
    def add_summary
      #除去html标记
      desc = ApplicationController.helpers.strip_tags(self.desc)
      #截取desc
      self.summary = desc[0..83] << '...'
    end

    def calc_popularity
  		# 内容概览评分：最高128*0.1=12.8分，基本作为初始分数
  		# 投票评分:最高200分
  		# 评论得分：最高200分
  		# 查看得分：最高120分
      def min(a, b)
        return a>b ? b : a
      end
      popularity = min(vote_count, 200) + min(comment_count * 1.5, 200) + min(view_count * 0.2, 120)
      save
    end
end
