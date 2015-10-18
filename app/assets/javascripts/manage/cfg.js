
$(function(){
  // tooltip
  $('.time-column').tooltip();
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

      var id = t.data('id'),
          url_base = $('#url_base').text().trim();

      current_line_hide = t.data('hide');
      current_line_top = t.data('top');
      $(".action-btn").removeAttr('disabled').each(function(i, e){
        if(e.id == "edit") {
          $(e).attr('href', url_base + "/" + id + '/edit');
        }else{
          $(e).attr('href', url_base + "/" + id);
        }
      });
    }
  });
