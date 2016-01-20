class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_broadcast_id

  def default_url_options
    if Rails.env.production?
      {:host => "filowlee.com", :port => 3456}
    else
      {}
    end
  end

  def set_broadcast_id
    @broadcast_passage = Cfg.get('broadcast_passage')
    links = Cfg.get('links')
    @friend_links = links.split("\n").collect {|x| o = x.strip.split('|'); {name: o[0], link: o[1]}}
  end
end
