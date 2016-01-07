// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require ckeditor/init
//= require vue
//= require moment
//= require moment/zh-cn.js
//= require_self



$(function (){
  function getToken() {
    var key = $('meta[name=csrf-param]').attr('content');
    var val = $('meta[name=csrf-token]').attr('content');
    var result = {};
    result[key] = val;
    return result;
  }
  $('.set_read_msg').click(function (){
    var id = $(this).data('id');
    var $this = $(this);
    var payload = getToken();

    $this.attr('disabled', true).text('加载中')
    $.post('/usercenter/read_msg/' + id, payload, function(data) {
      if(data.code == 200) {
        $this.hide()
      } else {
        alert('操作失败！');
        $this.attr('disabled', false).text('未读')
      }
    });
  });


  $('#usercenter_messages_table tr').click(function () {
    var id = $(this).data('id');
    if(id) {
      $.get('messages/' + id, function (data) {
        if(data.code == 200) {
          var d = data.data;
          $('#modal-title').text(d.title)
          $('#modal-body').html(d.content)
          $('#msg_modal').modal()
        } else {
          alert('数据请求失败！')
        }
      })
    }

  })


  $('.cancel_vote').click(function (){
    var $this = $(this);
    var id = $this.data('id');
    if($this.attr('disabled')) { return false; }
    $this.attr('disabled', true);
    $.ajax('/creations/' + id + '/vote', {
      cache: false,
      method: 'delete',
      statusCode: {
        401: function () { alert("请您先登录后再进行操作")}
      },
      success: function (result) {
        if(result.status) {
          // 成功
          $this.after('<p class="text-info">取消投票成功</p>');
          $this.remove();
        } else {
          $this.attr('disabled', false);
          alert(result.msg);
        }
      }
    })

    return false;
  })

  $('.cancel_comment').click(function (){
    var $this = $(this);
    var id = $this.data('id'), cid=$this.data('cid');
    if($this.attr('disabled')) { return false; }
    $this.attr('disabled', true);

    $.ajax('/creations/' + id + '/comment/' + cid, {
      cache: false,
      method: 'delete',
      statusCode: {
        401: function () { alert("请您先登录后再进行操作")}
      },
      success: function (result) {
        if(result.status) {
          // 成功
          $this.after('<p class="text-info">' + result.msg + '</p>');
          $this.remove();
        } else {
          $this.attr('disabled', false);
          alert(result.msg);
        }
      }
    });

    return false;
  });

  $('[data-toggle="tooltip"]').tooltip();



  var creation_detail_modal = document.getElementById('creation_detail_modal');
  if (creation_detail_modal) {
    var vue_modal = new Vue({
      el: '#creation_detail_modal',
      data: {
        id: 0,
        loading: false,
        name: '',
        thumb: '',
        authors: [],
        desc: '',
        status: '',
        vote_count: 0,
        view_count: 0,
        updated_at: null,
        doc: {},
        ppt: {}
      },
      methods: {
        show: function (id){
          $(this.$el).modal();
          this.loading = true;
          $.get('/usercenter/creations/' + id + '.json').then(function (data){
            this.id = data.id;
            this.name = data.name;
            this.thumb = data.thumb.large;
            this.authors = data.authors;
            this.desc = data.desc;
            this.status = data.status;
            this.vote_count = data.vote_count;
            this.view_count = data.view_count;
            this.updated_at = moment(data.updated_at).calendar();
            if (data.doc !== ''){
              this.doc =  {
                url: data.doc.url
              };
            }else{
              this.doc = ""
            }
            if(data.ppt !== ''){
              this.ppt =  {
                url: data.ppt.url
              };
            }else {
              this.ppt = ""
            }


            this.loading = false;

          }.bind(this))
        }
      }
    });

    $('.creation_detail').click(function (){
      var id = $(this).data('id');
      vue_modal.show(id);
    })

  }




});

