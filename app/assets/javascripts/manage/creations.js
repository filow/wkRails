$(function(){
    // 日期时间选择框
    window.datepickerInstance = $('.input-group.date').datepicker({
        language: 'zh-CN',
        autoclose: true,
        format: 'yyyy-mm-dd',
        todayHighlight: true,
        todayBtn: true
    });

    var current_line_hide, current_line_top;
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

        btnGroup.btnGroup('setLineId', t.data('id'));
      }
    });

});
