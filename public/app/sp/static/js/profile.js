$(function(){

    /*
        公司 个人 身份填写资料提示
    
    if(profileJSON.type=='0' || profileJSON.type=='2'){
        $('.person_name').hide();
        $('.company_name').show();
        $('.person_qq').hide();
        $('.company_qq').show();
    }
    if(profileJSON.type=='1'){
        $('.person_name').show();
        $('.company_name').hide();
        $('.person_qq').show();
        $('.company_qq').hide();
    }

*/

    //文本编辑框初始化
    var ue = UE.getEditor('container');

    /**图片截取功能启动+预览*************************************************************************/
    // Create variables (in this scope) to hold the API and image size
    var jcrop_api,
        boundx,
        boundy,
    // Grab some information about the preview pane
        $preview = $('#preview-pane'),
        $pcnt = $('#preview-pane .preview-container'),
        $pimg = $('#preview-pane .preview-container img'),

        xsize = $pcnt.width(),
        ysize = $pcnt.height();

    console.log('init',[xsize,ysize]);
    /*Jcrop启动*/
    var pic_real_width, pic_real_height;   //原图长宽，用作判断预览盒子大小和缩放比

    $(".selete_btn").click(function () {
        var oldImg = $(".pic-chose").children("img"); // Get my img elem
        $(".justforselect") // Make in memory copy of image to avoid css issues
            .attr("src", oldImg.data("src"))
            .load(function() {
                pic_real_width = this.width;   // Note: $(this).width() will not
                pic_real_height = this.height; // work for in memory images.
                //判断有没有图，没有图代表不是商户头像事件
                if($(".jcrop-preview").attr("src")==""){
                    return
                }
                /*****************************************/
                if(pic_real_width>500){
                    $("#client-avatar").css({
                        "width":"500px",
                        "height":"auto"
                    });
                }else if(pic_real_height<260){
                    $("#client-avatar").css({
                        "width":"auto",
                        "height":"260px"
                    });
                }else{
                    $("#client-avatar").css({
                        "width":pic_real_width,
                        "height":"auto"
                    });
                }

                $(".client-btn").hide();        //不能选择第二次图片
                /*启动！！！！！！*/
                 $('#client-avatar').Jcrop({
                 onChange: updatePreview,
                 onSelect: updatePreview,
                 aspectRatio: xsize / ysize
                 },function(){
                 // Use the API to get the real image size
                 var bounds = this.getBounds();
                 boundx = bounds[0];
                 boundy = bounds[1];
                 // Store the API in the jcrop_api variable
                 jcrop_api = this;

                 // Move the preview into the jcrop container for css positioning
                 $preview.appendTo(jcrop_api.ui.holder);
                     /*yhc*/
                     $(".jcrop-preview").attr("src",$("#client-avatar").attr("src"));
                     $("#preview-pane").show();
                 });

            });
    });
    function updatePreview(c){
        if (parseInt(c.w) > 0) {
            var rx = xsize / c.w;
            var ry = ysize / c.h;

            $pimg.css({
                width: Math.round(rx * boundx) + 'px',
                height: Math.round(ry * boundy) + 'px',
                marginLeft: '-' + Math.round(rx * c.x) + 'px',
                marginTop: '-' + Math.round(ry * c.y) + 'px'
            });
        }
    }
    /*******************************************************************************/
    /*
    * 截取图片确定按钮
    * */
    $(".getNewPic").click(function () {
        var imgUrl = $("#client-avatar").attr("src");
        var key = imgUrl.indexOf("uidm");     //key获取uidm在字符串里面的位置
        var uidm = imgUrl.substring(key+5);   //uidm=对应+5，这里意思是取uidm后面的所有字符，所以uidm后面不能有其他字符
        /*
        console.log("获取选框的值（实际尺寸）",jcrop_api.tellSelect());
        console.log("获取选框的值（界面尺寸）",jcrop_api.tellScaled().h);
        console.log("获取图片实际尺寸",jcrop_api.getBounds()[0]);
        console.log("获取图片显示尺寸",jcrop_api.getWidgetSize());
        console.log("获取图片缩放的比例",jcrop_api.getScaleFactor());
        */
        var aspect=1;       // 缩放比例, 默认 1
        var width=jcrop_api.tellScaled().w;        //宽, 默认 64,选取框的
        var height=jcrop_api.tellScaled().h;       //高, 默认 64选取框的
        var x=jcrop_api.tellScaled().x;            //左上角位置x, 默认 0选取框的
        var y=jcrop_api.tellScaled().y;            //左上角位置y, 默认 0选取框的

        aspect=(jcrop_api.getBounds()[0])/(pic_real_width);

        var link ="?_a=upload&_u=index.crop";
        var data= {
            uidm: uidm,
            aspect: aspect,
            width: width,
            height: height,
            x: x,
            y: y
        };
        $.post(link,data,function(data){
            data = JSON.parse(data);
            var newPic = data.data.url;
            //jcrop_api.disable();  //禁用
            jcrop_api.destroy();    //删除
            $("#client-avatar").attr("src",newPic).css({
                "width":"100px",
                "height":"100px"
            })
        });
    });
    /***********************************************
    * 提交保存按钮
    * */
    $('#save-btn').click(function(){
        //获取文本框的内容
        var fullname=$('#fullname').val();
        var email=$('#email').val();
        var phone=$('#phone').val();
        var QQ=$('#QQ').val();
        var industry=$('#industry').val();
        var brief;
        ue.ready(function(){
            brief = ue.getContent();
        });
        var qrcode=$('#codeImgBox').find('img').attr('src');
        var avatar=$('#client-avatar').attr('src');
        var address=$('#address').val();
        var lng=$('#p_lng').val();
        var lat=$('#p_lat').val();
        var data={
            fullname:fullname,
            email:email,
            phone:phone,
            qq:QQ,
            brief:brief,
            qrcode:qrcode,
            avatar:avatar,
            address:address,
            industry:industry,
            lng:lng,
            lat:lat
        };
        console.log(data);
        $.post('?_a=sp&_u=index.profile',data,function(obj){
            obj = $.parseJSON(obj);
            console.log(obj);
            if(obj.errno==0){
                showTip("","提交成功",1000);
                setTimeout(function(){
                    window.location.reload();
                },1000);
            }else{
                $('.err_info').css('display','block').text('提交失败!');
                return false;
            }

        })
    });

});
/*******************************************************************************************************/
$(function() {
    //城市联动
/*
    $('.am-form select').css({'width':'50%','display':'inline'});
    var opts = {
        data: districtData,
        selStyle: 'margin-left: 3px;',
        select:  '#demo2',
        dataReader: {id: 'id', name: 'name', cell: 'cell'}
    };
    var linkageSel2 = new LinkageSel(opts);
    $('#getValueArr2').click(function() {
        var arr = linkageSel2.getSelectedArr();
        alert(arr.join(','));
    });
    linkageSel2.onChange(function() {
        var input = $('#tip'),
            d = this.getSelectedDataArr('name'),
            //                zip = this.getSelectedData('code'),
            arr = [];
        for (var i = 0, len = d.length; i < len; i++) {
            arr.push(d[i]);
        }
            //              zip = zip ? ' 行政区划代码:' + zip : '';
        input.val(arr.join(''));
    });
*/
})





