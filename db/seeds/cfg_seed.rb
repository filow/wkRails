class CfgSeed
  def explain
    '更新设置信息'
  end
  def log(method, key)
    print "\033[1m[#{method}]\033[0m  记录#{key}.."
  end
  def result_log(result, obj)
    if result
      puts "成功"
    else
      puts "失败"
      puts obj.errors.full_messages.join("\n")
    end
  end
  def run
    # 加载配置文件
    configs = YAML.load(File.read("config/ext/cfgs.yml"))

    # 获得数据库当前的所有键
    existed_keys = Cfg.select(:key).all.collect{|item| item.key}
    current_keys = configs.keys
    # 删除多余的数据库项目
    keys_to_delete = existed_keys.reject{|x| current_keys.find_index(x) != nil}
    keys_to_delete.each do |k|
      db_item = Cfg.find_by_key k
      print "#{db_item.key}不存在于配置文件中，要删除它吗？(Y/N):"
      input = STDIN.gets.chop.downcase
      if input == 'y'
        log '删除', k
        result_log db_item.destroy, db_item
      else
        log '跳过', k
        puts
      end
    end
    configs.each do |cfg|
      # 赋值
      key, other = cfg
      field_type, remark, value = other["type"], other["desc"], other["default"]
      other = nil
      # 如果数据库中存在这个键
      if existed_keys.find_index(key)
        # 更新操作
        print "\033[1m[更新]\033[0m  记录#{key}.."
        db_item = Cfg.find_by_key(key)
        result_log db_item.update(field_type: field_type, remark: remark), db_item
      else
        # 插入操作
        print "\033[1m[新增]\033[0m  记录#{key}.."
        db_item = Cfg.new key: key, value: value, field_type: field_type, remark: remark
        result_log db_item.save, db_item
      end
    end
  end

end
