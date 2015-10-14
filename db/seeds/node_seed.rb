class NodeSeed
  def explain
    '更新节点信息'
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
    nodes = YAML.load(File.read("config/ext/nodes.yml"))
    #获取YAML配置文件中所有的节点
    current_nodes = Hash.new
    nodes.each do |node|
      # 赋值
      controller = node[0]
      #遍历每一个action
      actions = Array.new
      node[1].each do |action|
        #把该controller下的所有action压进数组
        actions << action[0]
      end
      current_nodes.store(controller,actions)
    end
    p current_nodes

    # 获得数据库当前的所有
    exsited_nodes = Manage::Node.select(:controller,:action).all.collect{|item| item.action}
    p "------------------------------"
    p exsited_nodes
    # 删除多余的数据库项目
    #！！！！！！！！！！！！！！需要改写
    keys_to_delete = exsited_nodes.reject{|x| current_nodes.find_index(x) != nil}
    keys_to_delete.each do |k|
      db_item = Manage::Node.find_by_key k
      print "#{db_item.action}不存在于配置文件中，要删除它吗？(Y/N):"
      input = STDIN.gets.chop.downcase
      if input == 'y'
        log '删除', k
        result_log db_item.destroy, db_item
      else
        log '跳过', k
        puts
      end
    end

    #遍历每一个controller
    nodes.each do |node|
      # 赋值
      controller = node[0]
      #遍历每一个action
      node[1].each do |act|
        #赋值
        action = act[0]
        title  = act[1]["title"]
        remark = act[1]["remark"]
        # 如果数据库中存在这个键
        if exsited_nodes.find_index(action)
          # 更新操作
          #！！！！！！！！！！！！！！！需要改写
          print "\033[1m[更新]\033[0m  记录#{controller}_#{action}.."
          db_item = Manage::Node.find_by_key(key)
          result_log db_item.update(controller: controller, action: action, title: title, remark: remark), db_item
        else
          # 插入操作
          print "\033[1m[新增]\033[0m  记录#{controller}_#{action}.."
          db_item = Manage::Node.new controller: controller, action: action, title: title, remark: remark
          result_log db_item.save, db_item
        end
      end
    end
  end

end
