require 'test_helper'

class Manage::PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:posts_filter2)
    #登陆
    @admin = manage_admins(:valid_admin)
    session[:admin_id] = @admin.id
    session[:admin_realname] = @admin.realname
    session[:admin_name] = @admin.name
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
    assert_template :index, layout: 'layouts/manage'
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_template :new, layout: 'layouts/manage', partial: '_form'
  end

  test "should create manage_post" do
    assert_difference('Post.count') do
      post :create, post: {
                      content: '测试内容！！！',
                      is_hide: false,
                      is_top: true,
                      title: '测试',
                      publish_at: Date.today
                  }
    end

    assert_redirected_to manage_post_path(assigns(:post))
  end

  test "should show manage_post" do
    get :show, id: @post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post
    assert_response :success
    assert_template :edit, layout: 'layouts/manage', partial: '_form'
  end

  test "should update manage_post" do
    patch :update, id: @post, post: {
                     content: '内容变了！！！',
                     is_hide: @post.is_hide,
                     is_top: @post.is_top,
                     title: @post.title,
                     publish_at: @post.publish_at
                 }
    assert_redirected_to manage_posts_path
  end

  test "should destroy manage_post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to manage_posts_path
  end

end
