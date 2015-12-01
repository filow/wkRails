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

        btnGroup.btnGroup('setLineId', t.data('id'));
      }
    });

});
