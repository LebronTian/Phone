
<link rel="stylesheet" href="/app/sp/static/css/sigle.css"/>
<link rel="stylesheet" href="/app/sp/static/css/dabble.css"/>
<link rel="stylesheet" href="/app/sp/static/css/picsmedia.css"/>

<div class="am-cf am-padding" data-id="">
    <div class="am-fl am-cf">
        <strong class="am-text-primary am-text-lg">微信素材列表</strong> / <small>管理添加微信素材</small>
    </div>
</div>
<ol class="am-breadcrumb pics-ol">
    <li><a href="/?_a=sp">首页</a></li>
    <li><a href="/?_a=sp&_u=index.medialist">素材列表</a></li>
    <li class="am-active">新增多图文素材</li>
</ol>

<div style="" class="wx_edit_cont_dabble">

    <div style="overflow: hidden;width: 910px;margin-left: 20px">
        <div class="msg_navLeft" style="float: left">

            <div id="appmsgItem1" data-fileid="" data-id="1">

                <a onclick="return false;" href="javascript:void(0);" class="title" target="_blank">标题</a>

                <div class="appmsg_thumb_wrp">
                    <img class="appmsg_thumb" src="">
                </div>
                <a href="#" class="msg_edit_b"></a>
            </div>

            <div class="small-msg" id="appmsgItem2" data-fileid="" data-id="2">
                <a href="#" class="title_s">标题</a>
                <img src="" class="msg_img">
                <input class="msg-url" type="hidden"/><!--url记录-->
                <a href="javascript:;" class="msg_edit_s"><img class="edit_img" src="/app/sp/static/images/edit.png"></a>
            </div>

            <div id="addItems"></div>
        </div>
        <!--编辑框*****************************-->
        <div class="edit_area_b">
            <div class="appmsg_edit_item bt_h">
                <label for="" class="frm_label">标题</label>
                  <span class="frm_input_box">
                      <input data-am-popover="{content: '标题不能为空且长度不能超过64字', trigger: 'hover'}" type="text" class="frm_input frm_input_tit" value="" max-length="64">
                      <!-- <em class="frm_counter">0/64</em> -->
                  </span>
                <div class="frm_msg fail js_title_error" style="display: none;">标题不能为空且长度不能超过64字</div>
            </div>

            <div class="appmsg_edit_item zz_h" style="display: none">
                <label for="" class="frm_label">作者<span class="sl_enter">（选填）</span></label>
                  <span class="frm_input_box">
                      <input data-am-popover="{content: '作者长度不能超过8字', trigger: 'hover'}" type="text" class="frm_input frm_input_author" max-length="8">
                      <!-- <em class="frm_counter zz">0/8</em> -->
                  </span>
                <div class="frm_msg fail js_title_error" style="display: none;">标题不能为空且长度不能超过64字</div>
            </div>
            <div class="appmsg_edit_item fm_h">
                <label for="" class="frm_label">封面<span class="sl_enter">（大图片建议尺寸：320像素 * 200像素）</span></label>
                <div id="codeImgBox" style="margin:15px 0;">
                    <img id="codeImg1" src="" style="width:100px;height:75px;margin-left:8px;z-index:999;"><a style="display: none" href="javascript:;" class="delete_img">删除</a>
                </div>
                <div class="frm_msg fail js_title_error" style="display: none;">标题不能为空且长度不能超过64字</div>
            </div>
            <!-- 多图文btn -->
            <button class="imgBoxBtn am-btn am-btn-primary" data-addr="#codeImg1" data-func="afterSelectPic">从图片库选择</button>
            <!--正文**********************-->
            <div class="zw-box" style="display: none">
                <label for="" class="s_frm_label">正文<span class="sl_enter"></span></label>
                <script id="container1" name="content" type="text/plain" style="height:250px;margin-top:20px;"></script>
            </div>
            <div class="appmsg_edit_item zz_h">
                <label for="" class="frm_label">原文链接<span class="sl_enter">（选填）</span></label>
                  <span class="frm_input_box">
                      <input type="text" class="frm_input frm_input_link" data-am-popover="{content: '请输入带有http://的正确链接', trigger: 'hover'}">
                  </span>
                <div class="frm_msg fail js_title_error" style="display: none;">标题不能为空且长度不能超过64字</div>
            </div>
        </div>
        <!--编辑框*****************************-->
        <div class="edit_area_s appmsgItem">
            <div class="appmsg_edit_item bt_h">
                <label for="" class="frm_label">标题</label>
                  <span class="frm_input_box">
                      <input data-am-popover="{content: '标题不能为空且长度不能超过64字', trigger: 'hover'}" type="text" class="frm_input frm_input_tit" id="title_txt" value="" max-length="64">
                      <!-- <em class="frm_counter">0/64</em> -->
                  </span>
                <div class="frm_msg fail js_title_error" style="display: none;">标题不能为空且长度不能超过64字</div>
            </div>
            <div class="appmsg_edit_item zz_h" style="display: none">
                <label for="" class="frm_label">作者<span class="sl_enter">（选填）</span></label>
                  <span class="frm_input_box">
                      <input data-am-popover="{content: '作者长度不能超过8字', trigger: 'hover'}" type="text" class="frm_input frm_input_author" max-length="8">
                      <!-- <em class="frm_counter zz">0/8</em> -->
                  </span>
                <div class="frm_msg fail js_title_error" style="display: none;">标题不能为空且长度不能超过64字</div>
            </div>
            <div class="appmsg_edit_item fm_h_s">
                <label for="" class="frm_label">封面<span class="sl_enter">（大图片建议尺寸：200像素 * 200像素）</span></label>
                <div id="codeImgBox" style="margin: 15px 0">
                    <img id="codeImg2" src="" style="width:100px;height:75px;margin-left:8px;z-index:999;"><a style="display: none" href="javascript:;" class="delete_img_s">删除</a>
                </div>
                <div class="frm_msg fail js_title_error" style="display: none;">标题不能为空且长度不能超过64字</div>
            </div>
            <button class="imgBoxBtn am-btn am-btn-primary" data-addr="#codeImg2" data-func="afterSelectPic">从图片库选择</button>
            <!--正文**********************-->
            <div class="zw-box" style="display: none">
                <label for="" class="s_frm_label">正文<span class="sl_enter"></span></label>
                <script id="container2" name="content" type="text/plain" style="height:250px;margin-top:20px;"></script>
            </div>
            <div class="appmsg_edit_item zz_h">
                <label for="" class="frm_label">原文链接<span class="sl_enter">（选填）</span></label>
                  <span class="frm_input_box">
                      <input type="text" class="frm_input frm_input_link" data-am-popover="{content: '请输入带有http://的正确链接', trigger: 'hover'}">
                  </span>
                <div class="frm_msg fail js_title_error" style="display: none;">标题不能为空且长度不能超过64字</div>
            </div>
        </div>


    </div>


    <button class="wx_edit_dabble am-btn am-btn-primary pics-save">保存</button>
</div>


<?php
echo
    '<script>
	var g_media = '.json_encode($media).';
    console.log("g_media",g_media)
    </script>';
?>


<?php
$extra_js = array(
    '/static/js/wx_edit_yhc.js',
    '/app/sp/static/js/jquery.qqFace.js',

    '/app/sp/static/js/dabble.js',
    '/static/js/ueditor/ueditor.config.js',
    '/static/js/ueditor/ueditor.all.js',

);
?>
<script>
    seajs.use(['selectPic']);

    function afterSelectPic(){
        var imgSrc = $(".pic-chose").children("img").attr("src");
        var edit = $(".edit_area_b").css("display");
        if(edit=="block"){
            $(".appmsg_thumb").attr("src",imgSrc);
            $("#codeImg1").attr("src",imgSrc).parent().show()
        }
        else{
            var id = parseInt($(".edit_area_s").attr("data-id"));
            $("#appmsgItem"+id).children(".msg_img").attr("src",imgSrc);
            $("#codeImg2").attr("src",imgSrc).parent().show()
        }
    }
</script>
