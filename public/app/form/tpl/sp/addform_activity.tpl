<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
<link rel="stylesheet" type="text/css" href="/static/css/select_tpl.css">
<link rel="stylesheet" href="/static/css/select_user.css"/>

<style type="text/css">

    .am-checkbox{
        margin-top: 3px;
    }
    .time-label{
        height: 46px;
        line-height: 41px;
    }
    .time-label .am-ucheck-icons{
        top: 10px;
    }
    .time-label input[type='datetime-local']{
        display: inline-block;
    }
    .form-limit-box .am-ucheck-icons{
        top:10px;
    }
    .form-limit-box label{
        height: 46px;
        line-height: 41px;
    }
    .form-limit-box input[type='number']{
        display: inline-block;
        width: 8em;
        text-align: center;
    }

    .select2-search__field{
        padding:2px!important
    }

    .am-checkbox {
        padding-bottom:15px!important
    }

	.extra-box input {
		display:inline-block !important;
	}
    .sku-btn-up{
        background: white;
        border: 0;
        width: 100%;
    }
    .disable-btn{
        opacity: 0.5;
    }
    .type-add-li {
        width: 64px;
        border: dashed 2px #626262;
        text-align: center;
        opacity: 0.6;
        padding: 0.4em;
        cursor: pointer;
        margin-top: 0.5em;
    }
    .type-red-li {
        width: 64px;
        border: dashed 2px #626262;
        text-align: center;
        opacity: 0.6;
        padding: 0.4em;
        cursor: pointer;
        margin-top: 0.5em;
    }
    .class_user{
        padding-top: 5px;
    }
    #user-popup {
        border-radius: 10px;
        border:1px solid #8a8a8a;
    }

</style>

<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <a href="?_a=form&_u=sp">
            <strong class="am-text-primary am-text-lg">活动</strong></a>
        <span class="am-icon-angle-right"></span>
        <strong class="am-text-default am-text-lg"><?php echo(!empty($form['uid']) ? '编辑' : '添加')?> 活动</strong> <small></small>
    </div>
</div>

