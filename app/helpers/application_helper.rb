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
    if block_given?
      if @admin.can_access?(action, controller.split('/')[-1])
        yield
      end
    else
      @admin.can_access?(action, controller.split('/')[-1])
    end
  end


  def is_voted(creation)
    "voted" if @logged_user && @logged_user.is_voted(creation)
  end

  def usercenter_sidebar_active(action)
    if params[:action] == action
      "active"
    else
      ""
    end
  end

  def usercenter_creations_check_table(user, key)
    if @user.errors[key].any?
      text = @user.errors[key][0].empty? ? '请完善' : @user.errors[key][0]
      content_tag(:td, class:'text-warning') do
        "<i class=\"glyphicon glyphicon-remove\"></i> #{text}".html_safe
      end
    else
      content_tag(:td, class:'text-navy') do
        '<i class="glyphicon glyphicon-ok"></i> 通过'.html_safe
      end
    end
  end
end
