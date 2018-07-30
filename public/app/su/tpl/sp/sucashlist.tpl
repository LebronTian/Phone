<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">收支记录</strong> / <small>总计 <?php echo $data['count'];?> 条记录</small></div>
</div>

<?php
#var_export($cfg);
#var_export($cats);
#var_export($data['list']);
if(!empty($option['su_uid'])) {
	$pt = SuPointMod::get_user_points_by_su_uid($option['su_uid']);
	$user = AccountMod::get_service_user_by_uid($option['su_uid']);
	echo '<div class="am-margin"><strong>'.$user['name'].'</strong> 的收支记录</div>';
}

?>

<div class="ChangeBar">
	<?php if(!empty($option['su_uid'])){?>
    <div class="fans am-u-md-4" style="padding-left:20px;">
      <span class="word">账户余额</span>
      <span class="num" id="TodayFans" style=""><?php echo !empty($pt['cash_remain']) ? ($pt['cash_remain'] / 100) : 0;?></span>
    </div>
	<?php }?>
    <div class="attention am-u-md-4">
	<?php
	  if (!empty($option['su_uid'])) {
      echo '<span class="word am-text-primary" style="cursor:pointer;" id="id_sucharge">充值</span>';
      echo '<span class="word am-text-primary" style="cursor:pointer;margin-left:30px;" id="id_sucharge2">赠送</span>';
		}
	?>
    </div>
    <div class="access am-u-md-4" style="padding-left:158px;padding-top:54px;">
    </div>
</div>

<!-- 头部工具栏 -->
<div class="am-g">
	<div class="am-u-md-6">
	<div class="am-fl am-cf">
          <div class="am-btn-toolbar am-fl">

            <div class="am-form-group am-margin-left am-fl">
              <select data-am-selected="{btnWidth: 150, btnSize: 'lg' }" class="option_cat">
				<?php
					$cats = array(0 => '全部', 2 => '充值', 1 => '消费');
					$html = '';
					foreach($cats as $k => $cat) {
					$html .= '<option value="'.$k.'"';
					if($option['type'] == $k) $html .= ' selected';
					$html .= '>'.$cat.'</option>';
					}
					echo $html;
				?>
              </select>
            </div>
        </div>
    </div>
    </div>

</div>
<br/>
<br/>
<!-- 头部工具栏 end -->

<div class="am-u-sm-12">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<!--<th class="table-check"><input type="checkbox"></th>--><th class="table-title">用户</th>
			<th class="table-type">交易金额(&yen;)</th><th class="table-type">账号余额(&yen;)</th>
			<th class="table-date">类型</th><th class="table-date">时间</th><th class="table-date">备注</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
          <tbody>
<?php
	if(!$data['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($data['list'] as $l) {
			$su = AccountMod::get_service_user_by_uid($l['su_uid']);
			$html .= '	
            <tr';
			if($l['type'] == 1) {
				$html .= ' class="am-danger am-link-muted"';
			}
			$html .= '>
              <td class="cuser" data-id="'.$l['su_uid'].'">'.($su['name']?$su['name']:$su['account']).'</td>
              <td>'.($l['cash']/100).'</td>
              <td>'.($l['cash_remain']/100).'</td>
              <td><span>'.$cats[$l['type']].'</span></td>
              <td>'.date('Y-m-d H:i:s', $l['create_time']).'</td>
              <td>'.$l['info'].'</td>
              ';

			$html .= '
              <td>
                <div class="am-btn-toolbar">
                  <div class="am-btn-group am-btn-group-xs">
                    ';
			$html .= '
                  </div>
                </div>
              </td>
            </tr>
			';
		}
		echo $html;
	}
?>


          </tbody>
        </table>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog ">
    <div class="am-modal-hd">给 <?php echo @$user['name']; ?> 充值</div>
	<hr/>
	<form class="am-form am-form-horizontal">
    	<div class="am-form-group">
			<label class="am-u-sm-3 am-form-label" for="id_charge_price">充值金额（元）</label> 		
			<div class="am-u-sm-9">
				<input id="id_charge_price" class="am-form-field" data-id="<?php echo $option['su_uid'];?>" >
    		</div>
    	</div>
   	 </form>
	
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm2">
  <div class="am-modal-dialog ">
    <div class="am-modal-hd">给 <?php echo @$user['name']; ?> 赠送</div>
	<hr/>
	<form class="am-form am-form-horizontal">
    	<div class="am-form-group">
			<label class="am-u-sm-3 am-form-label" for="id_charge_price">赠送金额（元）</label> 		
			<div class="am-u-sm-9">
				<input id="id_charge_price2" class="am-form-field" data-id="<?php echo $option['su_uid'];?>" >
    		</div>
    	</div>
   	 </form>
	
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<div class="am-u-sm-12">
<?php
	echo $pagination;
?>
</div>

<?php
	$extra_js = $static_path.'/js/sucashlist.js';
	echo '<script>var g_su_uid = '.(!empty($option['su_uid']) ? $option['su_uid'] : 0).';</script>';
?>