<div class="am-form  data-am-validator ">

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            活动名称
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="id_title" placeholder="必填" <?php if(!empty($form['title'])) echo 'value="'.$form['title'].'"';?>>
        </div>
    </div>


    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            封面图片
        </div>

        <div class="am-u-sm-9">
            <button class="imgBoxBtn am-btn am-btn-primary" data-addr="#id_img">从图片库选择</button>
            <div id="idImgBox">
                <img id="id_img" <?php if(!empty($form['img'])) echo 'src="'.$form['img'].'"';?> style="width:100px;height:100px;">
            </div>
        </div>
        <div class="am-u-sm-8 am-u-end">
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            设置
        </div>

        <div class="am-u-sm-8 am-u-end">

            <label class="am-checkbox time-label">

                <?php $astart_time=!empty($form['access_rule']['astart_time'])?$form['access_rule']['astart_time']:'';?>
                <input class="am-animation-slide-left" style="width: 16em ;<?php if(empty($astart_time)){$astart_time=time(); }?>" type="datetime-local"
                       id="id_astart_time" value="<?php echo date('Y-m-d',$astart_time).'T'.date('h:i',$astart_time)?>">

                活动时间

            </label>

            <label class="am-checkbox time-label">

                <input type="checkbox" data-am-ucheck <?php $start_time=!empty($form['access_rule']['start_time'])?$form['access_rule']['start_time']:'';
                if(!empty($start_time)) echo 'checked';?> name="cbx_start_time" >
                <input class="am-animation-slide-left" style="width: 16em ;<?php if(empty($start_time)) {echo 'display: none';$start_time=time(); }?>" type="datetime-local"
                       id="id_start_time" value="<?php echo date('Y-m-d',$start_time).'T'.date('h:i',$start_time)?>">

                允许提交的开始时间, 不选择代表不限制
            </label>

            <label class="am-checkbox time-label">
                <input type="checkbox" data-am-ucheck <?php $end_time=!empty($form['access_rule']['end_time'])?$form['access_rule']['end_time']:'';
                if(!empty($end_time)) echo 'checked';?> name="cbx_end_time">
                <input class="am-animation-slide-left" style="width: 16em;<?php if(empty($end_time)) {echo 'display: none';$end_time=time(); }?>" type="datetime-local"
                       id="id_end_time" value="<?php echo date('Y-m-d',$end_time).'T'.date('h:i',$end_time)?>">
                允许提交的截至时间，不选择代表不限制
            </label>

        </div>
    </div>

    <div class="am-g am-margin-top-sm" style="margin-top:20px;">
        <div class="am-u-sm-2 am-text-right">
            数目限制
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-form-group form-limit-box">
                <p style="margin-bottom: 8px"><span style="margin-right: 10px" class="am-icon-lightbulb-o am-warning am-icon-sm"></span>不选择就代表不限制</p>


                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name=""data-am-ucheck <?php if(!empty($form['access_rule']['total_cnt'])) echo 'checked';?> >
                    <input class="am-animation-slide-left" type="number" id="id_total_cnt"  <?php if(!empty($form['access_rule']['total_cnt'])) echo 'value="'.$form['access_rule']['total_cnt'].'"';else echo 'style="display: none"';?>/>
                    总名额
                </label>

                <label class="am-checkbox margin-bottom" style="display:none;">
                    <input type="checkbox" name="" data-am-ucheck checked>
                    <input class="am-animation-slide-left" type="number" id="id_max_cnt" value="1"/>
                    每个用户最多允许提交多少份
                </label>

                <label class="am-checkbox margin-bottom" style="display:none;">
                    <input type="checkbox" name="" data-am-ucheck <?php if(!empty($form['access_rule']['max_cnt_day'])) echo 'checked';?>>
                    <input class="am-animation-slide-left" type="number" id="id_max_cnt_day" <?php if(!empty($form['access_rule']['max_cnt_day'])) echo 'value="'.$form['access_rule']['max_cnt_day'].'"';else echo 'style="display: none"';?>/>
                    每个用户每天最多允许提交多少份
                </label>

            </div>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            状态
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label class="am-checkbox">
                <input type="checkbox" id="id_status" data-am-ucheck <?php  if(empty($form['status'])) echo 'checked';?>>
                是否开启</label>
        </div>
    </div>


    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            活动费用
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="number" id="id_price" min="0" step="0.01" placeholder="请填写收款金额，单位元" <?php  if(!empty($form['access_rule']['order']['price'])) echo 'value="'.($form['access_rule']['order']['price']/100).'"';?>>
            <small>设置 0 为关闭该功能 ，设定1表示 用户在报名前要支付1元</small>
        </div>

    </div>



    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            发布用户
        </div>
        <div class="am-u-sm-8 am-u-end extra-content">
            <div id="id_user" data-uid="<?php if(!empty($form['su_uid']))echo $form['su_uid'];?>">
                <?php
    $img = '/static/images/null_avatar.png';
    $name = '';
    if(!empty($form['su_uid'])) {
    $su = AccountMod::get_service_user_by_uid($form['su_uid']);
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
            管理员
        </div>
        <div class="am-u-sm-8 am-u-end extra-content userlist">
            <?php
            if(!empty($form['admin_uids'])){
            foreach($form['admin_uids'] as $su_uid){ ?>
            <div class="class_user" data-uid="<?php if(!empty($su_uid))echo $su_uid;?>">
                <?php
    $avatar = '/static/images/null_avatar.png';
    $name = '';
    if(!empty($su_uid)) {
    $su = AccountMod::get_service_user_by_uid($su_uid);
    if($su['avatar']) $avatar = $su['avatar'];
    $name = $su['name'] ? $su['name'] : $su['account'];
    }
    ?>
                <img style="width:64px;height:64px;" src="<?php echo $avatar;?>"> <span><?php echo $name;?></span>
            </div>
            <?php }
             }?>
            <div class="type-add-li"><span class="am-icon-plus"></span></div>
            <div class="type-red-li"><span class="am-icon-minus"></span></div>
        </div>

    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            活动站点
        </div>
        <div class="am-u-sm-6 am-u-end extra-content">
            <input type="text" id="address" placeholder="" <?php  if(!empty($form['access_rule']['address'])) echo 'value="'.($form['access_rule']['address']).'"';?>>
        </div>
    </div>


    <div class="am-g am-margin-top-sm" style="margin-top:20px;">
        <div class="am-u-sm-2 am-text-right">
            活动详情
        </div>
        <!--文本编辑/-->

        <div class="am-u-sm-8 am-u-end">
            <script id="brief" name="brief" type="text/plain" style="height:250px;"><?php if(!empty($form['brief'])) echo ''.$form['brief'].'';?></script>
        </div>
    </div>




    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <p>
                <button class="am-btn am-btn-lg am-btn-primary save">保存</button>
                <button style="margin-left: 0.5em" onclick="history.back()" class="am-btn am-btn-lg am-btn-primary">取消</button>
            </p>
        </div>
    </div>

</div>



<script>

    var data =<?php echo(!empty($form)? json_encode($form):"null") ?>;

</script>

<?php

echo '<script>

        var g_uid = '.(!empty($form['uid']) ? $form['uid'] : 0).';


            </script>';
$extra_js =  array(
    '/static/js/ueditor/ueditor.config.js',
    '/static/js/ueditor/ueditor.all.js',

    '/static/js/select2/js/select2.min.js',

    '/static/js/select_tpl.js',
    '/static/js/select_user.js',
    '/app/form/static/js/addform_activity.js',
);

?>

<script>
    seajs.use(['selectPic'])
</script>
