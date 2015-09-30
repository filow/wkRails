require 'test_helper'

class Manage::AdminTest < ActiveSupport::TestCase
  test "管理员密码必须不小于8位" do
    admin = Manage::Admin.new(name: 'someone', realname: '某用户', password: '211')
    assert_not admin.save
    admin.password = '1234567'
    assert_not admin.save
    admin.password = '12345678'
    assert admin.save
  end
end
