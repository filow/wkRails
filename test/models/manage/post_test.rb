require 'test_helper'

class Manage::PostTest < ActiveSupport::TestCase
  test "标题不能重复" do
    post=Manage::Post.new(
        title: manage_posts(:posts_same_title).title,
        content: '测试内容！！！！！！！！！！！！',
        content_notag: '测试内容！！！！！！！！！！！！',
        publish_at: Date.today,
        is_top: false,
        is_hide: false
    )
    #标题重复不能存入
    assert_not post.save
    #测试错误信息是否正确
    assert_equal post.errors[:title].join(','), I18n.t('activerecord.errors.messages.taken')
  end

  test "自动生成不含有html标签的content_notag" do
    post = manage_posts(:posts_notag)
    #开始时content_notag是空的
    assert post.content_notag.blank?
    #成功存入
    assert post.save
    #自动产生了content_notag,且已经去掉html标签
    assert_not_equal post.content_notag, post.content
    assert_equal ApplicationController.helpers.strip_tags(post.content), post.content_notag
  end

  test "筛选已经生效了的通知公告" do
    valid_posts = Manage::Post.valid_posts
    now = Date.today
    valid_posts.each do |p|
      assert p.publish_at >= now
      assert_not p.is_hide
    end
  end
end
