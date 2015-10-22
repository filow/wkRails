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

      var id = t.data('id'), is_forbidden = t.data('forbidden');
      btnGroup.btnGroup('setLineId', id);
      btnGroup.btnGroup('setField', 'is_forbidden', !is_forbidden);
    }
  });



  $('.view_permissions').click(function(){
    $.get('/manage/roles/' + $(this).data('id'), function (data){
      $('#modal-body').html(data);
      $('#modal').modal();
    });
    return false;
  });
});
