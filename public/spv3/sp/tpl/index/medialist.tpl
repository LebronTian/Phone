<link rel="stylesheet" href="/app/sp/static/css/sigle.css"/>
<link rel="stylesheet" href="/app/sp/static/css/dabble.css"/>
<link rel="stylesheet" href="/app/sp/static/css/medialist.css"/>
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/qqface.css?v=0.2">

<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <strong class="am-text-primary am-text-lg">微信素材列表</strong> / <small>管理添加微信素材</small>
    </div>
</div>

<div class="am-tabs" data-am-tabs="">
    <ul class="am-tabs-nav am-nav am-nav-tabs media-nav">
        <li class="am-active"><a href="#tab_text">纯文本素材</a></li>
        <li><a href="#tab_pic">单图文素材</a></li>
       <!-- <li><a href="#tab_pics">小程序卡片</a></li> -->
    </ul>
    <div class="am-tabs-bd media-body" style="touch-action: pan-y; -webkit-user-select: none; -webkit-user-drag: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);">
        <!--纯文本-->
        <div class="am-tab-panel am-active" id="tab_text">
            <!--内容-->
            <div class="media-content content-1">
                <div class="add-box">
                    <img src="/app/sp/static/images/add.png"/>
                </div>
            </div>
            <!--分页导航-->
            <div class="media-page">
                <hr />
                <ul class="am-pagination page-list list-1">
                </ul>
            </div>
        </div>
        <!--单图文-->
        <div class="am-tab-panel" id="tab_pic">
            <!--内容-->
            <div class="media-content content-2">
                <div class="add-box">
                    <img src="/app/sp/static/images/add.png"/>
                </div>
            </div>
            <!--分页导航-->
            <div class="media-page">
                <hr />
                <ul class="am-pagination page-list list-2">
                </ul>
            </div>
        </div>
        <!--多图文-->
        <div class="am-tab-panel" id="tab_pics">
            <!--内容-->
            <div class="media-content content-3">
                <div class="add-box" style="width: 320px">
                    <img src="/app/sp/static/images/add.png"/>
                </div>
            </div>
            <div class="pics-body-boxs">

            </div>
            <!--分页导航-->
            <div class="media-page">
                <hr />
                <ul class="am-pagination page-list list-3">
                </ul>
            </div>
        </div>
    </div>
</div>
<!--纯文本编辑弹出框-->
<div class="am-modal am-modal-no-btn" tabindex="-1" id="text-modal">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">添加纯文本素材
            <a href="javascript: void(0)" class="am-close am-close-spin text-close" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd">
            <!--****开始*************************************************-->
            <div style="position:relative;text-align: left">
                <div id="show" contenteditable="true"></div>
                <div class="comment">
                    <div class="com_form">
                        <textarea id="showtext" name="showtext" style="display:none;"></textarea>
                        <textarea class="input" id="saytext" name="saytext" style="display:none;"></textarea>
                        <p><span class="emotion"><img src="/app/sp/static/images/qqfaceicon.png" alt=""></span></p>
                    </div>
                </div>
                <button class="wx_edit_face am-btn am-btn-primary text-save">保存</button>
            </div>
        </div>
    </div>
</div>



<!--单图文编辑弹出框-->
<div class="am-modal am-modal-no-btn" tabindex="-1" id="pic-modal">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">添加单图文素材
            <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd">
            <!--****开始*************************************************-->
            <div class="s_main_bd">
                <div class="s_preview_area">
                    <h4 class="s_appmsg_title">
                        <a onclick="return false;" href="javascript:void(0);" class="s_title" target="_blank">标题</a>
                    </h4>
                    <div class="s_appmsg_thumb_wrp">
                        <img class="s_appmsg_thumb" src="">
                    </div>
                    <p style="word-break: break-all" class="s_appmsg_desc"></p>
                </div>
                <div class="s_edit_area" style="position:relative">
                    <div class="s_appmsg_edit_item bt_h">
                        <label for="" class="s_frm_label">标题</label>
			                      <span class="s_frm_input_box">
			                          <input  data-am-popover="{content: '标题不能为空且长度不能超过64字', trigger: 'hover'}" type="text" class="s_frm_input s_frm_input_tit" value="" max-length="64">
			                          <!-- <em class="frm_counter_bt">0/64</em> -->
			                      </span>
                    </div>
                    <div class="s_appmsg_edit_item zz_h" style="display: none">
                        <label for="" class="s_frm_label">作者<span class="sl_enter">（选填）</span></label>
			                      <span class="s_frm_input_box">
			                          <input  data-am-popover="{content: '作者长度不能超过8字', trigger: 'hover'}" type="text" class="s_frm_input s_frm_input_author" max-length="8">
			                          <!-- <em class="frm_counter_zz">0/8</em> -->
			                      </span>
                    </div>
                    <div class="s_appmsg_edit_item s_fm_h">
                        <label for="" class="s_frm_label">图片<span class="sl_enter">（图片建议尺寸：640* 320）</span></label>

                        <div id="s_codeImgBox" style="margin:15px 0;">
                            <img id="s_codeImg" src="" style="width:100px;height:75px;margin-left:8px;z-index:999;"><a href="javascript:;" class="delete_img">删除</a>
                        </div>

                    </div>
                    <!-- 单图文btn -->
                    <button class="btn imgBoxBtn" style="line-height:auto !important;height:auto !important;" data-am-popover="{content: '请选择图片', trigger: 'hover'}">从图片库选择</button>
                    <div class="s_appmsg_edit_item zy_h">
                        <label for="" class="s_frm_label">摘要<span class="sl_enter">（选填）</span></label>
                        <textarea class="s_frm_textarea" max-length="120" data-am-popover="{content: '摘要长度不能超过120字', trigger: 'hover'}"></textarea>
                        <!--  <em class="frm_counter zy_counter">0/120</em> -->
                    </div>
                    <!--正文**********************-->
                    <div class="zw-box" style="display: none">
                        <label for="" class="s_frm_label">正文<span class="sl_enter"></span></label>
                        <script id="container" name="content" type="text/plain" style="height:250px;margin-top:20px;"></script>
                    </div>
                    <div class="s_appmsg_edit_item zz_h">
                        <label for="" class="s_frm_label">跳转链接<span class="sl_enter">（选填）</span></label>
			                      <span class="s_frm_input_box">
			                          <input type="text" class="s_frm_input s_frm_input_link" data-am-popover="{content: '请输入http开头的网址链接', trigger: 'hover'}">
			                      </span>
                    </div>
                </div>
            </div>
            <button class="am-btn am-btn-primary save-button wx_edit_sigle">保存</button>
        </div>
    </div>
</div>

<!--删除确认弹框-->
<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">提示</div>
        <div class="am-modal-bd">
            删除后将无法恢复，你确定要删除吗？
        </div>
        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-cancel>取消</span>
            <span class="am-modal-btn" data-am-modal-confirm>确定</span>
        </div>
    </div>
</div>




<?php
$extra_js = array(
        '/static/js/wx_edit_yhc.js',
        '/app/sp/static/js/jquery.qqFace.js',
        '/app/sp/static/js/data.js',
        '/app/sp/static/js/medialist.js',
        '/static/js/ueditor/ueditor.config.js',
        '/static/js/ueditor/ueditor.all.js',
);
?>

<script>
    seajs.use(['selectPic']);
</script>

