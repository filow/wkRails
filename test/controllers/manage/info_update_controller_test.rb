require 'test_helper'

class Manage::InfoUpdateControllerTest < ActionController::TestCase
  setup do
    #登陆
    @manage_admin = manage_admins(:valid_admin)
    session[:admin_id] = @manage_admin.id
    session[:admin_realname] = @manage_admin.realname
    session[:admin_name] = @manage_admin.name
    #旧密码
    @op = 'password'
    @wrong_op = 'wrong _old_password'
    #验证码
    session[:manage_vcode] = 'ABCD'
  end
  test "进入修改页" do
    get :index , id: @manage_admin
    assert_template :index
    assert_response :success
  end

  test "成功修改个人信息" do
    post :update,
          id: @manage_admin,
          vcode: session[:manage_vcode],
          old_password: @op,
          manage_admin: {
              is_forbidden: @manage_admin.is_forbidden,
              password: "new_password",
              realname: @manage_admin.realname,
              name: @manage_admin.name
          }
    admin = assigns :manage_admin
    admin.errors.full_messages.each do |message|
      puts "<li>#{message}</li>\n"
    end
    assert_template :success
    assert_response :success
  end

  test "验证码错误,修改个人信息失败" do
    post :update,
          id: @manage_admin,
          vcode: 'asdf',
          old_password: @op,
          manage_admin: {
              is_forbidden: @manage_admin.is_forbidden,
              password: "new_password",
              realname: @manage_admin.realname,
              name: @manage_admin.name
          }
    assert_redirected_to manage_info_update_path
    assert_equal flash[:notice], '请输入正确的验证码'
  end

  test "原密码错误,修改个人信息失败" do
    post :update,
          id: @manage_admin,
          vcode: session[:manage_vcode],
          old_password: @wrong_op,
          manage_admin: {
              is_forbidden: @manage_admin.is_forbidden,
              password: "new_password",
              realname: @manage_admin.realname,
              name: @manage_admin.name
          }
    assert_redirected_to manage_info_update_path
    assert_equal flash[:notice], '原密码错误，修改个人信息失败'
  end
end
