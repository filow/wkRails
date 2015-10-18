class Cfg < ActiveRecord::Base
  @@config_cache = Cache.new("Config-Cache")
  validates_inclusion_of :field_type,in: %w(string boolean text rich_text date email url number),allow_nil:true,allow_empty:true

  #根据field_type的值来验证value是否合法
  validates :value, numericality: { only_integer: true ,greater_than_or_equal_to: 0},if: "field_type == 'number'"
  validates :value, format: {with: /\A[\d]{4}-[\d]{2}-[\d]{2}/ }, if: "field_type == 'date'"
  validates :value, inclusion: {in: %w(true false)}, if: "field_type == 'boolean'"


  def self.get(name, force_refresh=false)
    key = name.to_s.upcase
    result = @@config_cache.get(key, nil, force_refresh) do
      self.select('value').where(key: key).first
    end
    return result.value if result
  end

end
