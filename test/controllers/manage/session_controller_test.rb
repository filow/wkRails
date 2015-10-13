require 'test_helper'

class Manage::SessionControllerTest < ActionController::TestCase
  setup do
    @password = 'password'
    @admin = Manage::Admin.create(
      name: 'TestUserDynamic',
      password: @password,
      realname: '真实姓名'
    )
    @payload = {username: @admin.name, password: @password }
    @wrong_payload = {username: @admin.name, password: 'Some Wrong password' }
    @session_data = {manage_vcode: '53'}

    # 清除登录失败的记录
    @controller.send :clear_record
  end

  test "访问登录界面" do
    get :index
    assert_response :success
  end

  test "成功登录请求" do
    post :create, @payload
    assert_redirected_to manage_url
  end

  test "失败登录请求" do
    post :create, @wrong_payload
    assert_equal '您已经连续登录失败1次，超过5次您将暂时无法登陆', flash[:notice]
    assert_redirected_to manage_login_url
  end

  test "需要验证码的成功登录请求" do
    # 首先登录失败一次，以产生验证码的审核
    post :create, @wrong_payload

    # 然后带上验证码去登录
    request_payload = {username: @admin.name, password: @password, vcode: @session_data[:manage_vcode] }
    post :create, request_payload, @session_data
    assert_redirected_to manage_url
  end

  test "需要验证码但没有提供验证码的请求" do
    # 首先登录失败一次，以产生验证码的审核
    post :create, @wrong_payload

    # 然后带上验证码去登录
    post :create, @payload, @session_data
    assert_equal "请输入正确的验证码", flash[:notice]
    assert_redirected_to manage_login_url
  end


  test "验证码输入出错" do
    # 首先登录失败一次，以产生验证码的审核
    post :create, @wrong_payload

    # 然后带上验证码去登录
    request_payload = {username: @admin.name, password: @password, vcode: '1234' }
    post :create, request_payload, @session_data
    assert_equal "请输入正确的验证码", flash[:notice]
    assert_redirected_to manage_login_url
  end

  test "失败5次就禁止登陆" do
    @controller.send :clear_record
    # 首先登录失败一次，以产生验证码的审核
    post :create, @wrong_payload
    # 然后带上验证码去登录
    request_payload = {username: @admin.name, password: 'wrong', vcode: @session_data[:manage_vcode] }
    4.times do |x|
      post :create, request_payload, @session_data
      assert_redirected_to manage_login_url
      assert_equal "您已经连续登录失败#{x+2}次，超过5次您将暂时无法登陆", flash[:notice]
    end
    # 此时因为禁止登陆，无论提交什么都会跳回首页
    request_payload = {username: @admin.name, password: @password, vcode: @session_data[:manage_vcode] }
    post :create, request_payload, @session_data
    assert_redirected_to manage_login_url
    get :index
    assert_equal "您已失败5次，请过段时间重试", flash[:alert]
  end

  test "获取验证码图片" do
    get :vcode
    assert_response :success
  end

  test "用户退出登录" do
    delete :destroy
    assert_redirected_to manage_login_url
  end

end
