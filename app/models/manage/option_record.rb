class Manage::OptionRecord < ActiveRecord::Base
  belongs_to :admins
  before_save :get_params_to_json
  before_save :desc

  attr_accessor :hash_params

private
  def desc
    case self.target
    when 'manage/users/create'
      self.desc = "管理员\""+admin_describe+"\"创建新用户:\""+target_describe+"\""
    when 'manage/users/update'
      self.desc = "管理员\""+admin_describe+"\"更新用户:\""+target_describe+"\""
    when 'manage/users/destroy'
      self.desc = "管理员\""+admin_describe+"\"删除用户:\""+target_describe+"\""
    when 'manage/messages/create'
      self.desc = "管理员\""+admin_describe+"\"发送新消息给用户:\""+target_describe+"\""
    when 'manage/admins/create'
      self.desc = "管理员\""+admin_describe+"\"创建新管理员:\""+target_describe+"\""
    when 'manage/admins/update'
      self.desc = "管理员\""+admin_describe+"\"更新管理员:\""+target_describe+"\""
    when 'manage/admins/destroy'
      self.desc = "管理员\""+admin_describe+"\"删除管理员:\""+target_describe+"\""
    when 'manage/admins/update_self'
      self.desc = "管理员\""+admin_describe+"\"更新自己信息:\""+target_describe+"\""
    when 'manage/admins/create_role'
      self.desc = "管理员\""+admin_describe+"\"创建角色:\""+target_describe+"\""
    when 'manage/admins/update_role'
      self.desc = "管理员\""+admin_describe+"\"更新角色:\""+target_describe+"\""
    when 'manage/admins/destroy_role'
      self.desc = "管理员\""+admin_describe+"\"删除角色:\""+target_describe+"\""
    end
  end

  def get_params_to_json
    return "null" if self.hash_params.nil?
    self.hash_params.delete(:avatar_cache) if hash_params.has_key?(:avatar_cache)
    self.hash_params.delete(:avatar) if hash_params.has_key?(:avatar)#不然会出现错误："\xFF" from ASCII-8BIT to UTF-8
    self.params = self.hash_params.to_json
  end
  def target_describe
    #新建用户在create前不会生成用户id，但params里有realname
    return self.hash_params[:realname] if !self.hash_params[:realname].nil?
    return self.hash_params[:name] if !self.hash_params[:name].nil?
    #其他情况都会有id产生
    ids = [self.hash_params[:id]].flatten #考虑一次操作多个用户
    realname = []
    target_type = self.target.split("/") #获取controller是users还是admins
    if target_type[-2]=="users"
      ids.each do |id|
        realname << "#{Manage::User.find(id).realname}(#{id})"
      end
    elsif target_type[-2]=="admins"
      if target_type[-1].include?("role")
        ids.each do |id|
          realname << "#{Manage::Admin.find(id).name}(#{id})" #角色用name描述
        end
      else
        ids.each do |id|
          realname << "#{Manage::Admin.find(id).realname}(#{id})" #管理员用realname描述
        end
      end
    end
    realname = realname.join("|")
  end
  def admin_describe
    Manage::Admin.find(self.admin_id).realname
  end
end
