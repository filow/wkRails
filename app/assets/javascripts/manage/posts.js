
$(function(){
  // 日期时间选择框
  window.datepickerInstance = $('.input-group.date').datepicker({
    language: 'zh-CN',
    autoclose: true,
    format: 'yyyy-mm-dd',
    todayHighlight: true,
    todayBtn: true
  });

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

      var id = t.data('id'), is_hide = t.data('hide'), is_top = t.data('top');
      console.log(is_hide,is_top);
      btnGroup.btnGroup('setLineId', id);
      btnGroup.btnGroup('setField', 'is_hide', !is_hide);
      btnGroup.btnGroup('setField', 'is_top', !is_top);
    }
  });

});
