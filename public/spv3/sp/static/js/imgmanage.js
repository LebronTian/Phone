$(document).ready(function () {
    /*获取分类*/
    $.getJSON("?_a=upload&_u=index.get_file_group&with_cnt=1", function (ret) {
        console.log("image class ret >>>",ret);
        var type_html = '';
        var type_html2 = '';
        type_html +='<li class="system-type-li'+'" data-uid="0"><div>所有</div></li>';
        $.each(ret.data.list, function (index) {
            type_html +='<li class="system-type-li'+((index==1)?" active-type-li":"")+'" data-uid="'+index+'"><div>'+this.title+'<p>['+this.cnt+']</p></div></li>';
            type_html2 +='<li data-uid="'+index+'"><a>'+this.title+'</a></li>';
        });
        $(".header-title").text(ret.data.list[1].title);

        $(".type-box-ul .type-title-li").after(type_html);
        $(" .am-dropdown .am-dropdown-content").append(type_html2);
        get_system_img()
    });
    /*获取图片*/
    function get_system_img(page){
        if(!page) page=0;
        var uid = $(".active-type-li").data("uid");
        var data = {
            page:page,
            file_group:uid,
            limit:-1
        };
        $.getJSON("?_a=upload&_u=index.sp_img_list",data, function (ret) {
            //console.log(ret);
            var img_html = '';
            console.log("image data >>>", ret);
            $.each(ret.data.list, function () {
                img_html += '<li class="img-box-li am-fl" data-uid="'+this.uid+'" style="display: none"><img class="img-box-img" src="'+this.url+'"/>'+
                '<div class="img-title"><input type="checkbox" class="ccheck" name="">'+this.file_name+'</div>'+
                ' <a data-uid="'+this.uid+'" class="rename">重命名</a><a data-uid="'+this.uid+'" class="movepic">修改分组</a><a data-uid="'+this.uid+'" class="delpic">删除</a>' +'</li>'
            });
            $(".img-box-ul").html(img_html).children("li").fadeIn();
        });
    }

    // 重命名图片
    /*$('.img-box').on('click','.rename',function(){
        var uid = $(this).attr('data-uid');
        console.log("rename uid >>>", uid);

        $('#rename-prompt').modal({
            relatedTarget: this,
            onConfirm: function(e) {
                console.log(e.data);
                var data = {
                    file_name: e.data,
                    uid: uid
                };
                $.post("?_a=upload&_u=ajax.edit_file_name",data, function (ret) {
                    ret = $.parseJSON(ret);
                    console.log("rename ret", ret);
                    if(ret.errno==0){
                        showTip("","修改成功","1000");
                        setTimeout(function () {
                            window.location.reload()
                        },1000)
                    };
                });
            }
        });
    });*/
    $(function() {
        var uid
        $('.img-box').on('click','.rename',function(){
            uid = $(this).attr('data-uid');
            console.log("rename uid >>>", uid);

            $('#rename-prompt').modal({});
        });
          var $confirm = $('#rename-prompt');
          var $confirmBtn = $confirm.find('[data-am-modal-confirm]');
          var $cancelBtn = $confirm.find('[data-am-modal-cancel]');
          $confirmBtn.off('click.confirm.modal.amui').on('click', function() {
                    var filename=$("#filename").val();
                    console.log(typeof(filename))
                    var pageuid=$(".type-box-ul>.active-type-li").attr("data-uid");
                    var data = {
                        file_name: filename,
                        uid: uid
                    };
                    $.post("?_a=upload&_u=ajax.edit_file_name",data, function (ret) {
                        ret = $.parseJSON(ret);
                        console.log("rename ret", ret);
                        if(ret.errno==0){
                            showTip("","修改成功","1000");
                            setTimeout(function () {
                                get_system_img(pageuid);
                            },1000)
                        };
                    });
                    $("#filename").val("");
          });

          $cancelBtn.off('click.cancel.modal.amui').on('click', function() {
            // do something
          });
    });

    // 删除图片
    $('.img-box').on('click','.delpic',function(){
        var uids =$(this).attr('data-uid');
        if(confirm('确定要删除吗？')){
            var that = this;
            $.post("?_a=upload&_u=ajax.delete_file_info",{uids:uids},function(result){
                console.log(result);
                result=$.parseJSON(result);
                if(result.errno == 0){
                    $(that).parent().remove();
                }
            });
        }
    });

    // 修改图片分组点击事件
    $("#movelist").on("click", function(e){
        e.stopPropagation();
    });

    var uid;
    var picUids = [];

    var moveSinglePic = false;

    $('.img-box').on('click','.movepic',function(e){
        uid =$(this).attr('data-uid');
        console.log($(this).offset());
        var Y = $(this).offset().top;
        var X = $(this).offset().left;
        $("#movelist").css("top",Y-70);
        $("#movelist").css("left",X-250);

        $('#movelist').addClass('am-active');
        $(document).one("click", function(){
            $("#movelist").removeClass('am-active');
        });
        moveSinglePic = true;

        e.stopPropagation();
    });

    $('.all_move').click(function(e){
        var X = $(this).offset().top;
        var Y = $(this).offset().left;
        $("#movelist").css("top",X-10);
        $("#movelist").css("left",Y-230);

        $('#movelist').addClass('am-active');
        $(document).one("click", function(){
            $("#movelist").removeClass('am-active');
        });
        
        picUids = [];
        $('.ccheck').each(function(){
            if ($(this).prop('checked')) {
                picUids.push($(this).parent().parent().attr('data-uid'));
            }
        });
        console.log(picUids);
        if(!picUids.length) {
            alert('请选择项目!');return;
        }
        moveSinglePic = false;

        e.stopPropagation();
    });

    $('.am-dropdown').on('click','.am-dropdown-content li',function(e){
        var file_group =$(this).attr('data-uid');
        if (file_group && moveSinglePic) {
            console.log(uid);
            var data = {uid:uid,file_group:file_group};
            movePicGroup(data);
        } else if (file_group && !moveSinglePic) {
            console.log("pic uids >>>", picUids);
            var data = {uids:picUids,file_group:file_group};
            movePicGroup(data);
        }
    });

    // 修改分类接口
    function movePicGroup(data) {
        $.post("?_a=upload&_u=ajax.edit_file_group",data,function(result){
            console.log(result);
            result = $.parseJSON(result);
            if(result.errno == 0){
                showTip("","移动成功","1000");
                setTimeout(function () {
                    window.location.reload()
                },1000)
            }
        });
    }

    /*添加分类*/
    $(".type-add-li").click(function () {
        $('#my-prompt').modal({
            relatedTarget: this,
            onConfirm: function(e) {
                console.log(e.data);
                var data = {
                    file_group_list:{
                        "0": e.data
                    }
                };
                $.post("?_a=sp&_u=api.edit_file_group_list",data, function (ret) {
                    ret = $.parseJSON(ret);
                    //console.log(ret);
                    if(ret.errno==0){
                        showTip("","添加成功","1000");
                        setTimeout(function () {
                            window.location.reload()
                        },1000)
                    }
                })

            }
        });
    });
    $(".type-red-li").click(function () {
        var file_group_id = $('.active-type-li').attr('data-uid');
        console.log(file_group_id);
        var data = {
            file_group_id:file_group_id
        };
        if(confirm('确定要删除吗？')) {
            $.post("?_a=sp&_u=api.del_file_group", data, function (ret) {
                ret = $.parseJSON(ret);
                if (ret.errno == 0) {
                    showTip("", "删除成功", "1000");
                    setTimeout(function () {
                        window.location.reload()
                    }, 1000)
                }
            })
        }

    })
    /*类别选择*/
    var uploader;
    function upload_func(uid){
        /*var pageuid=$(".type-type-li .active-type-li").attr("data-uid");
        console.log("pageuid");*/
        uploader = new plupload.Uploader({
            runtimes : 'html5,flash,silverlight,html4',
            browse_button : "imgUpload", // you can pass an id...
            //container: document.getElementById('container'), // ... or DOM Element itself
            url : '?_a=upload&_u=index.upload&type=1&file_group='+uid,
            //flash_swf_url : '../js/Moxie.swf',
            //silverlight_xap_url : '../js/Moxie.xap',
            file_data_name : 'file',
            filters : {
                max_file_size : '2mb',
                mime_types: [
                    {title : "Image files", extensions : "jpg,gif,png,bmp"}
                ]
            },
            init: {
                PostInit: function() {
                },
                FilesAdded: function(up, files) {
                    uploader.start();

                    plupload.each(files, function(file) {

                    });
                },
                FileUploaded: function(up, files ,res) {
                    var pageuid=$(".type-box-ul>.active-type-li").attr("data-uid");
                    res = JSON.parse(res.response); //PHP上传成功后返回的参数
                    console.log("res",res);
                    var img = '<li class="img-box-li am-fl" data-uid="'+this.uid+'"><img class="img-box-img" src="'+res.data.url+'"/>'+
                '<div class="img-title"><input type="checkbox" class="ccheck" name="">sefsefsefsefsefssefsefssfsfefe</div>'+
                ' <a data-uid="'+this.uid+'" class="rename">重命名</a><a data-uid="'+this.uid+'" class="movepic">修改分组</a><a data-uid="'+this.uid+'" class="delpic">删除</a>' +'</li>';
                    $(".img-box-ul").prepend(img);
                    get_system_img(pageuid);
                },
                UploadProgress: function(up, file) {
                },

                UploadComplete: function(up, file) {
                    console.log("UploadComplete");
                    //window.location.reload()
                },
                Error: function(up, err) {
                }
            }
        });
        uploader.init();
    }
    upload_func();

    $(".type-box-ul").on("click",".system-type-li",function () {
        $(this).addClass("active-type-li").siblings().removeClass("active-type-li");
        get_system_img();
        //console.log(uploader,!!uploader);
        if(uploader){
            uploader.destroy()
        }
        /*图片上传初始化*/
        var group_uid = $(this).data("uid");
        var classTitle = $(this).text();
        $(".header-title").text(classTitle);
        // console.log($(this).text());
        upload_func(group_uid)
    });

	$('.img-box-ul').on('mouseenter,mouseleave', '.img-box-li', function(){
		$('a', this).toggle();
	});


    $('.ccheckall').click(function(){
        var checked = $(this).prop('checked');
        $('.ccheck').prop('checked', checked);
    });
    function do_delete(uids) {
        var pageuid=$(".type-box-ul>.active-type-li").attr("data-uid");
        if(!(uids instanceof Array)) {
            uids = [uids];
        }
        var data = {uids: uids.join(';')};
        $.post('?_a=upload&_u=ajax.delete_file_info', data, function(ret){
            console.log(ret);
             get_system_img(pageuid);
        });
    }
    $('.cdeleteall').click(function(){
        var uids = [];
        $('.ccheck').each(function(){
            if ($(this).prop('checked')) {
                uids.push($(this).parent().parent().attr('data-uid'));
            }
        });
        console.log(uids);
        if(!uids.length) {
            alert('请选择项目!');return;
        }
        if(!confirm('确定要删除吗?')) {
            return;
        }
        do_delete(uids);
    });


});
