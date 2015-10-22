module CfgHelper
  #为不同打field_type选择不同的表单标签
  def cfg_number_field cfg
    text_field_tag(:cfg_value,cfg.value,
      {:class => 'form-control'})
  end


  def cfg_boolean_field cfg
    select_tag(:cfg_value,
    options_for_select([['是', true], ['否', false]],cfg.value ),
      {:class => 'form-control'})
  end


  def cfg_date_field cfg
    text_field_tag(:cfg_value,cfg.value,
      {:class => 'form-control input-group date'})
  end

  def cfg_text_field cfg
    text_field_tag(:cfg_value,cfg.value,
      {:class => 'form-control'})
  end

  def cfg_img_field cfg
    file_field_tag(:cfg_value)
  end

  def cfg_url_field cfg
    text_area_tag(:cfg_value, cfg.value, {:class => 'form-control'})
  end

  #应当整合更多种type处理 以应对未来新增的设置项
end
