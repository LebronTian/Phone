<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/static/css/select_tpl.css">
<style>
    .extra-box{
        margin-top: 1em;
    }
    #extra-input{
        display: inline-block;
    }
</style>

<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <strong class="am-text-primary am-text-lg">名片背景图</strong>
    </div>
</div>

<div class="am-form  data-am-validator ">

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>

        <div class="am-u-sm-9">
            <button class="imgBoxBtn am-btn am-btn-primary" data-addr="#id_card_img">从图片库选择</button>
            <div id="idImgBox">
                <img id="id_card_img" <?php if(!empty($card_img['url'])) echo 'src="'.$card_img['url'].'"';?> style="width:100px;height:100px;">
            </div>

            <p><span class="am-icon-info"></span> 图片像素需为：734*1305</a></p>
            <p><span class="am-icon-info"></span> 图片样式必须一致</a></p>
        </div>
        <div class="am-u-sm-8 am-u-end">
        </div>
    </div>


    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <p>
                <button class="am-btn am-btn-secondary" id="saveDocument">保存</button>

            </p>
        </div>
    </div>
</div>



<?php

    $extra_js = array(

        '/static/js/ueditor/ueditor.config.js',
        '/static/js/ueditor/ueditor.all.js',

        '/static/js/select_tpl.js',
        $static_path.'/js/card_img.js'
        );
?>
<script>
    seajs.use(['selectPic'])
</script>
