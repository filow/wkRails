class IndexController < ApplicationController
  before_action :build_index_cache


private
  def build_index_cache
    @cache = Cache.new("wkRails-Index-")
  end
end
