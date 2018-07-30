
<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>
<link rel="stylesheet" href="/app/shop/static/css/addproduct.css"/>

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
        <strong class="am-text-primary am-text-lg">编辑广播</strong>
    </div>
</div>
<div class="am-form am-form-horizontal" data-am-validator>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            广播标题
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input <?php if(!empty($_REQUEST['readonly'])) echo ' readonly ';?>type="text" id="document_title" placeholder="必填" value="<?php if(!empty($document['title'])) echo $document['title'] ?>" minlength="1" >
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            文案内容
        </div>
        <div class="am-u-sm-8 am-u-end">
<textarea id="product-content"  name="content" type="text/plain" style="height:500px"><?php
if(!empty($document['content'])) echo $document['content'] ?></textarea>
        </div>
    </div>

    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end" data-id="<?php if(!empty($document['uid'])) echo $document['uid'] ?>" id="documentUid">
            <button class="am-btn am-btn-secondary"  id="saveDocument">保存</button>
        </div>
    </div>
</div>


<?php

    $extra_js = array(

        '/static/js/ueditor/ueditor.config.js',
        '/static/js/ueditor/ueditor.all.js',

        $static_path.'/js/addradio.js'
        );
?>
