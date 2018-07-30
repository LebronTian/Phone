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
        <strong class="am-text-primary am-text-lg"> <?php echo(!empty($document) ? '编辑' : '添加')?>基础服务</strong></strong>
    </div>
</div>
<div class="am-form am-form-horizontal" data-am-validator>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            标题
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input <?php if(!empty($_REQUEST['readonly'])) echo ' readonly ';?>type="text" id="document_title" placeholder="必填" value="<?php if(!empty($document['title'])) echo $document['title'] ?>" minlength="1" >
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            内容
        </div>
        <div class="am-u-sm-8 am-u-end">
<textarea id="content"  style="height:300px"><?php
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
        $static_path.'/js/addbaseservice.js'
        );
?>
