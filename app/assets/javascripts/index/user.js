// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function () {
    $('#validate').click(function () {
        //请求发送验证码
        var url = $('#validate').data('url');
        var tel = {tel_num: $('#tel_num').val()};
        function resHandler(data){
            if(data.failed)
                alert(data.res);
            else{
                //设置按钮等待，防止短时间多次发送验证码
                var count = 60;
                var countdown = setInterval(countDown, 1000);
                function countDown() {
                    $('#validate').attr("disabled", true);
                    $('#validate').text("您在" + count + " 秒后可以再次获取!");
                    if (count == 0) {
                        $('#validate').text("重新获取验证码").removeAttr("disabled");
                        clearInterval(countdown);
                    }
                    count--;
                }
                alert("验证码已成功发送")
            }
        }
        $.post(url,tel,resHandler,'json');
        return false;   //防止button提交
    });

    //验证密码是否符合要求
    $('#password').focusout(checkPw);
    $('form').submit(checkPw);
    function checkPw(){ //检查密码填写是否规范
        var password = $('#password').val();
        if(password.length<6){
            alert("密码长度必须不小于6位！");
            $(form.password).focus();
            return false;
        }
        return true;
    }
    function checkVd(){ //检查验证码是否规范
        return true;
    }
    function checkForm(){
        if(checkPw())
            if(checkVd())
                return true;
        return false;
    }
});