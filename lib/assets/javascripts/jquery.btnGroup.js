(function ($){
  var roles = {
    new: {
      button: 'success',
      text: '新建'
    },
    edit: {
      button: 'success',
      text: '编辑'
    },
    show: {
      button: 'info',
      text: '详细信息'
    },
    toggle: {
      button: 'primary',
      text: '切换'
    },
    delete: {
      button: 'danger',
      text: '删除'
    }
  }
  function setup(elem, settings){
    var $this = $(elem);
    var childElements = $this.children();
    var groupCount = 0,
        group = $('<div class="btn-group" role="group"></div>');
    childElements.each(function (){
      var $e = $(this), role = $e.attr('role');
      if (this.tagName == 'A'){

        console.log(role)
      }

    });
    console.log(childElements);
  }
  var methods = {
    init: function (options){
      var settings = $.extend({
        // 如果用户没有传入urlBase的话，就从标签里面读取
        'urlBase': 'tag',
      }, options);

      return this.each(function (){
        var $this = $(this), urlBase;
        if (settings.urlBase === 'tag'){
          // 如果标签中存在就用标签里面的
          urlBase = $this.data('base');
        }else{
          urlBase = settings.urlBase;
        }
        // 当且仅当是一个http或https地址，以及不是一个跨域请求时，才能认为这个路径是正确的
        var is_valid_url = urlBase.match(/^http[s]?:\/\//) && urlBase.indexOf(location.host) != -1;
        if(!is_valid_url){
          $.error('urlBase参数只能是一个以http或https开头的非跨域地址');
        }
        setup(this, settings);

      });

    }
  };
  $.fn.btnGroup = function (method){
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    } else {
      $.error('Method ' + method + ' does not exist on jQuery.btnGroup');
    }
  }
})(window.jQuery);
