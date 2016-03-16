微课大赛项目-Rails重构版本
==========================

## TODO
### 前台
1. 发布作品的限制
2. 重新测试一下用户权限
3. 参赛作品的url更新
4. 作品详情页面
5. 用户详情页面
6. 搜索结果界面优化
### 后台


系统环境搭建
------------

1.  首先你可以通过 apt-get
    来安装zsh，之后可以访问[oh-my-zsh],安装这个插件包
2.  去*ruby.taobao.org*下载ruby的源码包并解压
3.  使用apt安装依赖：

        sudo apt-get install libssl-dev libreadline-dev sqlite3 libsqlite3-dev mysqlclient mysqlserver libmysqlclient-dev libmagickwand-dev imagemagick libmagickcore-dev nodejs

4.  在源码包解压出来的目录，依次运行./configure, make, sudo make
    install三条命令来安装ruby
5.  你可以通过ruby -v, gem
    -v来判断是否安装成功，如果安装成功的话应该会有版本号提示
6.  按照ruby.taobao.org的指示更改gem源
7.  运行 gem install bundle，安装bundler
8.  克隆本项目目录 <git@git.coding.net>:filow/wkRails.git
    ，然后在项目目录里运行bundle install
9.  成功安装完依赖后，按照下面的首次启动方案来启动应用

首次启动
--------

1. 安装memcached

        sudo apt-get install memcached

2. 如果memcached没有运行，就运行memcached -d
3. 如果有依赖没有安装或者代码更新带来了新的依赖，就运行bundle install
4. 如果之前没有创建过数据库，就运行rake
    db:setup，在里面会让你输入后台管理员的用户密码，自己想一个就可以了
5. 如果有新的数据库迁移没有运行，就运行rake
    db:migrate。否则会出现Pending Migration这样的错误。推荐每次git
    pull后都运行一下
6. 运行rails s来启动服务器

配置
----

测试
----

服务
----

发布配置
--------

  [oh-my-zsh]: https://github.com/robbyrussell/oh-my-zsh
