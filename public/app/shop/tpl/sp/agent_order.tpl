<?php
#var_export($agent_order);
?>
<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">订单列表</strong> /
		<small>总计 <?php echo $agent_order['count']; ?> 个</small>
	</div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-3">
		<div class="am-fl am-cf">
		</div>
		<div class="am-form-group am-margin-left am-fl">
			<select data-am-selected="{btnSize: 'lg' }" class="option_cat">
				<?php
				$cats = array(
					array('uid' => OrderMod::ORDER_WAIT_USER_PAY, 'title' => '待付款'),
					//array('uid' => OrderMod::ORDER_WAIT_SHOP_ACCEPT,  'title' => '待接单'),	
					array('uid' => OrderMod::ORDER_WAIT_FOR_DELIVERY, 'title' => '待发货'),
					array('uid' => OrderMod::ORDER_WAIT_USER_RECEIPT, 'title' => '待收货'),
					array('uid' => OrderMod::ORDER_UNDER_NEGOTATION, 'title' => '待退款'),
					array('uid' => OrderMod::ORDER_DELIVERY_OK, 'title' => '已完成'),
					array('uid' => OrderMod::ORDER_COMMENT_OK, 'title' => '已评价'),
					array('uid' => OrderMod::ORDER_CANCELED, 'title' => '已取消'),
					//array('uid' => OrderMod::ORDER_SHOP_CANCELED,     'title' => '已拒绝'),	
					array('uid' => OrderMod::ORDER_NEGOTATION_OK, 'title' => '已退款'),
				);
				
				$html = '<option value="0"';
				if ($option['status'] == 0)
				{
					$html .= ' selected ';
				}
				$html .= '>所有订单</option>';
				
				foreach ($cats as $c)
				{
					$html .= '<option value="' . $c['uid'] . '"';
					if ($option['status'] == $c['uid'])
					{
						$html .= ' selected';
					}
					$html .= '>' . $c['title'] . '</option>';
				}
				echo $html;
				?>
			</select>
		</div>
	</div>
	<div class="am-u-md-8 am-u-end">

		<div class="am-fl am-u-sm-2 am-u-end">
			<?php
			echo '<a class="am-btn am-btn-default " type="button" href="?_a=shop&_u=sp.agent_order">查看全部</a>';
			?>
		</div>
		<div class="am-fl am-u-sm-2 am-u-end">
			<?php
			echo '<a class="am-btn am-btn-primary " type="button" href="?_a=shop&_u=sp.choose_a_agent&url='.
				urlencode('?_a=shop&_u=sp.agent_order').'">查看某个代理商的用户</a>';
			?>
		</div>
	</div>
	<!--	<div class="am-u-md-3 am-cf">-->
	<!--		<div class="am-fr">-->
	<!--			<div class="am-input-group am-input-group-sm">-->
	<!--				<input type="text" class="am-form-field option_key" value="-->
	<?php //echo $option['key'];?><!--"placeholder="订单号搜索">-->
	<!--                <span class="am-input-group-btn">-->
	<!--                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>-->
	<!--                </span>-->
	<!--			</div>-->
	<!--		</div>-->
	<!--	</div>-->

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

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm-accept">
	<div class="am-modal-dialog">
		<div class="am-modal-hd">处理订单</div>
		<div class="am-modal-bd">
			请选择订单处理方式
		</div>
		<div class="am-modal-footer">
			<span class="am-modal-btn" data-am-modal-confirm>确定接单</span>
			<span class="am-modal-btn" data-am-modal-cancel>残忍拒绝</span>
		</div>
	</div>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm-delivery">
	<div class="am-modal-dialog ">
		<div class="am-modal-hd">填写发货信息</div>
		<hr/>
		<form class="am-form am-form-horizontal">
			<div class="am-form-group">
				<label class="am-u-sm-3 am-form-label" for="id_courier_no">快递单号</label>

				<div class="am-u-sm-9">
					<input id="id_courier_no" class="am-form-field">
				</div>
			</div>
			<div class="am-form-group">
				<label class="am-u-sm-3 am-form-label" for="id_courier_name">快递员姓名</label>

				<div class="am-u-sm-9">
					<input id="id_courier_name" class="am-form-field">
				</div>
			</div>
			<div class="am-form-group">
				<label class="am-u-sm-3 am-form-label" for="id_courier_phone">快递员电话</label>

				<div class="am-u-sm-9">
					<input id="id_courier_phone" class="am-form-field">
				</div>
			</div>
		</form>
		
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

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm-refund">
	<div class="am-modal-dialog ">
		<div class="am-modal-hd">申请退款</div>
		<hr/>
		<form class="am-form am-form-horizontal">
			<div class="am-form-group">
				<label class="am-u-sm-3 am-form-label" for="id_refund_fee">退款金额(&yen;)</label>

				<div class="am-u-sm-9">
					<input id="id_refund_fee" class="am-form-field">
				</div>
			</div>
			<div class="am-form-group">
				<label class="am-u-sm-3 am-form-label" for="id_refund_reason">退款原因</label>

				<div class="am-u-sm-9">
					<input id="id_refund_reason" class="am-form-field">
				</div>
			</div>
		</form>
		
		<div class="am-modal-footer">
			<span class="am-modal-btn" data-am-modal-confirm>确定</span>
			<span class="am-modal-btn" data-am-modal-cancel>取消</span>
		</div>
	</div>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm-acceptrefund">
	<div class="am-modal-dialog ">
		<div class="am-modal-hd">退款确认</div>
		<hr/>
		<form class="am-form am-form-horizontal">
			<div class="am-form-group">
				<label class="am-u-sm-3 am-form-label" for="id_acceptrefund_reason">拒绝原因</label>

				<div class="am-u-sm-9">
					<input id="id_acceptrefund_reason" class="am-form-field">
				</div>
			</div>
		</form>
		
		<div class="am-modal-footer">
			<span class="am-modal-btn" data-am-modal-confirm>同意退款</span>
			<span class="am-modal-btn" data-am-modal-cancel>拒绝退款</span>
		</div>
	</div>
