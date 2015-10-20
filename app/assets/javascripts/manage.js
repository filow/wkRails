//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require manage/fold-menu
//= require manage/backlog
//= require jquery.icheck
//= require jquery.btnGroup
//= require bootstrap-datepicker
//= require bootstrap-datepicker/locales/bootstrap-datepicker.zh-CN.js

$(function (){
  $('.time-column').tooltip();
  window.btnGroup = $('#btnGroup').btnGroup();
  // 漂亮的单选和复选框
  $('.p_radio, .p_checkbox').iCheck({
    radioClass: 'iradio_square-blue',
    checkboxClass: 'icheckbox_square-blue'
  });
});
