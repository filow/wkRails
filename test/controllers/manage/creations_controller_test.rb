require 'test_helper'

class Manage::CreationsControllerTest < ActionController::TestCase
  setup do
    @manage_creation = manage_creations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_creations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_creation" do
    assert_difference('Manage::Creation.count') do
      post :create, manage_creation: { comment_count: @manage_creation.comment_count, desc: @manage_creation.desc, name: @manage_creation.name, popularity: @manage_creation.popularity, status: @manage_creation.status, summary: @manage_creation.summary, thumb: @manage_creation.thumb, version: @manage_creation.version, view_count: @manage_creation.view_count, vote_count: @manage_creation.vote_count }
    end

    assert_redirected_to manage_creation_path(assigns(:manage_creation))
  end

  test "should show manage_creation" do
    get :show, id: @manage_creation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_creation
    assert_response :success
  end

  test "should update manage_creation" do
    patch :update, id: @manage_creation, manage_creation: { comment_count: @manage_creation.comment_count, desc: @manage_creation.desc, name: @manage_creation.name, popularity: @manage_creation.popularity, status: @manage_creation.status, summary: @manage_creation.summary, thumb: @manage_creation.thumb, version: @manage_creation.version, view_count: @manage_creation.view_count, vote_count: @manage_creation.vote_count }
    assert_redirected_to manage_creation_path(assigns(:manage_creation))
  end

  test "should destroy manage_creation" do
    assert_difference('Manage::Creation.count', -1) do
      delete :destroy, id: @manage_creation
    end

    assert_redirected_to manage_creations_path
  end
end
