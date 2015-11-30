//= require ckplayer.js
$(function (){

  $('.video_exp_btn').click(function(){
    var title=$(this).attr('data-title');
    var location=$(this).attr('data-location');
    $('#video_exp_title').text(title);

    var flashvars={f: location, c: 0, h: 3,p: 1};
    var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};
    CKobject.embedSWF('/ckplayer/ckplayer.swf','player','player','650','450',flashvars,params);
  });

  $('.author').tooltip();

  $('.vote').click(function (){
    var $this = $(this);
    var id = $this.data('id');
    var className = $this.attr('class');

    if (className.indexOf('voted') >= 0) {
      if(confirm("确认要取消投票吗？")) {
        $this.find('.vote_count').text('...');
        $.ajax('creations/' + id + '/vote', {
          cache: false,
          method: 'delete',
          statusCode: {
            401: function () { alert("请您先登录后再进行操作")}
          },
          success: function (result) {
            if(result.status) {
              // 成功
              $this.find('.vote_count').text(result.votes);
              $this.removeClass('voted');
            } else {
              alert(result.msg);
            }
          }
        });
      }

    }else {
      $this.find('.vote_count').text('...');
      $.ajax('creations/' + id + '/vote', {
        cache: false,
        method: 'post',
        statusCode: {
          401: function () {alert("请您先登录后再投票")}
        },
        success: function (result) {
          if(result.status) {
            // 成功
            $this.find('.vote_count').text(result.votes);
            $this.addClass('voted');
          } else {
            alert(result.msg);
          }
        }
      });
    }

  });


});
