// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function checkform(){
    var uid=$(form.uid).val();
    if(uid.length<5){
        alert("用户ID位数必须大于5位！");
        $(form.uid).focus();
        return false;
    }
    var nickname=$(form.nickname).val();
    if(nickname.length==0){
        alert("必须填写用户姓名！");
        $(form.nickname).focus();
        return false;
    }
    var password=$(form.password).val();
    if(password.length<6){
        alert("密码长度必须大于6！");
        $(form.password).focus();
        return false;
    }
    var belong_type=$(form.belong_type).val();
    var department=$(form.department).val();
    if(belong_type=="1"){
        if($(form.college).val().length==0){
            alert("请填写学院！");
            $(form.college).focus();
            return false;
        }
    }else{
        if(department.length==0){
            alert("请填写单位！");
            $(form.department).focus();
            return false;
        }
    }

}
$(document).ready(function(){
    $('label.essential').append('(必填)')

    $('.belong_type').change(function(){
        node=$(".depart_td");
        if($(this).val()=="1"){
            node.find('.depart').hide();
            node.find('.college').show();
            node.find('.profession').show();
            node.find('.grade').show();
        }else{
            node.find('.depart').show();
            node.find('.college').hide();
            node.find('.profession').hide();
            node.find('.grade').hide();
        }
    });
    $('#uid').focusout(function(){
        var selector=$(this);
        var val=selector.val();
        if(val.length<5){
            selector.addClass('error');
            $('#uiderr').html("您输入的uid位数不足5位");
            $('#uiderr').removeClass('hide');
            $('#uidsuccess').addClass('hide');
        }else{
            url="{:U('checkUid')}"+"?uid="+$(this).val();
            $.get(url,function (data){
                if(data=="0"){
                    selector.removeClass('error');
                    $('#uiderr').addClass('hide');
                    $('#uidsuccess').removeClass('hide');
                }else if(data=="1"){
                    selector.addClass('error');
                    $('#uiderr').html("该用户名已存在");
                    $('#uiderr').removeClass('hide');
                    $('#uidsuccess').addClass('hide');
                }
            });
        }
    });
    $('tr > td:nth-child(1)').addClass('largefont');
});