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
end
