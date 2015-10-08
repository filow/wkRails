//= require 'jquery.icheck'
$(function(){
  // tooltip
  $('.time-column').tooltip();
  // 漂亮的单选和复选框
  $('.p_radio').iCheck({
  	radioClass: 'iradio_square-blue',
  });
  // 点击表单行选中这个行
  $('tr').click(function(){
    $('tr').removeClass('info');
  	var selector=$(this).find('.p_radio');
    if(selector.length > 0){
      $(this).addClass('info');
      selector.iCheck('check');
    }

  	// $(".submit_form").removeAttr('disabled');
  });
});
