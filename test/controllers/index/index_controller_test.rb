require 'test_helper'

class Index::IndexControllerTest < ActionController::TestCase
  test "获取海报的测试" do
    get :index
    uploader = PosterUploader.new
    @posters = assigns(:posters)
    @posters.each_index do |i|
      cfg = cfgs("cfgs_poster#{i+1}".to_sym)
      uploader.retrieve_from_store! cfg.value
      assert @posters.include?(uploader.url)
    end
  end

end
