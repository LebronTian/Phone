
<head>
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
    <link rel="stylesheet" href="/static/css/select_user.css"/>
    <style type="text/css">

    </style>
</head>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">设置会员</strong> / <small></small></div>
</div>

<div class="am-form">

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            选择用户
        </div>
        <div class="am-u-sm-4 am-u-end">
            <div id="id_user" data-uid="<?php if(!empty($res['su_uid']))echo $res['su_uid'];?>">
                <?php
$img = '/static/images/null_avatar.png';
$name = '';
if(!empty($res['su_uid'])) {
$su = AccountMod::get_service_user_by_uid($res['su_uid']);
if($su['avatar'])$img = $su['avatar'];
$name = $su['name'] ? $su['name'] : $su['account'];
}
?>
                <img style="width:64px;height:64px;" src="<?php echo $img;?>"> <span><?php echo $name;?></span>
            </div>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            设置等级
        </div>
        <div class="am-u-sm-3 am-u-end">
            <div class="sel">
                <select class="sel-level">
                    <?php foreach($rank_rule as $k => $rr){

                        echo '<option value="'.$k.'">'.$rr['rank_name'].'</option>';

                     } ?>
                </select>
            </div>
        </div>
    </div>



    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-4 am-u-end">
            <p><button class="am-btn am-btn-lg am-btn-primary save">设置</button></p>
        </div>
    </div>

</div>



<?php
$extra_js =  array(
    '/static/js/ueditor/ueditor.config.js',
    '/static/js/ueditor/ueditor.all.js',
    '/static/js/select_user.js',
    $static_path.'/js/set_vip_su.js',


);
?>
<script>
    seajs.use(['selectPic'])
</script>

