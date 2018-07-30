<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">服务订单</strong> / <small>总计 <?php echo $data['count'];?> 个</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-6">
	<div class="am-fl am-cf">
    <a  href="?_a=sp&_u=index.servicestore" type="button" class="am-btn am-btn-success"><span class="am-icon-cloud"></span> 服务商城</a>
	</div>
            <div class="am-form-group am-margin-left am-fl">
              <select data-am-selected="{btnSize: 'lg' }" class="option_cat">
				<?php
					$cats = array(
						array('uid' => SpServiceMod::ORDER_WAIT_USER_PAY, 'title' => '待付款'),	
						array('uid' => SpServiceMod::ORDER_DELIVERY_OK,   'title' => '已完成'),	
						array('uid' => SpServiceMod::ORDER_WAIT_FOR_DELIVERY, 'title' => '待发货'),	
						array('uid' => SpServiceMod::ORDER_WAIT_USER_RECEIPT, 'title' => '待收货'),	
						array('uid' => SpServiceMod::ORDER_CANCELED,      'title' => '已取消'),	
					);

					$html = '<option value="0"';
					if($option['status']==0) $html .= ' selected ';
					$html .= '>所有订单</option>';
					
					foreach($cats as  $c) {
					$html .= '<option value="'.$c['uid'].'"';
					if($option['status'] == $c['uid']) $html .= ' selected';
					$html .= '>'.$c['title'].'</option>';
					}
					echo $html;
				?>
              </select>
            </div>
        </div>

	<div class="am-u-md-3 am-cf">
        <div class="am-fr">
          <div class="am-input-group am-input-group-sm">
            <input type="text" class="am-form-field option_key" value="<?php echo $option['key'];?>"placeholder="订单号搜索">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
          </div>
        </div>
      </div>

</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除订单</div>
    <div class="am-modal-bd">
      确定要删除吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm-receipt">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">确认收货</div>
    <div class="am-modal-bd">
      要确认收货吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<div class="am-u-sm-12">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th>
			<th class="table-title">订单号</th><th class="table-status">状态</th>
			<th class="table-parent">下单时间</th>
			<th class="table-image">付款时间</th>
			<th class="table-time">服务名称</th><th class="table-cnt">购买价格(&yen;)</th>
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
		foreach($data['list'] as $c) {
			$html .= '<tr';
			if($c['status'] == SpServiceMod::ORDER_WAIT_FOR_DELIVERY) {
				$html .= ' class="am-danger "';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
					'<td><a href="?_a=sp&_u=index.orderdetail&uid='.$c['uid'].'">'.$c['uid'].'</a></td>'.
					'<td>';
			if($c['status'] == SpServiceMod::ORDER_WAIT_USER_PAY) {
				$html .= '<a class="cdopay am-btn am-btn-xs am-btn-warning">待付款</a>';
			}
			else if($c['status'] == SpServiceMod::ORDER_DELIVERY_OK) {
				$html .= '<a class="cstatus am-btn am-btn-xs am-btn-success">已完成</a>';
			}
			else if($c['status'] == SpServiceMod::ORDER_WAIT_FOR_DELIVERY) {
				$html .= '<a class="am-btn am-btn-xs am-btn-danger">待发货</a>';
			}
			else if($c['status'] == SpServiceMod::ORDER_WAIT_USER_RECEIPT) {
				$html .= '<a class="cdoreceipt am-btn am-btn-xs am-btn-secondary">待收货</a>';
			}
			else if($c['status'] == SpServiceMod::ORDER_CANCELED) {
				$html .= '<a class="cstatus am-btn am-btn-xs am-btn-default">已取消</a>';
			}
			else {
				$html .= $c['status'];
			}
			$html .= '</td>'.
					'<td>'.(date('Y-m-d H:i:s', $c['create_time'])).'</td>'.
					'<td>';
			if($c['paid_time']) {
				$html .= date('Y-m-d H:i:s', $c['create_time']);
			}
			else {
				$html .= '-';
			}
			$html .= '</td>'.
					'<td><a href="?_a=sp&_u=index.servicedetail&uid='.$c['service_uid'].'">'.$c['service']['name'].'</a></td>'.
					'<td>'.($c['paid_fee']/100).'</td>'.
					'<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';

			if(in_array($c['status'], array(SpServiceMod::ORDER_CANCELED, SpServiceMod::ORDER_WAIT_USER_PAY)))
			$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
		
			$html .= '</div></div></td>'.'</tr>';
					
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
	$extra_js = $static_path.'/js/orderlist.js';
?>

