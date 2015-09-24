class Manage::Admin < ActiveRecord::Base
  # uid（登陆账号）不允许重复
	validates_uniqueness_of :name
	# 提交表单时必须包含uid以及nickname
	validates_presence_of :name
	validates_presence_of :realname

  # 密码至少8位
	validates_length_of :password,minimum: 8,allow_blank:true,on: [:create,:update]


  # 使用插件建立用户密码验证体系
  has_secure_password
end
