// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){
  // 删除按钮操作
  $(".item-remove").click(function(){
    $(this).parent().remove();
  });
});
