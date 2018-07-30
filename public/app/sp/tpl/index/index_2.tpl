<div class="am-cf am-padding">
      <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">首页</strong> / <small>快捷入口</small></div>
    </div>

	<ul class="am-avg-sm-1 am-avg-md-4 am-margin am-padding am-text-center admin-content-list ">

<?php
$cats = array(0 => '伪公众号', 1 => '订阅号', 2 => '服务号', 3 => '企业号');
	//最近使用的模块
	foreach(SpMod::getRecentUsedApp() as $r) {
		$p = WeixinPlugMod::get_plugin_by_dir($r);
		if(empty($_REQUEST['_d']) && ($p['type'] == 'basic') &&
			!strncmp('fk_', WeixinMod::get_current_weixin_public('origin_id'), 3)) {
			continue;
		}
      	echo '<li><a href="?_a='.$p['dir'].'&_u=sp" class="am-text-primary"><span class="am-icon-btn"><img src="'.$p['thumb'].'"></span></br>'.
			$p['name'].'</a></br> </li>';
	}
?>
      <li><a href="?_a=sp&_u=index.pluginstore" class="am-text-success"><span class="am-icon-btn am-icon-plus"></span><br>添加插件<br></a></li>
    </ul>

<?php

if(!empty($_REQUEST['_d']) || 
	strncmp('fk_', WeixinMod::get_current_weixin_public('origin_id'), 3)) 
{
	echo '<div class="am-u-md-6">
        <div class="am-panel am-panel-default">
          <div class="am-panel-hd am-cf" data-am-collapse="{target: \'#collapse-panel-1\'}">当前公众号<span class="am-icon-chevron-down am-fr"></span></div>
          <div class="am-panel-bd am-collapse am-in" id="collapse-panel-1">
            <ul class="am-list">
              <li>
                <p> ';echo WeixinMod::get_current_weixin_public('public_name'); echo '</p>
              </li>
              <li>
                <p> ';echo WeixinMod::get_current_weixin_public('has_verified') ? '已认证' : '未认证'; 
					$t = WeixinMod::get_current_weixin_public('public_type');
					echo isset($cats[$t]) ? $cats[$t] : '';	
				echo '</p>
              </li>
            </ul>
          </div>
        </div>
      </div>';
}
?>

	<div class="am-u-md-6">
        <div class="am-panel am-panel-default">
          <div class="am-panel-hd am-cf" data-am-collapse="{target: '#collapse-panel-2'}">系统公告<span class="am-icon-chevron-down am-fr"></span></div>
          <div class="am-panel-bd am-collapse am-in" id="collapse-panel-2">
            <ul class="am-list">
              <li>
                <p><a>优创智投 微信公众号营销平台上线啦!</a></p>
              </li>
              <li>
                <p><a>好消息! UCTOO 免费试用啦!</a></p>
              </li>
            </ul>
          </div>
        </div>
      </div>

	<div class="am-u-md-6" style="float:left !important;">
        <div class="am-panel am-panel-default">
          <div class="am-panel-hd am-cf" data-am-collapse="{target: '#collapse-panel-3'}">账号配额<span class="am-icon-chevron-down am-fr"></span></div>
          <div class="am-panel-bd am-collapse am-in" id="collapse-panel-3">
            <ul class="am-list">
			  <li><a class="am-text-success" href="?_a=sp&_u=index.servicestore"><span class="am-icon-cloud"></span> 服务商城</a></li>
              <li>
                <p>服务到期时间: <?php $expire = SpLimitMod::get_current_sp_limit('expire_time');
								echo '<span class="am-text-primary">'.($expire ? date('Y-m-d H:i:s', $expire) : '永久').'</span>'; ?></p>
              </li>
              <li>
                <p>剩余公众号数目: <?php $public_total = AccountMod::get_current_service_provider('max_public_cnt');
										$public_remain = $public_total -  Dba::readOne('select count(*) from weixin_public where sp_uid = '.
										 AccountMod::get_current_service_provider('uid'));
								echo '<span class="am-text-primary">'.$public_remain.' / '
								.$public_total.'</span>'; ?></p>
              </li>
              <li>
                <p>剩余短信数目: <?php echo '<span class="am-text-primary">'.SpLimitMod::get_current_sp_limit('sms_remain').' / '
								.SpLimitMod::get_current_sp_limit('sms_total').'</span>'; ?></p>
              </li>
              <li>
                <p>剩余excel导出次数: <?php echo '<span class="am-text-primary">'.SpLimitMod::get_current_sp_limit('excel_remain').' / '
								.SpLimitMod::get_current_sp_limit('excel_total').'</span>'; ?></p>
              </li>
            </ul>
          </div>
        </div>
      </div>

<script>
    var visitData = <?php echo(!empty($visit))? json_encode($visit):"null" ?>
</script>