class RoleSeed
  def run
    # 先写个无脑的做测试,之后在写入yml
    t = Manage::Role.new
    t.name = "管理员"
    t.nodes << Manage::Node.take(3)
    t.save
    x = Manage::Role.new
    x.name = "超级管理员"
    x.nodes << Manage::Node.all
    x.save

  end
end
