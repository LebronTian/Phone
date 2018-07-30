
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/sigle.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/dabble.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/qqface.css">
<link rel="stylesheet" type="text/css" href="/static/css/wx_edit.css">
<link rel="stylesheet" type="text/css" href="/app/default/static/css/default_yhc.css">

<div class="am-u-lg-8 am-u-md-12 am-u-sm-centered">

    <div class="am-cf am-padding">
        <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">关注欢迎语</strong> / <small>关注时回复的内容</small></div>
    </div>

    <div class="am-tabs-bd" style="border-top: thin solid #ddd">
        <div class="am-tab-panel am-active" id="tab_msg" data-type="msg">
            <!-- 预览区域 -->
            <div class="preview_box">

            </div>
            <div class="select-btn">
                <p>请选择回复内容</p>
                <button class="am-btn am-btn-secondary selectBtn right-choose-btn" data-type="1">纯文本消息</button>
                <button class="am-btn am-btn-secondary selectBtn right-choose-btn" data-type="2">单图文消息</button>
                <button class="am-btn am-btn-secondary selectBtn right-choose-btn" data-type="3">多图文消息</button>
                <a class="am-btn am-btn-warning right-choose-btn" target="_blank" href="?_a=sp&_u=index.medialist"><span class="am-icon-plus"></span> 新建素材</a>
            </div>
            <p><button style="margin:1rem 0 0 5.7em" class="am-btn am-btn-lg am-btn-primary welcome-save">保存</button></p>
        </div>
        <!--记录-->
        <input type="text" id="dom" value="" style="display:none;">
    </div>

    <!--弹出选择框-->
    <div class="am-modal am-modal-no-btn" tabindex="-1" id="select-box">
        <div class="am-modal-dialog">
            <div class="am-modal-hd">
                <span class="select-title">Modal 标题</span>
                <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
            </div>
            <div class="am-modal-bd select-box">
                <!--内容放这里--------->
                <div class="select-body"></div>
                <!--页码--------->
                <ul class="am-pagination select-page">

                </ul>
            </div>
        </div>
    </div>
</div>
<?php
echo '<script>
        /*dft-js使用的*/
        var g_msg_mode = '.(!empty($dft['proxy']['msg_mode']) ? $dft['proxy']['msg_mode'] : 1).';
		var g_type = "'.(!empty($dft['type']) ? $dft['type'] : 'msg').'";
		/*初始化的*/
        var defaulfMedia = '.(!empty($msg) ? json_encode($msg) : '"dft"').';
        console.log("media",defaulfMedia);
        var dftMediaId = '.(!empty($msg['uid']) ? $msg['uid'] : 1).';
        /***welcome的数据************************************/
        var msg ='.(!empty($msg) ? json_encode($msg) : "null").';
    </script>';
?>

<?php
$extra_js = array(
    '/app/sp/static/js/smalltitle.js',
    '/app/sp/static/js/sigle.js',
    '/app/sp/static/js/data.js',
    '/app/sp/static/js/jquery.qqFace.js',
    '/static/js/wx_edit_html.js',
    '/static/js/wx_edit.js',
    '/app/default/static/js/default.js',
    '/app/welcome/static/js/welcome.js'
);
?>
