class Manage::IndexController < ManageController
  def index
    # 计算磁盘占用
    dstat = Sys::Filesystem.stat("/")

    davaliable = dstat.block_size * dstat.blocks_available / 1024.0 / 1024 / 1024
    dused = dstat.block_size * (dstat.blocks - dstat.blocks_available) / 1024.0 / 1024 / 1024
    @disk = {avaliable: davaliable, used: dused, percent: dused/(davaliable + dused) * 100}
  end
end
