<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">收款记录</strong> / <small>总计 <?php echo $data['count'];?> 条记录</small></div>
</div>
<?php
#var_export($cfg);
#var_export($cats);
#var_export($data['list']);
?>

<div class="ChangeBar">
    <div class="fans am-u-md-4" style="padding-left:20px;">
      <span class="word">账户余额</span>
      <span class="num" id="TodayFans" style=""><?php echo !empty($cfg['cash_remain']) ? ($cfg['cash_remain'] / 100) : 0;?></span>
    </div>
    <div class="attention am-u-md-4">
      <span class="word">已提现</span>
      <a href="?_a=pay&_u=sp.transfer"><span class="num" id="TotalFans" style=""><?php echo !empty($cfg['cash_transfered']) ? ($cfg['cash_transfered'] / 100) : 0;?></span></a>
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
					$cats = array(0 => '全部', 2 => '收入', 1 => '提现');
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
			<!--<th class="table-check"><input type="checkbox"></th>--><th class="table-title">编号</th>
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
			$html .= '	
            <tr';
			if($l['type'] == 1) {
				$html .= ' class="am-danger am-link-muted"';
			}
			$html .= '>
              <td>'.$l['uid'].'</td>
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

<div class="am-u-sm-12">
<?php
	echo $pagination;
?>
</div>

<?php
	$extra_js = $static_path.'/js/uctpaylist.js';
?>
