//= require jquery.uploadifive.js
//= require ckplayer.js


$(function(){

  // 上传步骤
  var uploader = null;
  var video_id = null;
  $('#next_step').click(function (){
    var i_name = $('#video_name'),
        i_author = $('#video_author');
    var name = i_name.val(), author = i_author.val();
    if (name.length >0 && author.length >0){
      i_name.attr('disabled', true); i_author.attr('disabled', true);

      var formData = {
          name: name,
          author: author
      };
      formData[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content');
      $('#file_upload').uploadifive({
        'formData'     : formData,
        'uploadScript' : location.href,
        'buttonText' : '上传文件',
        'width':110,
        'height': 40,
        //'queueSizeLimit' : 1,
        'removeCompleted' : false,
        'itemTemplate' : '<div id="${fileID}" class="well uploadifive-queue-item">'+
        '<span class="filename"></span> <span class="label label-info fileinfo"></span><span class="close">x</span>'+
        '</div>',
        'onProgress':function(file,e){
          if (e.lengthComputable) {
            var percent = Math.round((e.loaded / e.total) * 100);
            $('#progress').attr('style',"width:"+percent+"%");
          }
        },
        'onUploadComplete' : function(file, data) {
          var result=JSON.parse(data);
          if(result.success){
            $('#step3').show();
            file.queueItem.find('.fileinfo').removeClass('label-info').addClass('label-success').text(result.message);
            // 下面初始化播放器
            var video_url = result.url;
            video_id = result.id;
            var flashvars={f: video_url, c: 0, h: 3,};
            var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};
            CKobject.embedSWF('/ckplayer/ckplayer.swf','a1','ckplayer_a1','600','400',flashvars,params);

          }else{
            file.queueItem.find('.fileinfo').removeClass('label-info').addClass('label-danger').text(result[1]);
          }
        },
      });
      $('#step2').show();
    }else{
      alert("请输入视频名称和作者");
    }
  });


  // 截图
  $('#screen_shot').click(function (){
    var status = CKobject.getObjectById('ckplayer_a1').getStatus();
    $(this).attr('disabled', true)
    $.get('./' + video_id + '/screenshot?time=' + status.time, function (d){
      $('#screen_shot_img').attr('src', d.url + '?random=' + Math.random())
      $(this).attr('disabled', false)
      $('#step4').show()
    })
  });


});
