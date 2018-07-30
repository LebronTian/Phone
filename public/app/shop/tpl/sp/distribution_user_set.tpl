<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>
<link rel="stylesheet" href="/static/css/select_user.css"/>
<link rel="stylesheet" href="/app/shop/static/css/addproduct.css"/>
<style>
    .extra-box{
        margin-top: 1em;
    }
    #extra-input{
        display: inline-block;
    }
    #main-img {
         max-width: 200px;
    }
</style>
<div class="am-cf am-padding">
    <div class="am-fl am-cf" id="edit-id">
        <strong class="am-text-primary am-text-lg">添加设置分销成员</strong> /
    </div>
</div>
<div class="am-form am-form-horizontal" data-am-validator>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            选择用户
        </div>
        <div class="am-u-sm-4 am-u-end select-user-box">
            <select class="more-user" multiple="multiple">
            </select>
            <button style="margin-top: 0.5em" class="select-user am-btn am-btn-secondary am-btn-sm">选择用户</button>
        </div>
    </div>


    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            状态
        </div>
        <div class="am-u-sm-8 am-u-end" >
            <label class="am-radio am-radio-inline" style="padding-top: 0">
                <input type="radio" name="rad-status" value="1" checked>
                通过
            </label>
            <label class="am-radio am-radio-inline" style="padding-top: 0">
                <input type="radio" name="rad-status" value="2" data-am-ucheck>
				拒绝
            </label>
        </div>
    </div>

    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="am-btn am-btn-secondary" id="saveBiz">保存</button>
        </div>
    </div>
</div>

<!--虚拟弹窗-->
<div class="am-popup" id="user-popup">
    <div class="am-popup-inner">
        <div class="am-popup-hd">
            <h4 class="am-popup-title">用户列表</h4>
            <span data-am-modal-close class="am-close">&times;</span>
        </div>
        <div class="am-form">
            <input class="" type="text" placeholder="搜索">
        </div>
        <div style="padding-bottom: 3em" class="am-popup-bd">

        </div>
        <div class="user-list-foot">
            <span>取消</span><span>确定</span>
        </div>
    </div>
</div>

<?php
    $extra_js = array(
        '/static/js/ueditor/ueditor.config.js',
        '/static/js/ueditor/ueditor.all.js',
        '/static/js/select2/js/select2.min.js',

        $static_path.'/js/distribution_user_set.js',
        );
?>

