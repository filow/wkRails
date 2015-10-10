class Cfg < ActiveRecord::Base
  @@config_cache = Cache.new("Config-Cache")
  validates_inclusion_of :field_type,in: %w(text_field text_area ckeditor datetime_field email_field url_field number_field),allow_nil:true,allow_empty:true

  def self.get(name, force_refresh=false)
    key = name.to_s.upcase
    result = @@config_cache.get(key, nil, force_refresh) do
      self.select('value').where(key: key).first
    end
    return result.value if result
  end

end
