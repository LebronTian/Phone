<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
<link rel="stylesheet" type="text/css" href="/app/reward/static/css/new-reward.css">
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
            echo '<li class=""><a href="?_a=reward&_u=sp.addreward_1&uid='.$reward['uid'].'">基本设置</a></li><li class=""><a href="?_a=reward&_u=sp.addreward_3&r_uid='.$reward['uid'].'">奖项/概率设置</a></li><li class="active"><a href="?_a=reward&_u=sp.addreward_5&uid='.$reward['uid'].'">其他设置</a></li>';
        }else{
            echo '<li class=""><a href="?_a=reward&_u=sp.addreward_1">基本设置</a></li>
                  <li class=""><a href="?_a=reward&_u=sp.addreward_3">奖项/概率设置</a></li>
                  <li class=""><a href="?_a=reward&_u=sp.addreward_5">其他设置</a></li>';
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
    

    <!-- 其他设置 start -->
    <div style="clear:both;"></div>
    <div class="am-u-sm-12" style="background-color:#F5F5F5;padding:20px;margin-top:20px;width:90%;">
        <div class="am-u-sm-3">
            <h1>其他设置</h1>
        </div>
        <div class="am-u-sm-8" style="border-left: 1px solid #CCC;">
            <!-- <div class="am-u-sm-12 other-setting">
                <div class="am-u-sm-4 left">
                    是否显示奖品数量
                </div>
                <div class="am-u-sm-8">
                    <label class="am-checkbox" style="display:inline;">
                      <input type="checkbox" value="" checked="checked" data-am-ucheck>
                      <span class="must-input">*</span>取消选择后在活动页面中将不会显示奖品数量
                    </label>
                    
                </div>
            </div> -->

            <!-- <div class="am-g am-margin-top-sm">
                <div class="am-u-sm-2 am-text-right">
                    状态
                </div>
                <div class="am-u-sm-8 am-u-end">
                    <label class="am-checkbox">
                        <input type="checkbox" id="id_status" data-am-ucheck="" checked="" class="am-ucheck-checkbox"><span class="am-ucheck-icons"><i class="am-icon-unchecked"></i><i class="am-icon-checked"></i></span><span class="am-ucheck-icons"><i class="am-icon-unchecked"></i><i class="am-icon-checked"></i></span>
                        是否开启</label>
                </div>
            </div> -->
            <div style="display:none;" class="start-end-time">从
                <input type="text" class="am-form-field start-time" data-time="<?php echo (!empty($reward['access_rule']['start_time']) ? $reward['access_rule']['start_time'] : '' ) ?>" style="display:inline;width:25%;margin:0 5px;" placeholder="开始时间" data-am-datepicker="{theme: 'success'}" value="<?php echo (!empty($reward['access_rule']['start_time']) ? date('Y-m-d',$reward['access_rule']['start_time']) : '' ) ?>" readonly/>
            到
                <input type="text" class="am-form-field end-time" data-time="<?php echo (!empty($reward['access_rule']['end_time']) ? $reward['access_rule']['end_time'] : '' ) ?>" style="display:inline;width:25%;margin:0 5px;" placeholder="结束时间" data-am-datepicker="{theme: 'success'}" value="<?php echo (!empty($reward['access_rule']['end_time']) ? date('Y-m-d',$reward['access_rule']['end_time']) : '' ) ?>" readonly/>
            <!-- <input type="text" class="am-form-field" placeholder="日历组件" data-am-datepicker readonly required /> -->
            （活动将会在启动前10分钟进行预热）
            </div>
            <input type="hidden" id="reward-tpl-id" value="<?php echo (!empty($reward['tpl']) ? $reward['tpl'] : '' ) ?>">
            
            
            <div class="am-u-sm-12 other-setting">
                <div class="am-u-sm-4 left">
                    每个用户每天可参与次数
                </div>
                <div class="am-u-sm-8">
                    <div class="am-u-sm-4" style="padding:0;"><input type="number" value="<?php echo (!empty($reward['access_rule']['max_cnt_day']) ? $reward['access_rule']['max_cnt_day'] : '' ) ?>"></div>
                    <div class="am-u-sm-8"></div>
                    <span style="margin-left: 10px; color: #999;">不填则默认为不限制</span>
                </div>
            </div>

            <div class="am-u-sm-12 other-setting">
                <div class="am-u-sm-4 left">
                    每个用户可参与次数
                </div>
                <div class="am-u-sm-8">
                    <div class="am-u-sm-4" style="padding:0;"><input type="number" value="<?php echo (!empty($reward['access_rule']['max_cnt']) ? $reward['access_rule']['max_cnt'] : '' ) ?>"></div>
                    <div class="am-u-sm-8"></div>
                    <span style="margin-left: 10px; color: #999;">不填则默认为不限制</span>
                </div>
            </div>

            <div class="am-u-sm-12 other-setting">
                <div class="am-u-sm-4 left">
                    最多允许中奖次数
                </div>
                <div class="am-u-sm-8">
                    <div class="am-u-sm-4" style="padding:0;"><input type="number" value="<?php echo (!empty($reward['access_rule']['max_item']) ? $reward['access_rule']['max_item'] : '' ) ?>"></div>
                    <div class="am-u-sm-8"></div>
                    <span style="margin-left: 10px; color: #999;">不填则默认为不限制</span>
                </div>
            </div>

            <div class="am-g am-margin-top-sm">
                <div class="am-u-sm-4 am-text-right">
                    状态
                </div>
                <div class="am-u-sm-4 am-u-end">
                    <label class="am-checkbox">
                    <input type="checkbox" id="id_status" data-am-ucheck <?php  if(empty($reward['status'])) echo 'checked';?>>
                    是否开启</label>
                </div>
            </div>
            <div class="am-g am-margin-top-sm">
                <div class="am-u-sm-4 am-text-right">
                    设置
                </div>
                <div class="am-u-sm-6 am-u-end">
                   <label class="am-checkbox spc-checkbox">
                        <input type="checkbox" id="id_must_login" data-am-ucheck <?php if(!empty($reward['access_rule']['must_login'])) echo 'checked';?>>
                        是否必须登录才能进行抽奖
                    </label>
                </div>
            </div>

            <div class="am-u-sm-12 other-setting">
                <div class="am-u-sm-4 am-text-right">
                    分享标题
                </div>
                <div class="am-u-sm-6 am-u-end">
                   <input type="text" id="id-share-title" 
                        value="<?php echo (!empty($reward['win_rule']['title']) ? $reward['win_rule']['title'] : '') ?>" placeholder="选填">
                </div>
            </div>
            
            <div class="am-u-sm-12 other-setting">
                <div class="am-u-sm-4 am-text-right">
                    商家信息
                </div>
                <div class="am-u-sm-6 am-u-end">
                   <input type="text" id="id-business-info" 
                        value="<?php echo (!empty($reward['win_rule']['info']) ? $reward['win_rule']['info'] : '') ?>" placeholder="选填">
                </div>
            </div>

            <div class="am-u-sm-12 other-setting">
                <div class="am-u-sm-4 am-text-right">
                    中奖后动作 <span class="am-icon-question-circle am-text-danger" data-am-popover="{content: '表单用于收集中奖用户信息', trigger: 'hover focus'}">
                </div>
                <div class="am-u-sm-4 am-u-end">
                    <select id="id_win_rule_type">
                    <option value="none"<?php if(empty($reward['win_rule']["type"])) echo 'selected'; ?>>无</option>
                    <option value="form"<?php if(!empty($reward['win_rule']["type"])&&$reward['win_rule']["type"]=='form') echo 'selected'; ?>>填写表单</option>
                    <option value="url" <?php if(!empty($reward['win_rule']["type"])&&$reward['win_rule']["type"]=='url') echo 'selected'; ?>>跳转到链接</option>
                    </select>
                    
                </div>

            </div>

            <div class="am-u-sm-12 other-setting win_rule">
                <div class="am-u-sm-4 am-text-right ">
                    <span class="id_win_rule_name">选项名</span>
                </div>
                <div class="am-u-sm-8  win_rule_form ">
                <?php
                    echo '<select class="text-chosen"  id="id_win_rule_form" multiple  style="width:80%;margin-top: 10px">';
                    if(!empty($reward['win_rule']["data"]))
                    {   
                        foreach($reward['win_rule']["data"] as $a)
                        {
                        echo (!empty($a) ? '<option selected="selected">'.$a.'</option>' : '');
                        }
                    }
                        echo '</select>';
                ?>
                </div>
                <div class="am-u-sm-6 am-u-end win_rule_url" >
                    <input type="text" id="id_win_rule_url" value="<?php echo(!empty($reward['win_rule']["data"]) ? $reward['win_rule']["data"] : '') ?>">
                </div>
            </div>
            

            <!-- <div class="am-u-sm-12 other-setting">
                <div class="am-u-sm-4 left">
                    商家兑奖密码
                </div>
                <div class="am-u-sm-8">
                   <input type="text" value="">
                   在中奖手机上输入此码可直接使用SN码，不能超过20个字。
                </div>
            </div> -->
            <p style="padding-left:215px;"><button type="button" class="am-btn am-btn-primary" id="reward-save-btn">保存</button></p>
        </div>
        <div class="am-u-sm-1"></div>
    </div>
    <div style="clear:both;"></div>
    
    <!-- 其他设置 end -->
	
	
	<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>

	 


</div>
<script type="text/javascript">
    var rewards = <?php echo (!empty($reward) ? json_encode($reward) : 'null') ?>;
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
          '/static/js/select_tpl.js',
          '/static/js/amazeui.datetimepicker.min.js',
          '/app/reward/static/js/new-addreward.js'
    );

?>

