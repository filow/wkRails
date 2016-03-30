//= require moment
//= require moment/zh-cn.js

$(document).ready(function(){
    $('.player_box').each(function (e){
      var location = $(this).data('url');
      var flashvars={f: location, c: 0, h: 3,p: 1};
      var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};
      CKobject.embedSWF('/ckplayer/ckplayer.swf', this.id,  this.id,'790','500',flashvars,params);
    });


    var comment_template = $('#comment_template');
    if (comment_template.length > 0){
      _.templateSettings = {
        interpolate: /\{\{\=(.+?)\}\}/g,
        evaluate: /\{\{(.+?)\}\}/g
      };
      var template = _.template(comment_template.html());
      var pagination = _.template($('#pagination_template').html());

      function switchToPage(page) {
        $.get(location.href + '/comments?page=' + page, function (data) {
          var comments_content = '';
          var comments = data.comments;
          for (var i = 0; i < comments.length; i++) {
            comments_content += template(comments[i]);
          }
          $('#comment_container').html(comments_content);
          // 分页组件
          $('#comment_paginate').html(pagination({current: parseInt(data.page.current), total: parseInt(data.page.total)}));
        });
      }
      switchToPage(1);
      $('#comment_paginate').on('click', 'a', function (){
        var page = $(this).data('page');
        switchToPage(page);
        console.log(this);
      })

    }
});
