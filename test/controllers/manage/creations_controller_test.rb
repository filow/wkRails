require 'test_helper'

class Manage::CreationsControllerTest < ActionController::TestCase
  setup do
    @manage_creation = manage_creations(:creations_one)
    #登陆
    @admin = manage_admins(:valid_admin)
    session[:admin_id] = @admin.id
    session[:admin_realname] = @admin.realname
    session[:admin_name] = @admin.name
  end
  #
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_creations)
    assert_not_nil assigns(:pre_creations)
  end
  #
  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end
  #
  # test "should create manage_creation" do
  #   assert_difference('Manage::Creation.count') do
  #     post :create, manage_creation: { comment_count: @manage_creation.comment_count, desc: @manage_creation.desc, name: @manage_creation.name, status: @manage_creation.status, summary: @manage_creation.summary, thumb: @manage_creation.thumb, version: @manage_creation.version, view_count: @manage_creation.view_count, vote_count: @manage_creation.vote_count }
  #   end
  #
  #   assert_redirected_to manage_creation_path(assigns(:manage_creation))
  # end
  #
  test "should show manage_creation" do
    get :show, id: @manage_creation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_creation
    assert_response :success
  end

  test "should update manage_creation" do
    #作为更新的样板
    new = Manage::Creation.new(
        comment_count: @manage_creation.comment_count+5,
        desc: @manage_creation.desc << 'afgalkjs',
        name: '另一个名字',
        status: Manage::Creation.statuses[:publishing],
        version: @manage_creation.version+1,
        view_count: @manage_creation.view_count+5,
        vote_count: @manage_creation.vote_count+5
    )
    #更新
    patch :update, id: @manage_creation, manage_creation: {
                     comment_count: new.comment_count,
                     desc: new.desc,
                     name: new.name,
                     status: new.status,
                     version: new.version,
                     view_count: new.view_count,
                     vote_count: new.vote_count
                 }
    creation = assigns(:manage_creation)
    #有些属性被成功修改
    assert_equal new.name, creation.name
    assert_equal new.desc, creation.desc
    #有些属性是不会被接受的
    assert_not_equal new.comment_count, creation.comment_count
    assert_not_equal 'publishing', creation.status
    assert_not_equal new.version, creation.version
    assert_not_equal new.view_count, creation.view_count
    assert_not_equal new.vote_count, creation.vote_count

    assert_redirected_to manage_creation_path(creation)
  end

  test "should destroy manage_creation" do
    assert_difference('Manage::Creation.count', -1) do
      delete :destroy, id: @manage_creation
    end

    assert_redirected_to manage_creations_path
  end
end
