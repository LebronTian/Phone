<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
<link rel="stylesheet" type="text/css" href="/app/reward/static/css/new-reward.css">

<style type="text/css">
    body{
        font-size: 14px;
    }
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
    .reward-limit-box .am-ucheck-icons{
        top:10px;
    }
    .reward-limit-box label{
        height: 46px;
        line-height: 41px;
    }
    .reward-limit-box input[type='number']{
        display: inline-block;
        width: 8em;
        text-align: center;
    }

    .select2-search__field{
        padding:2px!important
    }
    .addreward_bar p{
        margin-bottom: 0;
    }
    .reward_setting,
    .probability_setting{
        margin-bottom: 10px;
    }
    .reward_setting p,
    .probability_setting p{
        margin:0;
        text-align: center;
    }
    .other_setting{
        padding:0;
        line-height:41px;
        margin-bottom:10px;
    }
    .other_setting .left{
        text-align: right;
    }
 /*   .del-checkbox{
        position:absolute;
        top:100px;

    }*/

</style>

<div class="am-cf am-padding">
    <div class="am-fl am-cf">
	<a href="?_a=reward&_u=sp">
	<strong class="am-text-primary am-text-lg">通用抽奖</strong></a>
	<span class="am-icon-angle-right"></span>
	<strong class="am-text-default am-text-lg"><?php echo(!empty($reward['uid']) ? '编辑抽奖' : '添加抽奖')?></strong> <small></small></div>
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

    

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            标题
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="id_title" placeholder="必填" <?php if(!empty($reward['title'])) echo 'value="'.$reward['title'].'"';?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            封面图片
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="imgBoxBtn am-btn am-btn-secondary buttonImg1" data-addr="#main-img-src" data-func="mainImg" style="border: 1px solid #CCC;width: 130px;height: 32px;background-color: #0E90D2;color: #FFF;font-size: 14px;">从图片库选择</button>
            <input id="main-img-src" type="hidden" <?php if(!empty($product)) echo'src="'.$product['main_img'].'"'; ?>/>
            <div id="main-img-box" style="margin: 10px 0">
                <img id="id_img" <?php if(!empty($reward['img'])) echo 'src="'.$reward['img'].'"';?> style="width:100px;height:100px;">
            </div>
            建议图片尺寸 750*750
        </div>
    </div>

    
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            创建时间
        </div>
        <div class="am-u-sm-8 am-u-end">
            <p>
                <span class="am-form-field" readonly>
                    <?php if(!empty($reward['create_time'])) echo date('Y-m-d H:i:s', $reward['create_time']); ?>
                </span>
            </p>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            状态
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label class="am-checkbox">
                <input type="checkbox" id="id_status" data-am-ucheck <?php  if(empty($reward['status'])) echo 'checked';?>>
                是否开启</label>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            设置
        </div>
        <div class="am-u-sm-8 am-u-end">
           
            <label class="am-checkbox time-label">
			
                <input type="checkbox" data-am-ucheck <?php $start_time=!empty($reward['access_rule']['start_time'])?$reward['access_rule']['start_time']:'';
				if(!empty($start_time)) echo 'checked';?> name="cbx_start_time" >
                <input class="am-animation-slide-left" style="width: 14em ;<?php if(empty($start_time)) {echo 'display: none';$start_time=time(); }?>" type="datetime-local"
				id="id_start_time" value="<?php echo date('Y-m-d',$start_time).'T'.date('h:i',$start_time)?>">
				
                抽奖开始时间, 不选择代表不限制
            </label>

            <label class="am-checkbox time-label">
                <input type="checkbox" data-am-ucheck <?php $end_time=!empty($reward['access_rule']['end_time'])?$reward['access_rule']['end_time']:'';
				if(!empty($end_time)) echo 'checked';?> name="cbx_end_time">
                <input class="am-animation-slide-left" style="width: 14em;<?php if(empty($end_time)) {echo 'display: none';$end_time=time(); }?>" type="datetime-local" 
				id="id_end_time" value="<?php echo date('Y-m-d',$end_time).'T'.date('h:i',$end_time)?>">
                抽奖截至时间，不选择代表不限制
            </label>
			<label class="am-checkbox spc-checkbox">
					<input type="checkbox" id="id_must_login" data-am-ucheck <?php if(!empty($reward['access_rule']['must_login'])) echo 'checked';?>>
					是否必须登陆才能进行抽奖
			</label>
            <label class="am-checkbox del-checkbox">
                    <input type="checkbox" id="must_deal" data-am-ucheck <?php if(!empty($reward['access_rule']['must_deal'])) echo 'checked';?>>
                    允许非在本小程序成交用户抽奖
            </label>
        </div>

    </div>

    <div class="am-g am-margin-top-sm" style="margin-top:20px;">
        <div class="am-u-sm-2 am-text-right">
            抽奖限制
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-form-group reward-limit-box">
                <p style="margin-bottom: 8px"><span style="margin-right: 10px" class="am-icon-lightbulb-o am-warning am-icon-sm"></span>不选择就代表不限制</p>
				
                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name=""data-am-ucheck <?php if(!empty($reward['access_rule']['max_item'])) echo 'checked';?> >
                    <input class="am-animation-slide-left" type="number" id="id_max_item"  <?php if(!empty($reward['access_rule']['max_item'])) echo 'value="'.$reward['access_rule']['max_item'].'"';else echo 'style="display: none"';?>/>
                    最多允许中奖次数
                </label>

                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name="" data-am-ucheck <?php if(!empty($reward['access_rule']['max_cnt'])) echo 'checked';?> >
                    <input class="am-animation-slide-left" type="number" id="id_max_cnt" <?php if(!empty($reward['access_rule']['max_cnt'])) echo 'value="'.$reward['access_rule']['max_cnt'].'"';else echo 'style="display: none"';?>/>
                    每个用户最多允许抽奖多少次
                </label>

                <label class="am-checkbox margin-bottom">
                    <input type="checkbox" name="" data-am-ucheck <?php if(!empty($reward['access_rule']['max_cnt_day'])) echo 'checked';?>>
                    <input class="am-animation-slide-left" type="number" id="id_max_cnt_day" <?php if(!empty($reward['access_rule']['max_cnt_day'])) echo 'value="'.$reward['access_rule']['max_cnt_day'].'"';else echo 'style="display: none"';?>/>
                    每个用户每天最多允许抽奖多少次
                </label>
				
            </div>
        </div>
    </div>


    <div class="am-g am-margin-top-sm" style="margin-top:20px;">
        <div class="am-u-sm-2 am-text-right">
            介绍
        </div>
        文本编辑

        <div class="am-u-sm-8 am-u-end">
            <script id="container" name="brief" type="text/plain" style="height:250px;"><?php if(!empty($reward['brief'])) echo ''.$reward['brief'].'';?></script>
        </div>
    </div>
	
	
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
            中奖后动作 <span class="am-icon-question-circle am-text-danger" data-am-popover="{content: '表单用于收集中奖用户信息', trigger: 'hover focus'}">
        </div>
        <div class="am-u-sm-2 am-u-end">
			<select id="id_win_rule_type">
			<option value="none"<?php if(empty($reward['win_rule']["type"])) echo 'selected'; ?>>无</option>
			<option value="form"<?php if(!empty($reward['win_rule']["type"])&&$reward['win_rule']["type"]=='form') echo 'selected'; ?>>填写表单</option>
			<option value="url" <?php if(!empty($reward['win_rule']["type"])&&$reward['win_rule']["type"]=='url') echo 'selected'; ?>>跳转到链接</option>
			</select>
			
        </div>

    </div>
	
	<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>

	 <div class="am-g am-margin-top-sm win_rule" style="margin-top:20px;">
		<div class="am-u-sm-2 am-text-right ">
			<span class="id_win_rule_name">选项名</span>
        </div>
		<div class="am-u-sm-8  win_rule_form ">
		<?php
			echo '<select class="text-chosen"  id="id_win_rule_form" multiple  style="width:80%;margin-top: 10px">';
			if(!empty($reward['win_rule']["data"]))
			{	
				foreach( $reward['win_rule']["data"] as $a)
				{
				echo !empty($a)?'<option selected="selected">'.$a.'</option>':'';
				}
			}
				echo '</select>';
		?>
		</div>
		<div class="am-u-sm-6 am-u-end win_rule_url" >
			<input type="text" id="id_win_rule_url">
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


<?php
	echo '<script>
        var g_uid = '.(!empty($reward['uid']) ? $reward['uid'] : 0).';
            </script>';

$extra_js =  array(
    '/static/js/select2/js/select2.min.js',
    '/static/js/ueditor/ueditor.config.js',
    '/static/js/ueditor/ueditor.all.js',
    '/app/reward/static/js/addreward.js',
    //'/app/reward/static/js/new-addreward.js'
);
?>

<script>
    seajs.use(['selectPic']);
</script>