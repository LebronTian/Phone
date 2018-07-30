
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
            问题标题
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input <?php if(!empty($_REQUEST['readonly'])) echo ' readonly ';?>type="text" id="id_title" placeholder="必填" value="<?php if(!empty($data['title'])) echo $data['title'] ?>" minlength="1" >
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            问题分类
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="id_type" placeholder="" value="<?php if(!empty($data['type'])) echo $data['type'] ?>" minlength="1" >
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            排序
        </div>
        <div class="am-u-sm-8 am-u-end" style="width: 120px">
            <input type="number" id="problem_sort" placeholder="选填" <?php if(!empty($data)) echo 'value="'.$data['sort'].'"'; ?>>
            <small style="white-space: nowrap">填正整数，从大到小排序</small>
        </div>
    </div>
  	<div class="am-g am-margin-top-sm">
  	    <div class="am-u-sm-2 am-text-right">
  	        问题内容
  	    </div>
  	    <div class="am-u-sm-8 am-u-end">
<textarea id="product-content"  name="content" type="text/plain" style="height:500px"><?php 
if(!empty($data['content'])) echo $data['content'] ?></textarea>
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

        '/static/js/ueditor/ueditor.config.js',
        '/static/js/ueditor/ueditor.all.js',

        $static_path.'/js/updateproblem.js'
        );
?>
