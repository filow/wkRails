(function ($){
  var currentSelectedLineId;
  var fieldsData = {};
  var roles = {
    new: {
      button: 'success',
      text: '新建',
      icon: 'plus',
      disabled: false
    },
    edit: {
      button: 'success',
      text: '编辑',
      icon: 'pencil',
    },
    show: {
      button: 'info',
      text: '详细信息',
      icon: 'eye-open',
    },
    toggle: {
      button: 'primary',
      text: '切换',
      icon: 'retweet',
    },
    delete: {
      button: 'danger',
      text: '删除',
      icon: 'remove',
    }
  }
  function setup(elem, settings){
    var $this = $(elem);
    var childElements = $this.find('a');
    childElements.each(function (){
      var $e = $(this), role = $e.attr('role');
      // r是按钮的属性集合
      var r = roles[role]? roles[role] : {};
      // 在标签上定义的属性集合，会覆盖掉默认的
      var elementAttrs = {
        button: $e.data('button'),
        text: $e.text(),
        icon: $e.data('icon'),
        disabled: $e.attr('disabled')
      }
      // 如果标签里面没有字，就用默认值
      if(elementAttrs.text.trim().length == 0){
        delete elementAttrs.text;
      }
      // 合并对象
      $.extend(r, elementAttrs);
      // 生成按钮
      $e.removeClass().addClass('btn btn-' + r.button)
        .text(' ' + r.text)
        .prepend('<i class="glyphicon glyphicon-' + r.icon + '"></i> ');
      if(r.disabled !== false) $e.attr('disabled', true);
    });


    // 接下来绑定事件
    $this.delegate('a', 'click', function (e){
      var $e = $(this);
      if($e.attr('disabled')) return false;
      var roleAction = {
        new: {
          method: 'get',
          url: '/new',
        },
        edit: {
          method: 'get',
          url: '/{id}/edit'
        },
        show: {
          method: 'get',
          url: '/{id}'
        },
        toggle: {
          method: 'patch',
          url: '/{id}'
        },
        delete: {
          method: 'delete',
          url: '/{id}'
        }
      }
      var role = $e.attr('role');
      var r = roleAction[role];
      var elementAttrs = {
        method: $e.data('method'),
        url: $e.data('url')
      }
      $.extend(r, elementAttrs);
      var parent = $(e.delegateTarget);
      var baseUrl = parent.data('urlBase');
      var id = parent.btnGroup('getLineId');
      var href = baseUrl + r.url.replace('{id}', id);

      if(r.method == 'delete'){
        if(confirm("你确定要删除此用户吗？此操作不可撤销！！")){
          parent.btnGroup('sendRequest', href, r.method);
        }
      }else if(r.method == 'patch'){
        var targets = $e.attr('target');
        if(targets){
          var extData = {};
          targets.split('|').forEach(function (i){
            var dataField = i.substring(i.indexOf('[') + 1,i.indexOf(']'));
            var data = parent.btnGroup('getField', dataField);
            if(data !== undefined){
              extData[i] = data;
            }
          });
          parent.btnGroup('sendRequest', href, r.method, extData);
        }
      }else{
        parent.btnGroup('sendRequest', href, r.method);
      }

      return false;
    });
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
        $this.data('urlBase', urlBase);
        setup(this, settings);

      });

    },
    setLineId: function (id){
      if(!currentSelectedLineId){
        $(this).find('a[disabled="disabled"]').removeAttr('disabled');
        $.btnGroupLog('清除按钮失效状态');
      }
      currentSelectedLineId = id;
      $.btnGroupLog('当前设置的活动行号为', id);
    },
    getLineId: function (){
      return currentSelectedLineId;
    },
    setField: function (name, value){
      fieldsData[name] = value;
      $.btnGroupLog('设置字段', name, '为', value);
    },
    getField: function (name){
      return fieldsData[name];
    },
    // 构造一个表单向服务器发起请求
    sendRequest: function (href, method, payload){
      $.btnGroupLog('SendRequest, href:', href, 'method:', method, 'payload:', payload);
      if(method == 'get'){
        location.href = href;
        return;
      }
      var csrfToken = $('meta[name=csrf-token]').attr('content'),
          csrfParam = $('meta[name=csrf-param]').attr('content'),
          form = $('<form method="post" action="' + href + '"></form>'),
          metadataInput = '<input name="_method" value="' + method + '" type="hidden" />';

      if (csrfParam !== undefined && csrfToken !== undefined) {
        metadataInput += '<input name="' + csrfParam + '" value="' + csrfToken + '" type="hidden" />';
      }
      form.hide().append(metadataInput);
      for (var i in payload) {
        if (payload.hasOwnProperty(i)) {
          var input_element = '<input name="' + i + '" value="' + payload[i] + '" type="hidden" />'
          form.append(input_element);
        }
      }
      form.appendTo('body');
      form.submit();
    }
  }
  $.fn.btnGroup = function (method){
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    } else {
      $.error('Method ' + method + ' does not exist on jQuery.btnGroup');
    }
  }
  $.btnGroupLog = function (){
    if(window.console && console.log){
      var arg = ['jQuery.btnGroup:'].concat(Array.prototype.slice.call(arguments));
      console.log.apply(console, arg);
    }
  }
})(window.jQuery);
