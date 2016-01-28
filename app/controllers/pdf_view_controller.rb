class PdfViewController < ApplicationController
  def show
    @creation = Manage::Creation.find(params[:id])
    if @creation.ppt.url
      @url = @creation.ppt.url.to_s
    else
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
    end
  end
end
