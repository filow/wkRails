$(document).ready(function(){
  $(".remove").click(function(){
    $(this).parent().parent().remove();
  });
  $(".sub-text").click(function(){
    $("#insert a").text($("textarea").val());
    $("#insert").removeClass("hide");
  });
  $(".un button").click(function(){
    $(this).find("img").attr("src","/assets/manage/check.png");
    $(this).parent().parent().removeClass("un").addClass("done");
  })
  $(".done button").click(function(){
    $(this).parent().parent().removeClass("done").addClass("un");
    $(this).find("img").attr("src","/assets/manage/circle.png");
  })
  $(".all").click(function(){
    $(this).removeClass("un-default").addClass("default");
    $(".have-done").removeClass("default");
    $(".un-done").removeClass("default");
    $(".un").removeClass("hide").addClass("show");
    $(".done").removeClass("hide").addClass("show");
  })
  $(".un-done").click(function(){
    $(this).removeClass("un-default").addClass("default");
    $(".have-done").removeClass("default");
    $(".all").removeClass("default");
    $(".done").removeClass("show").addClass("hide");
    $(".un").addClass("show");
  })
  $(".have-done").click(function(){
    $(this).removeClass("un-default").addClass("default");
    $(".all").removeClass("default");
    $(".un-done").removeClass("default");
    $(".un").removeClass("show").addClass("hide");
    $(".done").removeClass("hide").addClass("show");
  })
});
