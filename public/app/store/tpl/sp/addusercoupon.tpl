
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>
<style type="text/css">

    .am-form input[type=search]{
        padding: 0.3em;
        display: none;
    }

    .user-p{
        cursor: pointer;
        color: #ffffff;
        padding: 0.5em;
        width: 50%;
        display: inline-block;
        margin: 0.5em 0;
    }
    .active-p{
        background: #5eb95e;!important;
        border: 2px solid crimson;
    }
    .user-p:nth-child(odd){
        background: #0e90d2;
    }
    .user-p:nth-child(even){
        background: #3bb4f2;
    }


    .user-list-foot{
        border-top: 1px solid #dedede;
        width: 100%;
        background: #ffffff;
        position: absolute;
        left: 0;
        bottom: 0;
        height: 3em;
        line-height: 3em;
        color: #0e90d2;
    }
    .user-list-foot span{
        width: 50%;
        display: inline-block;
        text-align: center;
        cursor: pointer;
    }
    .user-list-foot span:first-child{
        border-right: 1px solid #dedede;
    }
    .user-head{
        width: 2em;
        height: 2em;
        background: url(/static/images/null_avatar.png);
        background-size: 100% auto;
        border-radius: 50%;
        margin: 0 0.3em;
    }
</style>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">发放优惠劵</strong> / <small></small></div>
</div>

<div class="am-form">
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            选择优惠劵
        </div>
        <div class="am-u-sm-8 am-u-end">
            <select data-am-selected="{btnWidth: 150, btnSize: 'lg' }" class="option_duration">
                <?php
                if($coupons['list']) {
                    $html = '';
                    foreach($coupons['list'] as $p) {
                        $html .= '<option value="'.$p['uid'].'"';
                        if($coupon_uid == $p['uid']) $html .= ' selected';
                        $html .= '>'.$p['title'].'</option>';
                    }
                }
                else {
                    $html = '<a  href="?_a=store&_u=sp.addstorecoupon" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 创建优惠劵</a>';

                }
                echo $html;
                ?>
            </select>
        </div>
    </div>

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

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            发放张数
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="id_send_cnt" value="1">
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-4 am-u-end">
            <p><button class="am-btn am-btn-lg am-btn-primary save">发放</button></p>
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
$extra_js =  array(
    '/static/js/ueditor/ueditor.config.js',
    '/static/js/ueditor/ueditor.all.js',
    '/static/js/tip.js',
    '/static/js/select2/js/select2.min.js',
    $static_path.'/js/addusercoupon.js'

);
?>


