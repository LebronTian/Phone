
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
<link rel="stylesheet" type="text/css" href="/static/css/select_tpl.css">

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

</style>

<div class="am-cf am-padding">
    <div class="am-fl am-cf">
        <a href="?_a=form&_u=sp">
            <strong class="am-text-primary am-text-lg">通用表单</strong></a>
        <span class="am-icon-angle-right"></span>
        <strong class="am-text-default am-text-lg"><?php echo(!empty($form['uid']) ? '编辑表单' : '添加表单')?></strong> <small></small>
    </div>
</div>

<div class="am-form  data-am-validator ">

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            标题
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
                <img id="id_img" <?php if(!empty($form['img'])) echo 'src="'.$form['img'].'"';?> style="width:360px;height:190px;">
            </div>
        </div>
        <div class="am-u-sm-8 am-u-end">
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
            设置
        </div>

        <div class="am-u-sm-8 am-u-end">
            <label class="am-checkbox margin-bottom">
                <input type="checkbox" id="id_must_login" data-am-ucheck <?php if(!empty($form['access_rule']['must_login'])) echo 'checked';?>>
                是否必须登陆才能填写表单
            </label>

            <label class="am-checkbox margin-bottom">
                <input type="checkbox" id="id_can_edit" data-am-ucheck <?php if(!empty($form['access_rule']['can_edit'])) echo 'checked';?>>
                提交一次后是否还能修改
            </label>


            <label class="am-checkbox time-label">

                <input type="checkbox" data-am-ucheck <?php $start_time=!empty($form['access_rule']['start_time'])?$form['access_rule']['start_time']:'';
                if(!empty($start_time)) echo 'checked';?> name="cbx_start_time" >
                <input class="am-animation-slide-left" style="width: 14em ;<?php if(empty($start_time)) {echo 'display: none';$start_time=time(); }?>" type="datetime-local"
                       id="id_start_time" value="<?php echo date('Y-m-d',$start_time).'T'.date('h:i',$start_time)?>">

                允许提交的开始时间, 不选择代表不限制
            </label>

            <label class="am-checkbox time-label">
                <input type="checkbox" data-am-ucheck <?php $end_time=!empty($form['access_rule']['end_time'])?$form['access_rule']['end_time']:'';
                if(!empty($end_time)) echo 'checked';?> name="cbx_end_time">
                <input class="am-animation-slide-left" style="width: 14em;<?php if(empty($end_time)) {echo 'display: none';$end_time=time(); }?>" type="datetime-local"
                       id="id_end_time" value="<?php echo date('Y-m-d',$end_time).'T'.date('h:i',$end_time)?>">
                允许提交的截至时间，不选择代表不限制
            </label>

        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            表单收款
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="number" id="id_price" min="0" step="0.01" placeholder="请填写收款金额，单位元" <?php  if(!empty($form['access_rule']['order']['price'])) echo 'value="'.($form['access_rule']['order']['price']/100).'"';?>>
            <small>设置 0 为关闭该功能 ，设定1表示 用户在完成表单提交页面后会跳转到支付1元的界面。</small>
        </div>

    </div>

    <div class="am-g am-margin-top-sm" style="margin-top:20px;">
        <div class="am-u-sm-2 am-text-right">
            填写限制
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-form-group form-limit-box">
                <p style="margin-bottom: 8px"><span style="margin-right: 10px" class="am-icon-lightbulb-o am-warning am-icon-sm"></span>不选择就代表不限制</p>


                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name=""data-am-ucheck <?php if(!empty($form['access_rule']['total_cnt'])) echo 'checked';?> >
                    <input class="am-animation-slide-left" type="number" id="id_total_cnt"  <?php if(!empty($form['access_rule']['total_cnt'])) echo 'value="'.$form['access_rule']['total_cnt'].'"';else echo 'style="display: none"';?>/>
                    最多允许多少份表单
                </label>

                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name="" data-am-ucheck <?php if(!empty($form['access_rule']['max_cnt'])) echo 'checked';?> >
                    <input class="am-animation-slide-left" type="number" id="id_max_cnt" <?php if(!empty($form['access_rule']['max_cnt'])) echo 'value="'.$form['access_rule']['max_cnt'].'"';else echo 'style="display: none"';?>/>
                    每个用户最多允许提交多少份
                </label>

                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name="" data-am-ucheck <?php if(!empty($form['access_rule']['max_cnt_day'])) echo 'checked';?>>
                    <input class="am-animation-slide-left" type="number" id="id_max_cnt_day" <?php if(!empty($form['access_rule']['max_cnt_day'])) echo 'value="'.$form['access_rule']['max_cnt_day'].'"';else echo 'style="display: none"';?>/>
                    每个用户每天最多允许提交多少份
                </label>

            </div>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            表单模板
        </div>
        <div class="am-u-sm-8 am-u-end">
            <article class="tpl-container"></article>
        </div>
    </div>


    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            其他
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label class="am-checkbox margin-bottom">
                <input type="checkbox" name="" data-am-ucheck <?php if(!empty($form['access_rule']['max_cnt_day'])) echo 'checked';?>>
                <input class="am-animation-slide-left" type="number" id="id_max_cnt_day" <?php if(!empty($form['access_rule']['max_cnt_day'])) echo 'value="'.$form['access_rule']['max_cnt_day'].'"';else echo 'style="display: none"';?>/>
                每个用户每天最多允许提交多少份
            </label>
        </div>
    </div>

    <div class="am-g am-margin-top-sm" style="margin-top:20px;">
        <div class="am-u-sm-2 am-text-right">
            介绍
        </div>
        <!--文本编辑/-->

        <div class="am-u-sm-8 am-u-end">
            <script id="container" name="brief" type="text/plain" style="height:250px;"><?php if(!empty($form['brief'])) echo ''.$form['brief'].'';?></script>
        </div>
    </div>

    <div class="am-g " style="margin-top:30px;">
        <div class="am-u-sm-2 am-text-right">
            提交后动作 <!--<span class="am-icon-question-circle am-text-danger" data-am-popover="{content: '表单用于收集中奖用户信息', trigger: 'hover focus'}">-->
        </div>
        <div class="am-u-sm-4 am-u-end">
            <select id="id_win_rule_type">
                <option value="none"<?php if(empty($form['access_rule']['after_action']["type"])) echo 'selected'; ?>>无</option>
                <!--<option value="form"<?php /*if(!empty($form['access_rule']['after_action']["type"])&&$form['access_rule']['after_action']["type"]=='form') echo 'selected'; */?>>填写表单</option>-->
                <option value="url" <?php if(!empty($form['access_rule']['after_action']["type"])&&$form['access_rule']['after_action']["type"]=='url') echo 'selected'; ?>>跳转到链接</option>
            </select>
        </div>
    </div>

    <div class="am-g win_rule" style="margin-top:15px;">
        <div class="am-u-sm-2 am-text-right ">
            <span class="id_win_rule_name">选项名</span>
        </div>
        <div class="am-u-sm-4  win_rule_form ">
            <?php
            echo '<select class="text-chosen"  id="id_win_rule_form" multiple  style="width:80%;margin-top: 10px">';
            if(!empty($form['access_rule']['after_action']["data"]))
            {
                foreach($form['access_rule']['after_action']["data"] as $a)
                {
                    echo (!empty($a) ? '<option selected="selected">'.$a.'</option>' : '');
                }
            }
            echo '</select>';
            ?>
        </div>
        <div class="am-u-sm-6 am-u-end win_rule_url" >
            <input type="text" id="id_win_rule_url" value="<?php echo(!empty($form['access_rule']['after_action']["data"]) ? $form['access_rule']['after_action']["data"] : '') ?>">
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
    var tpl_data = <?php echo(!empty($tpls)? json_encode($tpls):"null")?>;
    var form =<?php echo(!empty($form)? json_encode($form):"null") ?>;
    console.log(form)
</script>

<?php

echo '<script>

        var g_uid = '.(!empty($form['uid']) ? $form['uid'] : 0).';
		var unique_field = '.(isset($form['access_rule']['unique_field']) ? $form['access_rule']['unique_field'] : -1).';
		 var tpl_url = "?_a='.$_REQUEST['_a'].'&_u=api.get_tpls" ;
            </script>';
$extra_js =  array(
    '/static/js/ueditor/ueditor.config.js',
    '/static/js/ueditor/ueditor.all.js',

    '/app/form/static/js/addform.js',
    '/static/js/select_tpl.js',
);

?>

<script>
    seajs.use(['selectPic'])
</script>
