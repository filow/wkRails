require 'test_helper'

class Manage::CreationTest < ActiveSupport::TestCase
  test "自动生成简介" do
    creation = manage_creations(:creations_without_summary)
    #开始时summary是空的
    assert creation.summary.blank?
    #成功存入
    assert creation.save
    #自动产生了summary
    assert_not_equal creation.summary, creation.desc
    summary = ApplicationController.helpers.strip_tags(creation.desc)
    summary = summary[0..83] << '...'
    assert_equal summary, creation.summary
  end

  test "判别是否评审" do
    creation1 = manage_creations(:creations_published_one)
    creation2 = manage_creations(:creations_published_two)

    admin = manage_admins(:valid_admin)

    assert creation1.judged admin.id
    assert_not creation2.judged admin.id
  end

  # test "发表评论" do
  #   creation = manage_creations(:creations_published_one)
  #   user = manage_users(:users_one)
  #   comment = creation.comment(user.id, '0.0.0.0', 'asdf')
  #   comment
  # end
end
