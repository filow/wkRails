class Manage::Admin < ActiveRecord::Base

  has_many :judges
  has_and_belongs_to_many :roles

	validates_presence_of :realname

	validates :name,presence: {value: true},
		uniqueness:  {value: true},
		#用户名长度以及内容规范应当按照国际惯例
		length: { minimum: 4,maximum: 16,message: "用户名长度必须在6—16个字符之间" },
		format: { with: /\A[a-zA-Z][0-9a-zA-Z]+\Z/,
			message: "用户名只能由数字和字母组成，且开头不能为数字" }

  # 密码至少8位
	validates_length_of :password,minimum: 8,maximum:16, allow_blank:true,on: [:create,:update]


  # 使用插件建立用户密码验证体系
  has_secure_password
end
