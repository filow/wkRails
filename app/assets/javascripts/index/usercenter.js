// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require ckeditor/init
//= require_self



$(function (){
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


  $('.cancel_vote').click(function (){
    var $this = $(this);
    var id = $this.data('id');
    if($this.attr('disabled')) { return false; }
    $this.attr('disabled', true);
    $.ajax('/creations/' + id + '/vote', {
      cache: false,
      method: 'delete',
      statusCode: {
        401: function () { alert("请您先登录后再进行操作")}
      },
      success: function (result) {
        if(result.status) {
          // 成功
          $this.after('<p class="text-info">取消投票成功</p>');
          $this.remove();
        } else {
          $this.attr('disabled', false);
          alert(result.msg);
        }
      }
    })

    return false;
  })

  $('.cancel_comment').click(function (){
    var $this = $(this);
    var id = $this.data('id'), cid=$this.data('cid');
    if($this.attr('disabled')) { return false; }
    $this.attr('disabled', true);

    $.ajax('/creations/' + id + '/comment/' + cid, {
      cache: false,
      method: 'delete',
      statusCode: {
        401: function () { alert("请您先登录后再进行操作")}
      },
      success: function (result) {
        if(result.status) {
          // 成功
          $this.after('<p class="text-info">' + result.msg + '</p>');
          $this.remove();
        } else {
          $this.attr('disabled', false);
          alert(result.msg);
        }
      }
    });

    return false;
  });

  $('[data-toggle="tooltip"]').tooltip();




});

