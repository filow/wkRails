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

  test "获取作品评审平均分" do
    creation1 = manage_creations(:creations_published_one)
    creation2 = manage_creations(:creations_published_two)

    judges1 = manage_judges(:judges_one)
    judges2 = manage_judges(:judges_two)

    assert_equal creation1.average, (judges1.rank+judges2.rank)/2
    assert_equal creation2.average, 0
  end

  test "判别是否评审" do
    creation1 = manage_creations(:creations_published_one)
    creation2 = manage_creations(:creations_published_two)

    admin = manage_admins(:valid_admin)

    assert creation1.judged admin.id
    assert_not creation2.judged admin.id
  end
end
