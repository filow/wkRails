// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//下面是本来写在creation/show中的js
function ajaxvote(){
    return false;
}
$(document).ready(function(){
    $('#vote').click(function(){
        if($(this).attr('disabled')) return;
        $(this).attr('disabled','disabled').html('已投票');
        var vote_url=$(this).attr('href');
        $.get(vote_url,function (result){
            alert(result[1]);
            if(typeof(_czc) != 'undefined'){
                _czc.push(["_trackEvent","作品页投票",vote_url,1,"vote"]);
            }
            if(result[0]==1){
                var count=parseInt($('#vote_count').html());
                $('#vote_count').html(count+1);
            }

        });
    });
    $('.player_box').each(function (e){
      var location = $(this).data('url');
      var flashvars={f: location, c: 0, h: 3,p: 1};
      console.log('player_' + this.id)
      var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};
      CKobject.embedSWF('/ckplayer/ckplayer.swf', this.id,  this.id,'790','500',flashvars,params);
    });
});
