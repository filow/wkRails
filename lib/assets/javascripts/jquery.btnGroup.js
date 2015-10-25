// 按照标签生成一个固定的顶部按钮组插件
// TODO：
// 1. 支持多选

(function (window){
  var g = window.btnGroupHelper = {};
  g.roles = {
    new: {
      button: 'success', text: '新建',
      icon: 'plus', disabled: false
    },
    edit: {
      button: 'success', text: '编辑',
      icon: 'pencil',
    },
    show: {
      button: 'info', text: '详细信息',
      icon: 'eye-open',
    },
    toggle: {
      button: 'primary', text: '切换',
      icon: 'retweet',
    },
    delete: {
      button: 'danger', text: '删除',
      icon: 'remove',
    }
  };
  g.roleAction = {
    new: { method: 'get', url: '/new',},
    edit: { method: 'get', url: '/{id}/edit'},
    show: { method: 'get', url: '/{id}'},
    toggle: { method: 'patch', url: '/{id}'},
    delete: { method: 'delete', url: '/{id}'}
  };
  g.log = function (){
    if(window.console && console.log){
      var arg = ['jQuery.btnGroup:'].concat(Array.prototype.slice.call(arguments));
      console.log.apply(console, arg);
    }
  }
  // 构造一个表单向服务器发起请求
  g.sendRequest = function (href, method, payload){
    btnGroupHelper.log('SendRequest, href:', href, 'method:', method, 'payload:', payload);
    if(method.toLowerCase() === 'get'){
      location.assign(href);
    }else{
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
  };
})(window);

(function ($){
  var currentId = [];
  var fieldsData = {};
  function setup(elem, settings){
    var $this = $(elem);
    // 要处理这个元素下的所有a标签
    $this.find('a').each(function (){
      var $e = $(this), role = $e.attr('role');
      var roles = window.btnGroupHelper.roles;
      // r是按钮的属性集合
      var r = roles[role]? roles[role] : {};
      // 在标签上定义的属性集合，会覆盖掉默认的
      var elementAttrs = {
        button: $e.data('button'),
        text: $e.text().trim(),
        icon: $e.data('icon'),
        disabled: $e.attr('disabled')
      }
      // 如果标签里面没有字，就用默认值
      if(elementAttrs.text.length == 0){
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
      // 如果按钮还在失效状态就不能触发事件
      if($e.attr('disabled')) return false;
      var role = $e.attr('role');
      // 这里获取默认的动作属性与标签中定义的属性合并起来成为最终属性
      var r = btnGroupHelper.roleAction[role] || {};
      var elementAttrs = {
        method: $e.data('method'),
        url: $e.data('url')
      }
      $.extend(r, elementAttrs);
      // 父节点
      var parent = $(e.delegateTarget);
      // 子节点的url以及id，并组合成最终url
      var baseUrl = parent.data('urlBase'),
               id = parent.btnGroup('getLineId').join(',');
      var href = baseUrl + r.url.replace('{id}', id);

      if(r.method == 'delete'){
        if(confirm("你确定要删除此用户吗？此操作不可撤销！！")){
          btnGroupHelper.sendRequest(href, r.method);
        }
      }else if(r.method == 'patch'){
        // 这里需要额外的提交参数，所以要获取一下
        var targets = $e.attr('target');
        // 这里要求必须存在至少一条target，target用|分隔
        if(targets){
          var extData = {};
          targets.split('|').forEach(function (i){
            // 把形如manage_user[is_forbidden]这样的字符串中的is_forbidden提取出来
            var dataField = i.substring(i.indexOf('[') + 1,i.indexOf(']'));
            // 获取指定的额外数据
            var data = parent.btnGroup('getField', dataField);
            if(data !== undefined){
              extData[i] = data;
            }
          });
          btnGroupHelper.sendRequest(href, r.method, extData);
        }else{
          btnGroupHelper.log('patch命令的按钮需要包含至少一条参数');
        }
      }else{
        btnGroupHelper.sendRequest(href, r.method);
      }
      e.stopPropagation();
    });
  };
  function refreshState(parentElem, ids){
    var idl = ids.length;
    $(parentElem).find('a').each(function(i, elem){
      var $elem = $(elem);
      if(idl == 0){
        if($elem.data('needid') != false){
          $elem.attr('disabled', true);
        }
      }else if(idl == 1){
        $elem.removeAttr('disabled');
      }else{
        if($elem.data('multiple') == true){
          $elem.removeAttr('disabled');
        }else{
          if($elem.data('needid') != false){
            $elem.attr('disabled', true);
          }
        }
      }
    });
  };
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
      currentId = [id];
      btnGroupHelper.log('当前设置的活动行号为', id);
      refreshState(this, currentId);
    },
    addLineId: function (id){
      if(currentId.indexOf(id)>=0){
        // 如果id已经存在，就不添加了
        btnGroupHelper.log(id, '已存在，添加失败');
      }else{
        currentId.push(id);
        btnGroupHelper.log('添加', id, '进入当前行号', '当前行号状态：', currentId);
      }
      refreshState(this, currentId);
    },
    removeLineId: function (id){
      var index = currentId.indexOf(id);
      if(index >= 0){
        currentId.splice(index, 1);
        btnGroupHelper.log('删除', id, '，当前行号状态：', currentId);
      }else{
        btnGroupHelper.log('删除', id, '失败，目标不存在');
      }
      refreshState(this, currentId);
    },
    getLineId: function (){
      return currentId;
    },
    setField: function (name, value){
      fieldsData[name] = value;
      btnGroupHelper.log('设置字段', name, '为', value);
    },
    getField: function (name){
      return fieldsData[name];
    },

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
})(window.jQuery);
