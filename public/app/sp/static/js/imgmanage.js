$(document).ready(function () {


    /*获取分类*/
    $.getJSON("?_a=upload&_u=index.get_file_group", function (ret) {
        //console.log(ret);
        var type_html = '';
        var type_html2 = '';
        type_html +='<li class="system-type-li'+'" data-uid="0">所有</li>';
        $.each(ret.data.list, function (index) {
            type_html +='<li class="system-type-li'+((index==1)?" active-type-li":"")+'" data-uid="'+index+'">'+this+'</li>';
            type_html2 +='<li data-uid="'+index+'"><a>'+this+'</a></li>';

        });
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
            $.each(ret.data.list, function () {
                img_html += '<li class="img-box-li" style="display: none"><img class="img-box-img" src="'+this.url+'"/>'+
                '<a data-uid="'+this.uid+'" class="am-icon-navicon movepic"></a><a data-uid="'+this.uid+'" class="am-icon-trash-o delpic"></a>' +'</li>'
            });
            $(".img-box-ul").html(img_html).children("li").fadeIn();


            /*
            var data = [
                {
                    "name":       "Tiger Nixon",
                    "position":   "System Architect",
                    "salary":     "$3,120",
                    "start_date": "2011/04/25",
                    "office":     "Edinburgh",
                    "extn":       "5421"
                },
                {
                    "name":       "Garrett Winters",
                    "position":   "Director",
                    "salary":     "$5,300",
                    "start_date": "2011/07/25",
                    "office":     "Edinburgh",
                    "extn":       "8422"
                }
            ];
            if(uid==1){
                data = [
                    {
                        "name":       "Ti3123ger 11",
                        "position":   "Sys1222te123m 1",
                        "salary":     "$3123,120123",
                        "start_date": "201231121/04/25",
                        "office":     "Edin12burgh",
                        "extn":       "54231231"
                    },
                    {
                        "name":       "Gar211232rett Wi123nters",
                        "position":   "Dir12123123123ect123or",
                        "salary":     "$5123112323,300",
                        "start_date": "20123112311/07/25",
                        "office":     "Edi2323312322"
                    }
                ];
            }

            var aaa = $("#my-table").DataTable({
                data:data,
                columns: [
                    { data: 'name' },
                    { data: 'position' },
                    { data: 'salary' },
                    { data: 'office' }
                ]
            });
            aaa.page("next")
            */
        })
    }

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

    $("#movelist").on("click", function(e){
        e.stopPropagation();
    });

    var uid;
    $('.img-box').on('click','.movepic',function(e){
        uid =$(this).attr('data-uid');

        var X = $(this).offset().top;
        var Y = $(this).offset().left;
        $("#movelist").css("top",X-65);
        $("#movelist").css("left",Y-250);

        $('#movelist').addClass('am-active');
        $(document).one("click", function(){
            $("#movelist").removeClass('am-active');

        });
        e.stopPropagation();
    });

    $('.am-dropdown').on('click','.am-dropdown-content li',function(e){
        var file_group =$(this).attr('data-uid');

        if(file_group){
            $.post("?_a=upload&_u=ajax.edit_file_group",{uid:uid,file_group:file_group},function(result){
                console.log(result);
                result=$.parseJSON(result);
                if(result.errno == 0){
                    showTip("","移动成功","1000");
                    setTimeout(function () {
                        window.location.reload()
                    },1000)
                }
            });
        }

    });

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
                    res = JSON.parse(res.response); //PHP上传成功后返回的参数
                    console.log("res",res);
                    var img = '<li class="img-box-li"><img src="'+res.data.url+'"/>'+
                    '<a data-uid="'+this.uid+'" class="am-icon-trash-o delpic"></a>' +'</li>';
                    $(".img-box-ul").prepend(img)
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
        //console.log(group_uid);
        upload_func(group_uid)
    });



});