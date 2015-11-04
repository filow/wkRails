module ApplicationHelper
  def form_errors(var)
    if var.errors.any?
      str=<<STR
<div class="alert alert-block alert-danger">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <h4>您提交的表单有#{var.errors.count}个错误 </h4>
      <ul>
STR
      var.errors.full_messages.each do |message|
        str+="<li>#{message}</li>"
      end
      str+="</ul></div>"
      raw str
    end
  end

  def tm(str)
    t("activerecord.attributes.manage/#{str}")
  end
  def tmc(str)
    ctl=params[:controller]
    t("activerecord.attributes.#{ctl[0,ctl.length-1]}.#{str.downcase}")
  end

  def index_nav_active(url)
    raw 'class="active"' if request.url == url
  end

  def can?(action,controller = params[:controller])
    # @admin = Manage::Admin.find(session[:admin_id])
    if @admin.can_access?(action, controller.split('/')[-1])
      yield
    end
  end

end
