大概的介绍
----------

jquery.btnGroup是在项目内部使用的一个库，它可以使用一些简单的标签构造出一个可以动态响应用户请求的标签组。

使用方法
--------

首先构造这样的一个标签树：

    <section id="btnGroup" data-base="<%= manage_users_url %>">
      <a role="new">新建用户</a>
      <div class="btn-group" role="group">
        <a role="show"></a>
        <a role="edit"></a>
        <a role="toggle" target="manage_user[is_forbidden]">切换禁用</a>
        <a role="delete"></a>
      </div>
    </section>

其中，data-base是必选的，如果不存在这个参数的话，请在初始化的时候传入urlBase参数。该参数只能是一个  
http或者https地址，且不能跨域。

标签内的a元素会被解析，其中你可以给他们配置以下属性：

|属性名|介绍|取值范围|  
|—|:—|:—|  
|role|按钮的角色，决定了其默认的行为|new, show, edit, toggle, delete|  
|data-button|按钮的样式|default, primary, success, warning, danger|  
|data-icon|按钮的图标|bootstrap提供的图标|  
|disabled|如果不传入会默认为真，即默认按钮不能点击|true,false|  
|data-url|点击后引向的地址，你可以使用“{id}”来替代具体的id|无|  
|data-method|决定的请求的方式|get,patch,delete|  
a元素内如果写了文字，则生成的按钮内部也会是这个文字，否则就会根据role填入默认的文字。

### 如何初始化

    $('section.btnGroup').btnGroup();

参数：  
 urlBase: 默认为’tag’，即从标签中读取，也可以传入一个url地址

### 方法

setLineId(id): 设置当前记录ID，暂时只支持单个id

getLineId(): 获取当前ID

setField(name, value):
设置额外的属性，主要给patch方法使用，一般是表单字段名，例如is\_forbidden

getField(name): 获取额外的属性
