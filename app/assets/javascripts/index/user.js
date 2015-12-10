// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function () {
  $('#validate').click(function () {
    //请求发送验证码
    var url = $('#validate').data('url');
    var payload = {
      tel_num: $('#tel_num').val(),
      mode: $(this).data('mode')
    };

    $.post(url,payload,function (data){
      if (data.failed) {
        alert(data.res);
      } else {
        //设置按钮等待，防止短时间多次发送验证码
        var count = 60;
        var countdown = setInterval(countDown, 1000);
        function countDown() {
            $('#validate').attr("disabled", true);
            $('#validate').text(count + "秒后再次获取!");
            if (count <= 0) {
              $('#validate').text("重新获取验证码").removeAttr("disabled");
              clearInterval(countdown);
            }
            count--;
        }
        alert("验证码已成功发送")
      }
    },'json');
    return false;   //防止button提交
  });

  //验证密码是否符合要求
  $('#reg_form').submit(function (){
    var password = $('#password').val();
    if(password.length<6){
      alert("密码长度必须不小于6位！");
      $(form.password).focus();
      return false;
    }
    var vcode = $('#valicode').val()
    if(!/^\d{6}$/.test(vcode)){
      alert("验证码格式不正确");
      $('#valicode').focus();
      return false;
    }

    return true;
  });
});
