require 'test_helper'

class CfgTest < ActiveSupport::TestCase
  test '可正确读取设置项的内容' do
    cfg = cfgs(:cfgs_one)
    assert_equal cfg.value, Cfg.get(cfg.key)
  end
end
