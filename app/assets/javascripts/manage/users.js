$(function(){
  // tooltip
  $('.time-column').tooltip();
  // 漂亮的单选和复选框
  $('.p_radio').iCheck({
  	radioClass: 'iradio_square-blue',
  });
  var current_line_forbid;
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

      current_line_forbid = t.data('forbid');
      $(".action-btn").removeAttr('disabled').each(function(i, e){
        if(e.id == "edit") {
          $(e).attr('href', url_base + "/" + id + '/edit');
        }else {
          $(e).attr('href', url_base + "/" + id);
        }
      });
    }
  });

  // 切换和删除的操作
  $('a.extra-action').click(function (){
    var t = $(this);
    if(t.attr('disabled')) return false;
    var href = t.attr('href'), type = this.id;
    switch(type){
      case 'forbid':
        sendRequest(href, 'PATCH', {'manage_user[is_forbidden]':  !current_line_forbid});
        break;
      case 'delete':
        if(confirm("你确定要删除此用户吗？此操作不可撤销！！")){
          sendRequest(href, 'DELETE');
        }
        break;
    }
    return false;

  })

  // sort
  $('a.sort').click(function(){
    var t = $(this);
    var href = t.attr('href'),
  })
})
