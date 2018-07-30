<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">自助提现记录</strong> / <small>总计 <?php echo $data['count'];?> 条记录</small></div>
</div>
<?php
#var_export($cfg);
#var_export($cats);
#var_export($data['list']);
?>

<div class="ChangeBar">
    <div class="fans am-u-md-4" style="padding-left:20px;">
      <span class="word">已提现</span>
      <span class="num" id="TodayFans" style=""><?php echo !empty($wd['cash_withdrawed']) ? ($wd['cash_withdrawed'] / 100) : 0;?></span>
    </div>
</div>

    <div class="am-u-md-4">
            <div class="am-form-group am-margin-left">
			状态:
              <select data-am-selected="{btnSize: 'lg' }" class="option_cat">
				<?php
					$html = '';
					$groups = array(
						'-1' => '全部',
						'0' => '待审核',
						'1' => '成功',
						'2' => '失败',
					);	
					foreach($groups as  $k => $v) {
						$html .= '<option value="'.$k.'"';
						if($option['status'] == $k) $html .= ' selected';
						$html .= '>'.$v.'</option>';
					}
					echo $html;
				?>
              </select>
            </div>
    </div>

<!-- 头部工具栏 -->
<div class="am-g">
	<div class="am-u-md-6">
	<div class="am-fl am-cf">
		<!--
          <div class="am-btn-toolbar am-fl">
            <div class="am-form-group am-margin-left am-fl">
              <select data-am-selected="{btnWidth: 150, btnSize: 'lg' }" class="option_cat">
				<?php
					$cats = array(0 => '全部', 2 => '微信企业付款', 1 => '微信红包', 3 => '测试提现', 4 => '线下打款', 5 => '微信付款到银行卡');
					$html = '';
					foreach($cats as $k => $cat) {
					$html .= '<option value="'.$k.'"';
					if($option['wd_type'] == $k) $html .= ' selected';
					$html .= '>'.$cat.'</option>';
					}
					echo $html;
				?>
              </select>
            </div>
        </div>
		-->

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
			<!--<th class="table-check"><input type="checkbox"></th>-->
			<th class="table-title">编号</th>
			<th class="table-title">用户</th>
			<th class="table-type">提现金额(&yen;)</th>
			<th class="table-date">类型</th>
			<th class="table-date">时间</th>
			<th class="table-date">状态</th>
			<th class="table-date">备注</th>
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
			if($l['status'] > 1) {
				$html .= ' class="am-danger am-link-muted"';
			}
			$html .= '>
              <td>'.$l['uid'].'</td>
              <td><a href="?_a=su&_u=sp.fansdetail&uid='.$su['uid'].'">'.$su['name'].'</a></td>
              <td>'.($l['cash']/100).'</td>
              <td><span>'.$cats[$l['wd_type']].'</span></td>
              <td>'.date('Y-m-d H:i:s', $l['create_time']).'</td>
			  <td>'.($l['status'] == 0 ? '<button class="am-btn am-btn-default cconfirm" data-id="'
											.$l['uid'].'">待审核</button>' :
				 ($l['status'] == 1 ? '<button class="am-btn am-btn-success">成功</button>' : 
				 '<button class="am-btn am-btn-danger">失败</button>')).'</td>
              <td>'.$l['info'].'</td>
              ';

			$html .= '
              <td>
                <div class="am-btn-toolbar">
                  <div class="am-btn-group am-btn-group-xs">
                    ';
				if($l['status'] != 1) {
				$html .= '<button class="am-btn am-btn-success am-btn-xs cconfirm " data-id="'.$l['uid'].
							'"><span class="am-icon-send"></span> 确定打款</button>';
				$html .= '<button class="am-btn am-btn-danger am-btn-xs crefuse" data-id="'.$l['uid'].
							'"><span class="am-icon-deny"></span> 拒绝</button>';
				}
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
	$extra_js = $static_path.'/js/withdrawlist.js';
?>
