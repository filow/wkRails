require 'test_helper'

class Manage::PostsControllerTest < ActionController::TestCase
  setup do
    @manage_post = manage_posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_post" do
    assert_difference('Manage::Post.count') do
      post :create, manage_post: { content: @manage_post.content, content_notag: @manage_post.content_notag, is_hide: @manage_post.is_hide, is_top: @manage_post.is_top, title: @manage_post.title, valid_from: @manage_post.valid_from }
    end

    assert_redirected_to manage_post_path(assigns(:manage_post))
  end

  test "should show manage_post" do
    get :show, id: @manage_post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_post
    assert_response :success
  end

  test "should update manage_post" do
    patch :update, id: @manage_post, manage_post: { content: @manage_post.content, content_notag: @manage_post.content_notag, is_hide: @manage_post.is_hide, is_top: @manage_post.is_top, title: @manage_post.title, valid_from: @manage_post.valid_from }
    assert_redirected_to manage_post_path(assigns(:manage_post))
  end

  test "should destroy manage_post" do
    assert_difference('Manage::Post.count', -1) do
      delete :destroy, id: @manage_post
    end

    assert_redirected_to manage_posts_path
  end
end
