(function ($){
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
          // 当且仅当是一个http或https地址，以及不是一个跨域请求时，才能认为这个路径是正确的
          if (settings.urlBase.match(/^http[s]?:\/\//) && settings.urlBase.indexOf(location.host) != -1){
            urlBase = settings.urlBase;
          }else{
            $.error('urlBase参数只能是一个以http或https开头的非跨域地址');
          }
        }
        if(!urlBase){
          $.error('由于urlBase无效，' + this.tagName + '节点初始化失败');
          return false;
        }
      });

      console.log(settings);
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
