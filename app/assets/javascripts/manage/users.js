
$(function(){

  $('tr').delegate('.p_checkbox', 'ifChecked', function (e){
    var $elem = $(e.delegateTarget);
    $elem.addClass('info');
    var id = $elem.data('id'), is_forbidden = $elem.data('is_forbidden');
    btnGroup.btnGroup('addLineId', id);
    btnGroup.btnGroup('setField', 'is_forbidden', !is_forbidden),
    btnGroup.btnGroup('setField', 'is_email_verified', true);
  });
  $('tr').delegate('.p_checkbox', 'ifUnchecked', function (e){
    var $elem = $(e.delegateTarget);
    $elem.removeClass('info');
    var id = $elem.data('id');
    btnGroup.btnGroup('removeLineId', id);
  });
  // 点击表单行选中这个行
  $('tr').click(function(){
  	$(this).find('.iCheck-helper').trigger('click');
  });

  // sort
  $('a.sort').click(function(){
    var t = $(this);
    var sort_by = this.id,
        sort_type = parseInt(t.attr("value"));
    sort_type ^= 1;
    var href = "/manage/users?sort_by="+sort_by+"&sort_type="+sort_type;
    t.attr("href",href);
  })


})
