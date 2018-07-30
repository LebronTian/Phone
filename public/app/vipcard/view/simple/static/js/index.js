$(document).ready(function () {
    /*背景图设置*/
    var window_height = $(window).height();
    $("body").css("min-height", window_height);

    //$("#uploadBtn").click(function () {
    //    console.log("!")
    //});

    /*显示*/
    $(".index-content").show();

    /*显示表单页*/
    $(".index-next-button").click(function () {
        if(idData['vip_card_su']['uid'] ==undefined||idData['vip_card_su']['su_uid'] == 0)
        {
            alert('长按二维码关注我先咯！');return;
        }
        $(".index-content").fadeOut("fast", function () {
            $(".form-content").fadeIn(function () {
                /*初始化上传按钮*/
                var uploader_img = new plupload.Uploader({
                    runtimes: 'html5,flash,silverlight,html4',
                    browse_button: "uploadBtn", // you can pass an id...
                    //container: document.getElementById('boxboxbox'), // ... or DOM Element itself
                    url: '?_a=upload&_u=index.upload&type=1',
                    //flash_swf_url : '../js/Moxie.swf',
                    //silverlight_xap_url : '../js/Moxie.xap',
                    file_data_name: 'file',
                    filters: {
                        max_file_size: '20mb',
                        mime_types: [
                            {title: "Image files", extensions: "jpg,gif,png,bmp"}
                        ]
                    },
                    init: {
                        PostInit: function (ret) {
                            //console.log("Post", ret)
                        },
                        FilesAdded: function (up, files) {
                            uploader_img.start();
                            plupload.each(files, function (file) {
                            });
                        },
                        FileUploaded: function (up, files, res) {
                            //console.log("Uploaded", up, files, res);
                            res = JSON.parse(res.response); //PHP上传成功后返回的参数
                            $("#uploadBtn").addClass("card-user-pic").attr("src", res.data.url);
                            $(".special-input-avatar").val(res.data.url);
                            plupload.each(files, function (file) {
                            });
                        },
                        UploadProgress: function (up, file) {
                            //console.log("Progress",up,file);
                        },
                        UploadComplete: function (up, file) {
                        },
                        Error: function (up, err) {
                            //console.log("error", up, err)
                        }
                    }
                });

                uploader_img.init();
            })
        })
    });
    /*生成会员卡！！！*/
    $(".form-next-button").click(function () {
        var form_data = {};
        var status = false;
        $(".form-box").find(".form-input").each(function () {
            var type = $(this).data("type");
            var group = $(this).data("group");
            var need = $(this).data("need");
            var val = $(this).val();

            if (need && (val == "")) {
                var text = $(this).siblings().children("span").text();
                alert(text + "不能为空");
                status = true;
                return false
            }

            //if(group=="vip_card_su"){
            //    if(form_data['vip_card_su'] ==undefined) form_data['vip_card_su']={};
            //    if(form_data['vip_card_su'][group] ==undefined) form_data['vip_card_su'][group]={};
            //    form_data['vip_card_su'][group][type] = val;
            //}
            //else{
                if(form_data[group] ==undefined) form_data[group] = {};
                form_data[group][type] = val;
            //}
        });
        if (status) return;

        console.log(form_data);
        var real_data = {
            vip_card_info:form_data
        };

        $.post("?_a=vipcard&_u=ajax.edit_vip_card", real_data, function (ret) {
            console.log(ret);
            ret = $.parseJSON(ret);
            if(ret.errno==0){
                $(".form-content").fadeOut("fast", function () {
                    $(".card-content").fadeIn();
                    $(".card-user-name").text(form_data['user']['name']);
                })
            }
            else alert('提交失败');
        });

    });

});
