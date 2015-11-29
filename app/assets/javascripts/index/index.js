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
    var id = $(this).data('id');
    if ($(this).data('voted')) {
      if(confirm("确认要取消投票吗？")) {
        $(this).find('.vote_count').text('0');
        $(this).removeClass('voted').data('voted', false);
      }

    }else {
      if(confirm("确认要给这个作品投票吗？")) {
        $(this).find('.vote_count').text('1');
        $(this).addClass('voted').data('voted', true);
      }

    }

  });


});
