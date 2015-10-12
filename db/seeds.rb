# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 创建初始的管理员账户
if Manage::Admin.count == 0

  success = false
  while !success
    print '请输入管理员账户的账户名：'
    username = STDIN.gets.chop

    print '请输入管理员账户的密码：'
    password = STDIN.gets.chop

    print '请输入管理员账户的姓名：'
    realname = STDIN.gets.chop

    result = Manage::Admin.create(name: username, password: password, realname: realname)
    if result.id.nil?
      puts "抱歉，您的输入有误：#{result.errors.full_messages.join('，')}"
    else
      puts "账户已创建，账户名：#{result.name}, 密码： #{password}"
      success = true
    end
  end
end

# 下面开始处理各个配置文件的数据库同步操作

# 遍历seed目录，寻找其中所有的以seed.rb结尾的文件并加载，随后运行这些文件
Dir.glob('db/seeds/*').each do |file|
  require "#{Rails.root}/#{file}" if file =~ /seed.rb\z/
end

# 从当前常量表中选出以Seed结尾的常量
seed_classes = self.class.constants.select{|n| n=~ /Seed\z/}

# 遍历常量并生成对象，运行其中的run方法
seed_classes.each do |class_sym|
  con = self.class.const_get(class_sym)
  inst = con.send(:new)
  puts "=======  #{inst.explain}  =======" if con.method_defined?(:explain)
  inst.run if con.method_defined?(:run)
end
