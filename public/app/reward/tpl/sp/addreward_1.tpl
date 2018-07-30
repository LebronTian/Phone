<link rel="stylesheet" type="text/css" href="/static/css/amazeui.datetimepicker.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
<link rel="stylesheet" type="text/css" href="/app/reward/static/css/new-reward.css">
<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>

<div class="am-cf am-padding">
    <div class="am-fl am-cf">
	<a href="?_a=reward&_u=sp">
	<strong class="am-text-primary am-text-lg">通用抽奖</strong></a>
	<span class="am-icon-angle-right"></span>
	<strong class="am-text-default am-text-lg"><?php echo(!empty($reward['uid']) ? '编辑抽奖' : '添加抽奖')?></strong> <small></small></div>
</div>
<div class="am-padding" style="padding-top:0;">
  <ul class="step-status-bars">
    <?php 
        if(!empty($reward)){
            echo '<li class="active"><a href="?_a=reward&_u=sp.addreward_1&uid='.$reward['uid'].'">基本设置</a></li><li class=""><a href="?_a=reward&_u=sp.addreward_3&r_uid='.$reward['uid'].'">奖项/概率设置</a></li><li class=""><a href="?_a=reward&_u=sp.addreward_5&uid='.$reward['uid'].'">其他设置</a></li>';
            
        }else{
            echo '<li class="active"><a href="?_a=reward&_u=sp.addreward_1">基本设置</a></li>
                  <li class="disabled">奖项/概率设置</li>
                  <li class="disabled">其他设置</li>';
        }
    ?>
  </ul>
</div>
<div class="am-form  data-am-validator ">
    
    <div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
      <div class="am-modal-dialog">
        <div class="am-modal-hd"></div>
        <div class="am-modal-bd">
          你，确定要删除这张图片吗？
        </div>
        <div class="am-modal-footer">
          <span class="am-modal-btn" data-am-modal-cancel>取消</span>
          <span class="am-modal-btn" data-am-modal-confirm>确定</span>
        </div>
      </div>
    </div>

    <!-- 新抽奖流程 -->
    <div class="am-u-sm-12" style="background-color:#F5F5F5;padding:20px;width:90%;">
        <div class="am-u-sm-2">
            <!-- <img src="/app/reward/static/images/reward.jpg"> -->
            &nbsp;
        </div>

        <input type="hidden" id="max_item" value="<?php echo (!empty($reward['access_rule']['max_item']) ? $reward['access_rule']['max_item'] : '' ) ?>">
        <input type="hidden" id="max_cnt" value="<?php echo (!empty($reward['access_rule']['max_cnt']) ? $reward['access_rule']['max_cnt'] : '' ) ?>">
        <input type="hidden" id="max_cnt_day" value="<?php echo (!empty($reward['access_rule']['max_cnt_day']) ? $reward['access_rule']['max_cnt_day'] : '' ) ?>">
        <input type="hidden" value="" id="status-id">
        <input type="hidden" value="" id="must-login-id">

        <div class="am-u-sm-10" style="border-left: 1px solid #CCC;">
            <p>活动名称<span class="must-input">*</span>不能超过64个字</p>
            <input type="text" value="<?php echo (!empty($reward['title']) ? $reward['title'] : '') ?>" class="am-form-field activity-title">

            <button class="imgBoxBtn" style="border: 1px solid #CCC;width: 130px;height: 32px;background-color: #0E90D2;color: #FFF;font-size: 14px;">从图片库选择</button>
            <span>作为分享朋友圈/分享给朋友的标题图片使用</span>
            <div id="idImgBox">
                <img id="id_img" src="<?php echo (!empty($reward['img']) ? $reward['img'] : '') ?>" style="width:100px;height:100px;">
            </div>
            
            <br/>
            
            <div class="start-end-time">从
                <input type="text" class="am-form-field form-datetime start-time" style="display:inline;width:30%;margin:0 5px;" placeholder="开始时间" value="<?php echo (!empty($reward['access_rule']['start_time']) ? date('Y-m-d H:i',$reward['access_rule']['start_time']) : '' ) ?>"/>
            到
                <input type="text" class="am-form-field form-datetime end-time" style="display:inline;width:30%;margin:0 5px;" placeholder="结束时间" value="<?php echo (!empty($reward['access_rule']['end_time']) ? date('Y-m-d H:i',$reward['access_rule']['end_time']) : '' ) ?>"/>
            <!-- （活动将会在启动前10分钟进行预热） -->
                <span>
                    （<span class="must-input">*</span>活动时间必填）
                </span>
            </div>
            

            <script id="container" name="brief" type="text/plain" style="height:250px;"><?php echo (!empty($reward['brief']) ? $reward['brief'] : '') ?></script>
            <div>
                <span class="must-input">*</span>请在文本框中填写活动介绍
            </div>

            <div class="am-g am-margin-top-sm">
                <!-- <div class="am-u-sm-3 am-text-right">
                    店铺模板
                </div> -->
                <div class="am-u-sm-12 am-u-end">
                    <div class="tpl-container" data-url="<?php echo '?_a='.$_REQUEST['_a'].'&_u=api.get_tpls' ?>" data-selected="<?php echo(!empty($reward['tpl'])? $reward['tpl']:"") ?>"></div>
                </div>
            </div>

            <div class="reward-step-1">
                <input type="hidden" value="<?php echo (!empty($reward['uid']) ? $reward['uid'] : '') ?>">
                <button type="button" class="am-btn am-btn-primary" id="reward-step-one">下一步，奖项/概率设置</button>
            </div>

        </div>
        <div class="am-u-sm-2"></div>

    </div>

</div>
<script type="text/javascript">
    var items = <?php echo (!empty($item) ? json_encode($item) : 'null') ?>;
    var rewards = <?php echo (!empty($reward) ? json_encode($reward) : 'null') ?>;
    $(function () {
        seajs.use(['selectTpl','selectPic']);
    })
</script>

<?php
	echo '<script>
        var g_uid = '.(!empty($reward['uid']) ? $reward['uid'] : 0).';
            </script>';
        $extra_js =  array(

		    '/static/js/select2/js/select2.min.js',
            '/static/js/ueditor/ueditor.config.js',
            '/static/js/ueditor/ueditor.all.js',
          '/app/reward/static/js/addreward.js',
          '/static/js/amazeui.datetimepicker.min.js',
          '/static/js/amazeui.datetimepicker.zh-CN.js',
          '/app/reward/static/js/new-addreward.js',
          '/app/reward/static/js/select-o.js'

    );

?>




