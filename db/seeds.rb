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
