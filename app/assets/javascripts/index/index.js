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

});
