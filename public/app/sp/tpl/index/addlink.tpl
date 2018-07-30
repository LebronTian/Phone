
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
        <strong class="am-text-primary am-text-lg">编辑问题</strong>
    </div>
</div>
<div class="am-form am-form-horizontal" data-am-validator>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            标题
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="id_title" placeholder="必填" value="<?php if(!empty($data['title'])) echo $data['title'] ?>" minlength="1" >
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            链接
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="id_link" placeholder="" value="<?php if(!empty($data['link'])) echo $data['link'] ?>" minlength="1" >
        </div>
    </div>



    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end" data-id="<?php if(!empty($data['uid'])) echo $data['uid'] ?>" id="dataUid">
            <button class="am-btn am-btn-secondary"  id="saveData">保存</button>
        </div>
    </div>
</div>


<?php

    $extra_js = array(
        $static_path.'/js/addlink.js'
        );
?>
