class LinksValidator < ActiveModel::Validator
  def validate(record)
    if record.key == 'links'
      #按行切分
      links = record.value.split "\n"
      #对每行进行检验
      links.each_index do |i|
        unless links[i] =~ /^[\u2E80-\uFE4F\w]+\|([\w:\/.]+)[\r\n]*$/
          record.errors[:value] << "第#{i+1}条格式不正确"
        end
      end
    end
  end
end

class Cfg < ActiveRecord::Base
  @@config_cache = Cache.new("Config-Cache")
  validates_inclusion_of :field_type,in: %w(string boolean text rich_text date email url number img),allow_nil:true,allow_empty:true
  #允许值为空避免进行格式验证时报错
  # validates :value,allow_blank:true
  #根据field_type的值来验证value是否合法
  validates :value, numericality: { only_integer: true ,greater_than_or_equal_to: 0},if: "field_type == 'number'",allow_blank:true
  validates :value, format: {with: /\A[\d]{4}-[\d]{2}-[\d]{2}/ }, if: "field_type == 'date'",allow_blank:true
  validates :value, inclusion: {in: %w(true false)}, if: "field_type == 'boolean'",allow_blank:true
  #验证友情链接格式是否合法
  validates_with LinksValidator

  before_save :refresh_cache

  def self.get(name, force_refresh=false)
    #从缓存中获取设置项
    key = name.to_s.downcase
    result = @@config_cache.get(key, nil, force_refresh) do
      self.where(key: key).first
    end

    logger.error("设置 - #{name}不存在，请检查数据库中是否有该项目") if result.nil?

    if result.field_type == 'img'   #处理图片类型的设置项
      uploader = PosterUploader.new
      unless result.value.blank?
        uploader.retrieve_from_store! result.value
        result.value = uploader.url
      end
    end
    return result.value if result
  end

  def self.get_all(name, force_refresh = false)
    self.where('`key` like ?', "#{name}%").select(:key).collect{|x| Cfg.get(x.key)}
  end

  def update(attributes)
    if field_type == 'img'
      uploader = PosterUploader.new
      # 先删除原图片
      unless value.blank?
        uploader.retrieve_from_store! value
        uploader.remove!
      end
      #存储图片
      uploader.store! attributes[:value]
      #更新文件名
      attributes[:value] = uploader.filename
    end
    super(attributes)
  end

  # def save_poster(img)
  #   uploader = PosterUploader.new
  #   # 先删除原图片
  #   unless value.blank?
  #     uploader.retrieve_from_store! value
  #     uploader.remove!
  #   end
  #   #存储图片
  #   uploader.store! img
  #   #更新文件名
  #   update value: uploader.filename
  # end

private
  def refresh_cache
    c_key = key.to_s.downcase
    @@config_cache[c_key] = nil
  end
end
