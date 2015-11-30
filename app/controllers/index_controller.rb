class IndexController < ApplicationController
  before_action :build_index_cache
  before_action :set_user

private
  def build_index_cache
    @cache = Cache.new("wkRails-Index-")
  end

  def set_user
    @logged_user = Manage::User.find(session[:user_id]) if session[:user_id]
  end
end
