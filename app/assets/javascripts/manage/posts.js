//= require 'jquery.icheck'
$(function(){
  // tooltip
  $('.time-column').tooltip();
  // 漂亮的单选和复选框
  $('.p_radio').iCheck({
  	radioClass: 'iradio_square-blue',
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

  // 切换隐藏、切换置顶和删除的操作
  $('a.extra-action').click(function (){
    var t = $(this);
    if(t.attr('disabled')) return false;
    var href = t.attr('href'), type = this.id;
    switch(type){
      case 'top':
        sendRequest(href, 'PATCH', {'manage_post[is_top]': !current_line_top});
        break;
      case 'hide':
        sendRequest(href, 'PATCH', {'manage_post[is_hide]': !current_line_hide});
        break;
      case 'delete':
        if(confirm("你确定要删除这篇文章吗？此操作不可撤销！！")){
          sendRequest(href, 'DELETE');
        }
        break;
    }
    return false;

  })
});
