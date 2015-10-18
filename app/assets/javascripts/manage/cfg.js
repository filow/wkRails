
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

  });
