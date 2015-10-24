require 'test_helper'

class CfgTest < ActiveSupport::TestCase
  test '可正确读取设置项的内容' do
    cfg = cfgs(:cfgs_one)
    assert_equal cfg.value, Cfg.get(cfg.key)
  end

  test '友情链接设置项的格式验证' do
    cfg = cfgs(:cfgs_links)
    cfg.value = "百度|www.baidu.com\r\n百度www.baidu.com"
    assert_not cfg.save
    assert_equal cfg.errors[:value].join(','), '第2条格式不正确'
    cfg.value = "百度|www.baidu.com\r\n百度|www.baidu.com"
    assert cfg.save
  end
end
