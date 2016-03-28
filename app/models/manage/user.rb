class Manage::User < ActiveRecord::Base
  has_many :messages
  has_many :creations
  has_many :creation_comments
  has_many :creation_votes
  mount_uploader :avatar, UserAvatarUploader
  before_create :create_activation_digest
  before_create :generate_password_digest
  before_update :generate_password_digest
  enum sex: [:male, :female]
  enum group: [:student, :teacher]

  PHONE_REGEX = /\A1[0-9]{10}\z/
  validates :name, presence:true, format: { with: PHONE_REGEX, on: :create }, uniqueness: true
  validates :realname, presence:true, uniqueness: true, length:{maximum:15}
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

  def validate_creation_upload_privilege
    # 头像必须上传
    if avatar.url.nil?
      errors.add(:avatar, "")
    end
    # 真实名称必须是一个有效的中文名
    unless realname =~ /[\u4e00-\u9fa5]{2,4}/
      errors.add(:realname, "格式错误")
    end
    # 性别必须填写
    if sex.nil? || sex.empty?
      errors.add(:sex, "")
    end
    # 组别必须填写
    if group.nil? || group.empty?
      errors.add(:group, "")
    end
    # 所属单位必须填写
    if department.nil? || department.empty?
      errors.add(:department, "")
    end
    # 手机号必须填写
    unless phone =~ PHONE_REGEX
      errors.add(:phone, "格式错误")
    end
    # 电子邮箱必须填写且验证
    unless email =~ VALID_EMAIL_REGEX
      errors.add(:email, "格式错误")
    end
    unless is_email_verified?
      errors.add(:email_validate, "未验证")
    end

  end

  private
  def create_activation_digest
    self.activation_token = self.class.new_token
    self.activation_digest = self.class.digest(activation_token)
  end

  def generate_password_digest
    if password
      self.password_digest = Digest::MD5.hexdigest(PRE_STR+self.name+self.password)
    end
  end

end
