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
//= require ckplayer.js
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
var noMatch = /(.)^/;

(function(){var root=this;var breaker={};var ArrayProto=Array.prototype,ObjProto=Object.prototype,FuncProto=Function.prototype;var push=ArrayProto.push,slice=ArrayProto.slice,concat=ArrayProto.concat,toString=ObjProto.toString,hasOwnProperty=ObjProto.hasOwnProperty;var nativeForEach=ArrayProto.forEach,nativeMap=ArrayProto.map,nativeReduce=ArrayProto.reduce,nativeReduceRight=ArrayProto.reduceRight,nativeFilter=ArrayProto.filter,nativeEvery=ArrayProto.every,nativeSome=ArrayProto.some,nativeIndexOf=ArrayProto.indexOf,nativeLastIndexOf=ArrayProto.lastIndexOf,nativeIsArray=Array.isArray,nativeKeys=Object.keys,nativeBind=FuncProto.bind;var _=function(obj){if(obj instanceof _)return obj;if(!(this instanceof _))return new _(obj);this._wrapped=obj};root._=_;var each=_.each=_.forEach=function(obj,iterator,context){if(obj==null)return obj;if(nativeForEach&&obj.forEach===nativeForEach){obj.forEach(iterator,context)}else if(obj.length===+obj.length){for(var i=0,length=obj.length;i<length;i++){if(iterator.call(context,obj[i],i,obj)===breaker)return}}else{var keys=_.keys(obj);for(var i=0,length=keys.length;i<length;i++){if(iterator.call(context,obj[keys[i]],keys[i],obj)===breaker)return}}return obj};_.defaults=function(obj){each(slice.call(arguments,1),function(source){if(source){for(var prop in source){if(obj[prop]===void 0)obj[prop]=source[prop]}}});return obj};_.templateSettings={evaluate:/<%([\s\S]+?)%>/g,interpolate:/<%=([\s\S]+?)%>/g,escape:/<%-([\s\S]+?)%>/g};var escapes={"'":"'","\\":"\\","\r":"r","\n":"n","	":"t","\u2028":"u2028","\u2029":"u2029"};var escaper=/\\|'|\r|\n|\t|\u2028|\u2029/g;_.template=function(text,data,settings){var render;settings=_.defaults({},settings,_.templateSettings);var matcher=new RegExp([(settings.escape||noMatch).source,(settings.interpolate||noMatch).source,(settings.evaluate||noMatch).source].join("|")+"|$","g");var index=0;var source="__p+='";text.replace(matcher,function(match,escape,interpolate,evaluate,offset){source+=text.slice(index,offset).replace(escaper,function(match){return"\\"+escapes[match]});if(escape){source+="'+\n((__t=("+escape+"))==null?'':_.escape(__t))+\n'"}if(interpolate){source+="'+\n((__t=("+interpolate+"))==null?'':__t)+\n'"}if(evaluate){source+="';\n"+evaluate+"\n__p+='"}index=offset+match.length;return match});source+="';\n";if(!settings.variable)source="with(obj||{}){\n"+source+"}\n";source="var __t,__p='',__j=Array.prototype.join,"+"print=function(){__p+=__j.call(arguments,'');};\n"+source+"return __p;\n";try{render=new Function(settings.variable||"obj","_",source)}catch(e){e.source=source;throw e}if(data)return render(data,_);var template=function(data){return render.call(this,data,_)};template.source="function("+(settings.variable||"obj")+"){\n"+source+"}";return template}}).call(window);