</div>

<div class="am-u-sm-12">
	<table class="am-table am-table-striped am-table-hover table-main">
		<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span
						class="am-icon-trash"></span></a>
			</th>
			<th class="table-title">订单号</th>
			<th class="table-status">状态</th>
			<th class="table-parent">顾客</th>
			<th class="table-agent_uid">所属于代理</th>
			<th class="table-parent">下单时间</th>
			<th class="table-image">付款时间</th>
			<th class="table-time">商品</th>
			<th class="table-cnt">购买价格(&yen;)</th>
			<th class="table-bonus">佣金(&yen;)</th>
			<th class="table-set">操作</th>
		</tr>
		</thead>
		<tbody>
		<?php
		if (!$agent_order['list'])
		{
			echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
		}
		else
		{
			$html = '';
			foreach ($agent_order['list'] as $c)
			{
				$html .= '<tr';
				if (in_array($c['status'], array(SpServiceMod::ORDER_WAIT_FOR_DELIVERY,
				                                 SpServiceMod::ORDER_UNDER_NEGOTATION)))
				{
					$html .= ' class="am-danger "';
				}
				$html .= ' data-id="' . $c['uid'] . '"><td class="table-check"><input type="checkbox" class="ccheck"></td>' .
					'<td><a href="?_a=shop&_u=sp.orderdetail&uid=' . $c['uid'] . '">' . $c['uid'] . '</a></td>' .
					'<td>';
				
				switch ($c['status'])
				{
					case OrderMod::ORDER_WAIT_USER_PAY:
					{
						$html .= '<a class="cdopay am-btn am-btn-xs am-btn-warning">待付款</a>';
						break;
					}
					case OrderMod::ORDER_DELIVERY_OK:
					{
						$html .= '<a class="am-btn am-btn-xs am-btn-success">已完成</a>';
						break;
					}
					case OrderMod::ORDER_COMMENT_OK:
					{
						$html .= '<a class="am-btn am-btn-xs am-btn-success">已评价</a>';
						break;
					}
					case OrderMod::ORDER_WAIT_FOR_DELIVERY:
					{
						$html .= '<a class="cdodelivery am-btn am-btn-xs am-btn-danger">待发货</a>';
						break;
					}
					case OrderMod::ORDER_WAIT_USER_RECEIPT:
					{
						$html .= '<a class="cdoreceipt am-btn am-btn-xs am-btn-secondary">待收货</a>';
						break;
					}
					case OrderMod::ORDER_WAIT_SHOP_ACCEPT:
					{
						$html .= '<a class="cdoaccept am-btn am-btn-xs am-btn-primary">待接单</a>';
						break;
					}
					case OrderMod::ORDER_CANCELED:
					{
						$html .= '<a class="am-btn am-btn-xs am-btn-default">已取消</a>';
						break;
					}
					case OrderMod::ORDER_SHOP_CANCELED:
					{
						$html .= '<a class="am-btn am-btn-xs am-btn-default">已拒绝</a>';
						break;
					}
					case OrderMod::ORDER_UNDER_NEGOTATION:
					{
						$html .= '<a class="cacceptrefund am-btn am-btn-xs am-btn-warning">待退款</a>';
						break;
					}
					case OrderMod::ORDER_NEGOTATION_OK:
					{
						$html .= '<a class="am-btn am-btn-xs am-btn-default">已退款</a>';
						break;
					}
					default:
					{
						$html .= $c['status'];
					}
				}
				$html .= '</td>' .
					'<td><a target="_blank" class="am-btn am-btn-primary  " href="?_a=su&_u=sp.fanslist&uid='.$c['user']['uid'].'">'
					. ($c['user']['name'] ? $c['user']['name'] : $c['user']['account']) . '</a></td>' .

				'<td><a target="_blank" class="am-btn am-btn-primary  " href="?_a=shop&_u=sp.agent&uid=' .
					$c['agent']['uid'] . '">' . (empty($c['agent']['user']['name']) ? '-' : $c['agent']['user']['name']) . '</a></td>' .
					'<td>' . (date('Y-m-d H:i:s', $c['create_time'])) . '</td>' .
					'<td>';
				if ($c['paid_time'])
				{
					$html .= date('Y-m-d H:i:s', $c['create_time']);
				}
				else
				{
					$html .= '-';
				}
				$html .= '</td>' .
					'<td>';
				$html .= implode(' ', array_column($c['products'], 'title'));
				$html .= '</td>' .
					'<td>' . ($c['paid_fee'] / 100) . '</td>' .
					'<td>' . ($c['bonus'] / 100) . '</td>' .
					'<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
				
				if (in_array($c['status'], array(SpServiceMod::ORDER_CANCELED, SpServiceMod::ORDER_WAIT_USER_PAY)))
				{
					$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="' . $c['uid'] .
						'"><span class="am-icon-trash-o"></span> 删除</button>';
				}
				if (in_array($c['status'], array(SpServiceMod::ORDER_WAIT_SHOP_ACCEPT,
				                                 SpServiceMod::ORDER_WAIT_FOR_DELIVERY)))
				{
					if ($c['paid_fee'] > 0)
					{
						$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-warning cdorefund" data-id="' . $c['uid'] .
							'" data-fee="' . $c['paid_fee'] . '" ><span class="am-icon-money"></span> 申请退款</button>';
					}
				}
				
				$html .= '</div></div></td>' . '</tr>';
				
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
$extra_js = $static_path . '/js/orderlist.js';
?>

