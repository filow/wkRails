// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function getToken() {
  var key = $('meta[name=csrf-param]').attr('content');
  var val = $('meta[name=csrf-token]').attr('content');
  var result = {};
  result[key] = val;
  return result;
}
$('.set_read_msg').click(function (){
  var id = $(this).data('id');
  var $this = $(this);
  var payload = getToken();

  $this.attr('disabled', true).text('加载中')
  $.post('/usercenter/read_msg/' + id, payload, function(data) {
    if(data.code == 200) {
      $this.hide()
    } else {
      alert('操作失败！');
      $this.attr('disabled', false).text('未读')
    }
  });
});


$('#usercenter_messages_table tr').click(function () {
  var id = $(this).data('id');
  if(id) {
    $.get('messages/' + id, function (data) {
      if(data.code == 200) {
        var d = data.data;
        $('#modal-title').text(d.title)
        $('#modal-body').html(d.content)
        $('#msg_modal').modal()
      } else {
        alert('数据请求失败！')
      }
    })
  }

})
