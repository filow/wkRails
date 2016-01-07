/**
 * Created by filowlee on 16/1/6.
 */

var creation_form = new Vue({
  el:'#creation_form',
  data: {
    authors: [],
    name: '',
    desc: '',
    file: {
      thumb: {size: 0, filename: '', url: '', error: null},
      doc: {size: 0, filename: '', error: null},
      ppt: {size: 0, filename: '', error: null}
    }
  },
  filters: {
    sizeInM: function (val){
      return Math.floor(val / 1024 / 1024 * 100) / 100;
    }
  },
  ready: function (){
    var time;
    var url = document.getElementById('creation_form').getAttribute('action');
    $.get(url + '.json', function (data){
      this.authors = data.authors;
      this.name = data.name;
      this.desc = data.desc;

      if (data.thumb.small.indexOf("nothumb") < 0){
        this.file.thumb.url = data.thumb.small;
      }


      if(data.doc !== ""){
        this.file.doc.size = data.doc.size;
        time = moment(data.doc.time);
        this.file.doc.filename = '已于' + time.calendar() + '上传, 点击可重传';
      }
      if(data.ppt !== ""){
        this.file.ppt.size = data.ppt.size;
        time = moment(data.ppt.time);
        this.file.ppt.filename = '已于' + time.calendar() + '上传, 点击可重传';
      }
    }.bind(this))
  },
  methods: {
    deleteLine: function (index){
      this.authors.splice(index, 1)
    },
    addLine: function (){
      this.authors.push({
        name: '',
        sex: 'male',
        department: '',
        phone: '',
        email: ''
      })
    },
    checkName: function (){

    },
    file_v: function (e){
      var selected_file = e.target.files[0];
      var name = e.target.name;
      console.log(selected_file)

      if (selected_file){
        var allowedExt = e.target.getAttribute('data-ext').split('|');
        var ext = selected_file.name.substr(selected_file.name.lastIndexOf('.')+1).toLocaleLowerCase();
        var allowedSize = parseInt(e.target.getAttribute('data-size'));
        this.file[name].error = null;
        if(selected_file.size > allowedSize) {
          this.file[name].error = "文件大小超过限制";
          e.target.value = ""
        }
        if(allowedExt.indexOf(ext) < 0) {
          this.file[name].error = "文件格式不正确";
          e.target.value = ""
        }

        this.file[name].filename = selected_file.name;
        this.file[name].size = selected_file.size;

        if (name == 'thumb'){
          var reader = new FileReader();
          reader.onload = function(e) {
            this.file.thumb.url = e.target.result;
          }.bind(this);
          reader.readAsDataURL(selected_file);
        }
      }
    }
  }
});