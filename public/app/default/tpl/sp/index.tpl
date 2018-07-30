
<head>
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/sigle.css">
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/dabble.css">
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/qqface.css">
    <link rel="stylesheet" type="text/css" href="/static/css/wx_edit.css">
    <link rel="stylesheet" type="text/css" href="/app/default/static/css/default_yhc.css">
</head>
<div class="am-u-lg-8 am-u-md-12 am-u-sm-centered">

    <div class="am-cf am-padding">
        <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">默认回复</strong> / <small>未匹配任何插件时的默认处理方式</small></div>
    </div>
    <!-- 过渡取值 -->
    <input type="text" id="dom" value="" style="display:none;">

    <div class="am-tabs" data-am-tabs>
        <ul class="am-tabs-nav am-nav am-nav-tabs">
            <li><a href="#tab_nodo">无动作</a></li>
            <li class="am-active"><a href="#tab_msg">回复消息</a></li>
            <li><a href="#tab_keyword">触发关键词</a></li>
            <li><a href="#tab_proxy">代理模式</a></li>
            <li><a href="#tab_robot">机器人聊天</a></li>
        </ul>
        <div class="am-tabs-bd">
            <div class="am-tab-panel" id="tab_nodo" data-type="nodo">
                <button class="newBtn noneBtn am-btn am-btn-success" data-type="nodo">不进行任何操作</button>
                <p style="margin-top: 10px">
                    转为客服处理, 记录所有收发消息
                </p>
            </div>
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
            </div>
            <div class="am-tab-panel" id="tab_keyword" data-type="keyword">
                <div class="am-g am-margin-top-sm am-form">
                    <div class="am-u-sm-1 am-text-right">
                        关键字
                    </div>
                    <div class="am-u-sm-9 am-u-end">
                        <input type="text" id="id_keyword" <?php if(!empty($dft['keyword']['key'])) echo 'value="'.$dft['keyword']['key'].'"';?>>
                    </div>
                </div>
            </div>
            <div class="am-tab-panel" id="tab_proxy" data-type="proxy">
                <div class="am-form">
                    <div class="am-g am-margin-top-sm">
                        <div class="am-u-sm-2 am-text-right">
                            服务器URL地址
                        </div>
                        <div class="am-u-sm-8 am-u-end">
                            <input type="text" id="id_url" <?php if(!empty($dft['proxy']['url'])) echo 'value="'.$dft['proxy']['url'].'"';?>>
                        </div>
                    </div>

                    <div class="am-g am-margin-top-sm">
                        <div class="am-u-sm-2 am-text-right">
                            token
                        </div>
                        <div class="am-u-sm-8 am-u-end">
                            <input type="text" id="id_token" <?php if(!empty($dft['proxy']['token'])) echo 'value="'.$dft['proxy']['token'].'"';?>>
                        </div>
                    </div>

                    <div class="am-g am-margin-top-sm">
                        <div class="am-u-sm-2 am-text-right">
                            消息加解密方式
                        </div>
                        <div class="am-u-sm-8 am-u-end">
                            <label class="am-radio" value="1"><input type="radio" name="radio1">明文模式</label>
                            <label class="am-radio" value="3"><input type="radio" name="radio1" >加密模式</label>
                        </div>
                    </div>

                    <div class="am-g am-margin-top-sm">
                        <div class="am-u-sm-2 am-text-right">
                            EncodingAESKey
                        </div>
                        <div class="am-u-sm-8 am-u-end">
                            <input type="text" id="id_aes" <?php if(!empty($dft['proxy']['aes_key'])) echo 'value="'.$dft['proxy']['aes_key'].'"';?>>
                        </div>
                    </div>

                </div>
            </div>
            <div class="am-tab-panel" id="tab_robot" data-type="robot">
                <button class="newBtn robotBtn am-btn am-btn-success" data-type="robot">机器人聊天</button>
                <p style="margin-top: 10px">
                    转为智能助手进行回复
                </p>
            </div>
        </div>
    </div>

    <p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>

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

<script>
    var defaulfMedia = <?php echo(!empty($dft['msg'])? json_encode($dft['msg']):"{media_type:null}")?>;
//    console.log(defaulfMedia);
</script>

<?php
echo '<script>
        var g_msg_mode = '.(!empty($dft['proxy']['msg_mode']) ? $dft['proxy']['msg_mode'] : 1).';
		var g_type = "'.(!empty($dft['type']) ? $dft['type'] : 'msg').'";
        var dftMediaId = '.(!empty($dft['msg']['uid']) ? $dft['msg']['uid'] : 0).';

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
    $static_path.'/js/default.js'

);
?>





