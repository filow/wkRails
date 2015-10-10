//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require manage/fold-menu
//= require manage/backlog
//= require 'jquery.icheck'
//= require bootstrap-datepicker
//= require bootstrap-datepicker/locales/bootstrap-datepicker.zh-CN.js

// 构造一个表单向服务器发起请求
function sendRequest(href, method, payload){
  var csrfToken = $('meta[name=csrf-token]').attr('content'),
      csrfParam = $('meta[name=csrf-param]').attr('content'),
      form = $('<form method="post" action="' + href + '"></form>'),
      metadataInput = '<input name="_method" value="' + method + '" type="hidden" />';

  if (csrfParam !== undefined && csrfToken !== undefined) {
    metadataInput += '<input name="' + csrfParam + '" value="' + csrfToken + '" type="hidden" />';
  }
  form.hide().append(metadataInput);
  for (var i in payload) {
    if (payload.hasOwnProperty(i)) {
      var input_element = '<input name="' + i + '" value="' + payload[i] + '" type="hidden" />'
      form.append(input_element);
    }
  }
  form.appendTo('body');
  console.log(form);
  form.submit();
}
