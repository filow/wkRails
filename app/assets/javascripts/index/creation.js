//= require moment
//= require moment/zh-cn.js

$(document).ready(function(){
    $('.player_box').each(function (e){
      var location = $(this).data('url');
      var flashvars={f: location, c: 0, h: 3,p: 1};
      var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};
      CKobject.embedSWF('/ckplayer/ckplayer.swf', this.id,  this.id,'790','500',flashvars,params);
    });

    // 如果存在评论的模板的话，那么应该就是作品的详情页，这样才能继续所有的评论相关逻辑
    var comment_template = $('#comment_template');
    if (comment_template.length > 0){
      // 设置模板的解析方式，原来是采用<%= %>这样的，跟rails冲突了，所以改成{{= value}}这样
      _.templateSettings = {
        interpolate: /\{\{\=(.+?)\}\}/g,
        evaluate: /\{\{(.+?)\}\}/g
      };
      // 这两个分别是评论的模板和分页的模板
      var template = _.template(comment_template.html());
      var pagination = _.template($('#pagination_template').html());

      // 跳转到分页
      function switchToPage(page) {
        $.get(location.pathname + '/comments?page=' + page, function (data) {
          // 这里是组合所有的元素，获得最后的html
          var comments_content = '';
          var comments = data.comments;
          if (comments.length > 0){
            for (var i = 0; i < comments.length; i++) {
              comments_content += template(comments[i]);
            }
            $('#comment_container').html(comments_content);
          }else {
            $('#comment_container').html('<div class="ibox"><div class="ibox-content">当前还没有评论</div></div>');
          }


          // 分页组件
          $('#comment_paginate').html(pagination({current: parseInt(data.page.current), total: parseInt(data.page.total)}));
          // 跳转到评论的顶部
          location.href = '#comment';
        });
      }
      // 一开始页面加载时，就加载第一页
      switchToPage(1);

      // 点击翻页
      $('#comment_paginate').on('click', 'a', function (){
        var page = $(this).data('page');
        switchToPage(page);
      })

      // 发送评论
      $('#send_comment').click(function (){
        var that = $(this);
        that.attr('disabled', true);
        var content = $('#comment_editor_textarea').text();
        var csrfToken = $('meta[name=csrf-token]').attr('content'),
            csrfParam = $('meta[name=csrf-param]').attr('content');
        var payload = {comment: content};
        payload[csrfParam] = csrfToken;

        $.post(location.pathname + '/comment', payload, function (data){

          alert(data.msg);
          that.removeAttr('disabled');
          if (data.status == '200'){
            switchToPage(1);
          } else {
            $('#comment_editor_textarea').focus();
          }
        });
      })

      // 删除评论
      $('#comment_container').on('click', '.cancel_comment', function (){
        var $this = $(this);
        var id = $this.data('id'), cid=$this.data('cid');
        if($this.attr('disabled')) { return false; }
        $this.attr('disabled', true);
        cancel_comment(id, cid, function (result){
          if(result.status) {
            // 成功
            $this.parentsUntil('.comment_container').remove();
          } else {
            $this.removeAttr('disabled');
            alert(result.msg);
          }
        });
        return false;
      });

    }
});
