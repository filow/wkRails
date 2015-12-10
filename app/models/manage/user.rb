class Manage::User < ActiveRecord::Base
  has_many :messages
  has_many :creations
  has_many :creation_comments
  mount_uploader :avatar, UserAvatarUploader
  before_create :create_activation_digest
  before_create :generate_password_digest
  before_update :generate_password_digest
  enum sex: [:male, :female]
  enum group: [:student, :teacher]

  PHONE_REGEX = /\A1[0-9]{10}\z/
  validates :name, presence:true, format: { with: PHONE_REGEX }, uniqueness: true
  validates :realname, presence:true,length:{maximum:15}
  validates :phone, presence:true, format: { with: PHONE_REGEX }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/
  validates :email, length:{maximum:255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness:{case_senstive: false},
            allow_blank:true
  validates :password, :confirmation => true
  validates_length_of :password,minimum: 6, allow_blank:true,on: [:update]
  validates_length_of :password,minimum: 6, on: [:create]
  attr_accessor :password_confirmation
  attr_accessor :password
  attr_accessor :activation_token
  PRE_STR = '#wk@'
  #对sex汉化
  def sex_cn
    return nil if self.sex.nil?
    #翻译映射
    t = {
        male: '男',
        female: '女',
    }
    t[self.sex.to_sym]
  end

  #对group汉化
  def group_cn
    return nil if self.group.nil?
    #翻译映射
    t = {
        student: '学生组',
        teacher: '老师组',
    }
    t[self.group.to_sym]
  end

  #用于前台的搜索功能
  def self.search(key_word)
    rs = where('realname LIKE ?', "%#{key_word}%")
  end

  # 判断用户是否是一个可以上传的用户,条件为:没有被禁用, 邮箱通过验证
  def self.valid_account
    where(is_forbidden: false, is_email_verified: true)
  end

  def self.ranklist
    valid_account.where('popularity != 0').order(popularity: :desc, id: :asc)
  end

  def unreaded_messages_count
    messages.where(is_readed: false).count
  end

  def creation_count
    creations.onshow.count
  end

  def send_message(options)
    Manage::Message.create(options.merge({"user_id"=> id}))
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_attribute(:is_email_verified,true)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  def authenticate(password)
    if self.password_digest == Digest::MD5.hexdigest(PRE_STR+self.name+password)
      self
    else
      nil
    end
  end


  def is_voted(creation)
    creation.creation_votes.where(user_id: id).count > 0
  end

  private
  def create_activation_digest
    self.activation_token = self.class.new_token
    self.activation_digest = self.class.digest(activation_token)
  end

  def generate_password_digest
    self.password_digest = Digest::MD5.hexdigest(PRE_STR+self.name+self.password)
  end

end
