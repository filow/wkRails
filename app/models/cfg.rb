class Cfg < ActiveRecord::Base
  @@config_cache = Cache.new("Config-Cache")
  validates_inclusion_of :field_type,in: %w(string boolean text rich_text date email url number img),allow_nil:true,allow_empty:true
  #允许值为空避免进行格式验证时报错
  # validates :value,allow_blank:true
  #根据field_type的值来验证value是否合法
  validates :value, numericality: { only_integer: true ,greater_than_or_equal_to: 0},if: "field_type == 'number'",allow_blank:true
  validates :value, format: {with: /\A[\d]{4}-[\d]{2}-[\d]{2}/ }, if: "field_type == 'date'",allow_blank:true
  validates :value, inclusion: {in: %w(true false)}, if: "field_type == 'boolean'",allow_blank:true


  def self.get(name, force_refresh=false)
    key = name.to_s.upcase
    result = @@config_cache.get(key, nil, force_refresh) do
      self.select('value').where(key: key).first
    end
    return result.value if result
  end

end
