
$(function(){

  // 点击表单行选中这个行
  $('tr').click(function(){
    var t = $(this);
  	var selector = t.find('.p_radio');
    if(selector.length > 0){
      // 高亮行
      $('tr').removeClass('info');
      t.addClass('info');
      // 选中
      selector.iCheck('check');

      var id = t.data('id'), is_forbidden = t.data('is_forbidden');
      btnGroup.btnGroup('setLineId', id);
      btnGroup.btnGroup('setField', 'is_forbidden', !is_forbidden);
    }
  });

  // sort
  $('a.sort').click(function(){
    var t = $(this);
    var href = t.attr('href'),
        sort_by = this.id,
        sort_type = parseInt(t.attr("value"));
    href = '/manage/users'
    sort_type ^= 1
    sendRequest(href,'GET',{'sort_by':sort_by,"sort_type":sort_type});
  })


})
