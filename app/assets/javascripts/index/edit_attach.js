//= require jquery.uploadifive.js
//= require ckplayer.js


$(function(){

  // 上传步骤
  var uploader = null;
  var video_id = null;
  var formData = {};
  formData[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content');
  $('#file_upload').uploadifive({
    'formData'     : formData,
    'uploadScript' : location.href,
    'buttonText' : '+ 上传文件',
    'width':110,
    'height': 40,
    'buttonClass'  : 'btn btn-primary',
    'removeCompleted' : false,
    'multi': false,
    'itemTemplate' : '<div id="${fileID}" class="well uploadifive-queue-item" style="margin:5px 0 0 0;">'+
    '<span class="filename"></span> <span class="label label-info fileinfo"></span><span class="close">x</span>'+
    '</div>',
    'onProgress':function(file,e){
      if (e.lengthComputable) {
        var percent = Math.round((e.loaded / e.total) * 100);
        $('#progress').attr('style',"width:"+percent+"%").text(percent + '%');
      }
    },
    'onUploadComplete' : function(file, data) {
      var result = JSON.parse(data);
      alert(result['message']);
      if(result.success){
        location.reload();
      }
    },
  });

});
