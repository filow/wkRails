// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){
  //记录所有用户id字段元素
  var record = new Array();
  $("#dynamic").children().each(function(){
    value =parseInt($(this).attr("value"));
    record[value] = $(this);
  })
  //记录form的action
  url = $('form').attr('action');
  temp = url.split("/");
  ids = temp[3].split(",");
  //删除相关元素
  $(".item-remove").click(function(){
    item = $(this).parent();
    id = item.attr("id");
    //删除表单外显示的用户
    item.remove();
    //删除表单中的用户
    record[parseInt(id)].remove();

    //修改表单action
    for(var i=0;i<ids.length;i++){//将将要删除的用户id与数组最后一位交换
      if(ids[i]==id){
        t = ids[i];
        ids[i] = ids[ids.length-1];
        ids[ids.length-1] = t;
        break;
      }
    }
    ids.pop();//将最后一位（即要删除的用户id）删除

    format_ids = ids.join(",");
    $('form').attr('action','/manage/users/'+format_ids+'/message');
  })
})
