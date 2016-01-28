// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_self

$(document).on('ready page:load', function(){
  Turbolinks.enableProgressBar()
  $(".to_top").click(function(){
      $('body,html').animate({scrollTop:0},1000);
      return false;
  }).hide();
  $(document).scroll(function() {
      $(this).scrollTop()==0?$(".to_top").hide():$(".to_top").show();
  });

  // 投票处理，用于投票的按钮必须有data-id属性，子元素里有.vote_count元素
  $('.vote').click(function (){
    var $this = $(this);
    var id = $this.data('id');
    var className = $this.attr('class');

    var vote_count_field = $this.find('.vote_count');
    var origin_text = vote_count_field.text();

    var handler = {
      cache: false,
      method: 'delete',
      statusCode: {
        401: function () { alert("请您先登录后再进行操作")}
      },
      success: function (result) {
        vote_count_field.text(origin_text);
        if(result.status) {
          // 成功
          vote_count_field.text(result.votes);
          $this.toggleClass('voted');
        } else {
          alert(result.msg);
        }
      },
      error: function (){
        vote_count_field.text(origin_text);
      }
    }

    if ($this.hasClass('voted')) {
      if(confirm("确认要取消投票吗？")) {
        vote_count_field.text('...');
        $.ajax('/creations/' + id + '/vote', handler);
      }
    } else {
      handler.method = 'post';
      vote_count_field.text('...');
      $.ajax('/creations/' + id + '/vote', handler);
    }

  });
});
