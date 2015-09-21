# 微课大赛项目-Rails重构版本

## 安装配置
1. 首先安装好Ruby以及Rails，并保证ruby的版本大于2.0，操作系统能够必须是类Unix系统，例如Ubuntu
2. clone 这个目录
3. 安装memcached
```shell
sudo apt-get install memcached
```
4. 安装imagemagick
```shell
sudo apt-get install libmagickwand-dev imagemagick libmagickcore-dev
```
5. 运行bundle install
6. 运行rake db:setup

## 运行配置
1. 首先记得开启memcached，直接运行：
```shell
memcached -d
```
2. 如果是第一次克隆项目，记得根据数据库设置来设置一下你的数据库，例如用户名和密码
3. 每次更新项目都最好确认一下有没有运行数据库迁移：
```shell
rake db:migrate
```
4. 启动服务器
```shell
rails s
```

## 配置

## 测试

## 服务


## 发布配置
