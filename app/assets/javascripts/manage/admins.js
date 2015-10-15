$(function(){
  // tooltip
  $('.time-column').tooltip();
  // 漂亮的单选和复选框
  $('.a_radio').iCheck({
  	radioClass: 'iradio_square-blue',
  });

  var current_line_forbidden;
  // 点击表单行选中这个行
  $('tr').click(function(){
    var t = $(this);
  	var selector = t.find('.a_radio');
    if(selector.length > 0){
      // 高亮行
      $('tr').removeClass('info');
      t.addClass('info');
      // 选中
      selector.iCheck('check');

      var id = t.data('id'),
          url_base = $('#url_base').text().trim();

      current_line_forbidden = t.data('forbidden');
      $(".action-btn").removeAttr('disabled').each(function(i, e){
        if(e.id == "edit") {
          $(e).attr('href', url_base + "/" + id + '/edit');
        }else{
          $(e).attr('href', url_base + "/" + id);
        }
      });
    }
  });


  // 切换隐藏、切换置顶和删除的操作
  $('a.extra-action').click(function (){
    var t = $(this);
    if(t.attr('disabled')) return false;
    var href = t.attr('href'), type = this.id;
    switch(type){
      case 'forbidden':
        sendRequest(href, 'PATCH', {'manage_admin[is_forbidden]': !current_line_forbidden});
        break;
      case 'delete':
        if(confirm("你确定要删除这个账户吗？此操作不可撤销！！")){
          sendRequest(href, 'DELETE');
        }
        break;
    }
    return false;

  })
});
