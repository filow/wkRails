require 'test_helper'

class Manage::CfgControllerTest < ActionController::TestCase

  setup do
    @cfg = cfgs(:cfgs_one)
    #登陆
    @admin = manage_admins(:valid_admin)
    session[:admin_id] = @admin.id
    session[:admin_realname] = @admin.realname
    session[:admin_name] = @admin.name
  end

  test "展示列表" do
    get :index
    assert_response :success
  end

  test "更改系统设置" do
    patch :update, id: @cfg, post: {value: '123'}
    assert_redirected_to manage_cfgs_path
  end

end
