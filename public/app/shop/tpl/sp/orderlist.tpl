<?php
	#var_export($data);
?>
<link rel="stylesheet" href="/static/css/select_user.css"/>
<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">订单列表</strong> / <small>总计 <?php echo $data['count'];?> 个</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-6">
	<div class="am-fl am-cf">
	</div>
            <div class="am-form-group am-margin-left am-fl">
              <select data-am-selected="{btnSize: 'lg' }" class="option_cat">
				<?php
					$cats = array(
						array('uid' => OrderMod::ORDER_WAIT_USER_PAY,     'title' => '待付款'),	
						//array('uid' => OrderMod::ORDER_WAIT_SHOP_ACCEPT,  'title' => '待接单'),
						array('uid' => OrderMod::ORDER_WAIT_FOR_DELIVERY, 'title' => '待发货'),	
						array('uid' => OrderMod::ORDER_WAIT_USER_RECEIPT, 'title' => '待收货'),	
						array('uid' => OrderMod::ORDER_UNDER_NEGOTATION,  'title' => '待退款'),	
						array('uid' => OrderMod::ORDER_DELIVERY_OK,       'title' => '已完成'),	
						array('uid' => OrderMod::ORDER_COMMENT_OK,        'title' => '已评价'),	
						array('uid' => OrderMod::ORDER_CANCELED,          'title' => '已取消'),	
						//array('uid' => OrderMod::ORDER_SHOP_CANCELED,     'title' => '已拒绝'),	
						array('uid' => OrderMod::ORDER_NEGOTATION_OK,     'title' => '已退款'),	
						array('uid' => OrderMod::ORDER_WAIT_GROUP_DONE,     'title' => '待成团'),	
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
<?php
if($option['status'] == 8) {
echo '<a style="margin-left:30px;" href="?_a=pay&_u=sp.set_refund">退款设置</a>';
}
?>
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
<div class="am-padding  am-cf">
	<div class="am-u-sm-3 am-margin-left am-u-end">
		<button type="button" class="am-btn am-btn-default am-margin-right" id="my-start">开始日期</button>
		<span id="my-startDate"><?php echo date('Y-m-d', (empty($option['start_time']) ? strtotime(date('Y-m',time())): $option['start_time'])) ?></span>
	</div>
	<div class="am-u-sm-3 am-margin-left am-u-end">
		<button type="button" class="am-btn am-btn-default am-margin-right" id="my-end">结束日期</button>
		<span
				id="my-endDate"><?php echo date('Y-m-d', (empty($option['end_time']) ? time() : $option['end_time'])) ?></span>
	</div>
	<div class=" am-margin-left am-u-sm-3 am-u-end">
		<span class="am-btn am-btn-primary btn_show">查看</span>
	</div>
	<div class="am-form-group am-margin-left am-fl">
		<a data-am-popover="{content: '导出订单到excel格式文件', trigger: 'hover focus'}"
		   class="am-btn  am-btn-secondary" id="download_excel" target="_self"><span class="am-icon-file-excel-o"></span> 下载</a>
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
    <div class="am-modal-hd">配送信息</div>
	<hr/>
	<form class="am-form am-form-horizontal">

        <div class="am-form-group">
            <label class="am-u-sm-3 am-form-label" for="id_courier_name">快递公司</label>
            <div class="am-u-sm-9">
				<select id="id_courier_name">
					<option value="EMS">EMS</option>
					<option value="顺丰">顺丰</option>
					<option value="申通">申通</option>
					<option value="圆通">圆通</option>
					<option value="申通">申通</option>
					<option value="中通">中通</option>
					<option value="汇通">汇通</option>
					<option value="天天">天天</option>
					<option value="韵达">韵达</option>
					<option value="全峰">全峰</option>
					<option value="中国邮政">中国邮政</option>
					<option value="邮政平邮">邮政平邮</option>
					<option value="港中能达">港中能达</option>
					<option value="宅急送快递">宅急送快递</option>
					<option value="-1">其他</option>
				</select>
                <input id="id_courier_name2"  class="am-form-field" style="display: none">
            </div>
        </div>
        <div class="am-form-group">
            <label class="am-u-sm-3 am-form-label" for="id_courier_no">快递单号</label>
            <div class="am-u-sm-9">
                <input id="id_courier_no" class="am-form-field">
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

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm-paidcash">
	<div class="am-modal-dialog ">
		<div class="am-modal-hd">修改购买金额</div>
		<hr/>
		<form class="am-form am-form-horizontal">
			<div class="am-form-group">
				<label class="am-u-sm-3 am-form-label" for="id_paid_fee">购买金额(&yen;)</label>
				<div class="am-u-sm-9">
					<input id="id_paid_fee" class="am-form-field">
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
			<div class="am-u-sm-6">
				<input id="id_acceptrefund_reason" class="am-form-field">
    		</div>
			<div class="am-u-sm-3">
				<a style="text-decoration:underline;" target="_blank" class="am-text-warning" href="?_a=pay&_u=sp.set_refund"><span class="am-icon-gear"></span> 退款设置</a>
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
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th>
			<th class="table-title">订单号</th><th class="table-status">状态</th>
			<th class="table-parent">顾客</th>
			<th class="table-parent">下单时间</th>
			<th class="table-image">付款时间</th>
			<th class="table-time">商品</th>
            <th>收件人</th>
            <th>手机号码</th>
            <th>收货地址</th>
            <th class="table-cnt">购买价格(&yen;)</th>
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
			if(in_array($c['status'], array(SpServiceMod::ORDER_WAIT_FOR_DELIVERY, SpServiceMod::ORDER_UNDER_NEGOTATION))) {
				$html .= ' class="am-danger "';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
					'<td><a href="?_a=shop&_u=sp.orderdetail&uid='.$c['uid'].'">'.$c['uid'].'</a></td>'.
					'<td>';

			if($c['go_uid']) {
				$html .= '<span class="am-btn-warning">团</span>';
				if($c['remain_cnt']) $html .= ' <small class="am-text-danger">差'.$c['remain_cnt'].'人</small>';
				$html .= '</br>';
			}
			switch($c['status']) {
			case OrderMod::ORDER_WAIT_USER_PAY: {
				$html .= '<a class="cdopay am-btn am-btn-xs am-btn-warning">待付款</a>';
				break;
			}
			case OrderMod::ORDER_DELIVERY_OK: {
				$html .= '<a class="am-btn am-btn-xs am-btn-success">已完成</a>';
				break;
			}
			case OrderMod::ORDER_COMMENT_OK: {
				$html .= '<a class="am-btn am-btn-xs am-btn-success">已评价</a>';
				break;
			}
			case OrderMod::ORDER_WAIT_FOR_DELIVERY: {
				$html .= '<a class="cdodelivery am-btn am-btn-xs am-btn-danger">待发货</a>';
				break;
			}
			case OrderMod::ORDER_WAIT_USER_RECEIPT: {
				$html .= '<a class="cdoreceipt am-btn am-btn-xs am-btn-secondary">待收货</a>';
				break;
			}
			case OrderMod::ORDER_WAIT_SHOP_ACCEPT: {
				$html .= '<a class="cdoaccept am-btn am-btn-xs am-btn-primary">待接单</a>';
				break;
			}
			case OrderMod::ORDER_CANCELED: {
				$html .= '<a class="am-btn am-btn-xs am-btn-default">已取消</a>';
				break;
			}
			case OrderMod::ORDER_SHOP_CANCELED: {
				$html .= '<a class="am-btn am-btn-xs am-btn-default">已拒绝</a>';
				break;
			}
			case OrderMod::ORDER_UNDER_NEGOTATION: {
				$html .= '<a class="cacceptrefund am-btn am-btn-xs am-btn-warning">待退款</a>';
				break;
			}
			case OrderMod::ORDER_WAIT_GROUP_DONE: {
				$html .= '<a class="cwaitgroupdone am-btn am-btn-xs am-btn-default">待成团</a>';
				break;
			}
			case OrderMod::ORDER_NEGOTATION_OK: {
				$html .= '<a class="am-btn am-btn-xs am-btn-default">已退款</a>';
				break;
			}
			default: {
				$html .= $c['status'];
			}
			}
			$html .= '</td>' .
				'<td><a target="_blank" class="am-btn am-btn-primary  " href="?_a=su&_u=sp.fansdetail&uid='.$c['user']['uid'].'">'
				. ($c['user']['name'] ? $c['user']['name'] : $c['user']['account']) . '</a></td>' .

				'<td>'.(date('Y-m-d H:i:s', $c['create_time'])).'</td>'.
					'<td>';
			if($c['paid_time']) {
				$html .= date('Y-m-d H:i:s', $c['paid_time']);
			}
			else {
				$html .= '-';
			}
			$html .= '</td>'.'<td>';
			//$html .= implode('<br>', array_column($c['products'], 'title'));
			$html .= implode('<br>', array_map(function($it){ return $it['title'].' x '.$it['quantity'];}, $c['products']));
			$name = $phone = $address = '';
            if(isset($c['address']['province'])){
                $address = $c['address']['province'];
            }
            if(isset($c['address']['city'])){
                $address .= $c['address']['city'];
            }
            if(isset($c['address']['town'])){
                $address .= $c['address']['town'];
            }
            if(isset($c['address']['address'])){
                $address .= $c['address']['address'];
            }
			$address = (!empty($address))?$address:'';

			if(isset($c['address']['name'])){
				$name = $c['address']['name'];
			}
			if(isset($c['address']['phone'])){
				$phone = $c['address']['phone'];
			}

			$html .= '</td>'.'<td>'.$name;
			$html .= '</td>'.'<td>'.$phone;
            $html .= '</td>'.'<td>'.$address;

			$html .= '</td>'.
					'<td>'.($c['paid_fee']/100).'</td>'.
					'<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';

			if(in_array($c['status'], array(SpServiceMod::ORDER_WAIT_USER_PAY))) {
			$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-warning cdopaid" data-id="'.$c['uid'].'" data-fee="'.$c['paid_fee'].'" ><span class="am-icon-money"></span> 修改价格</button>';
			}
			if(in_array($c['status'], array(SpServiceMod::ORDER_CANCELED, SpServiceMod::ORDER_WAIT_USER_PAY))) {
				$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].
							'"><span class="am-icon-trash-o"></span> 删除</button>';
			}
			if(in_array($c['status'], array(SpServiceMod::ORDER_WAIT_SHOP_ACCEPT, SpServiceMod::ORDER_WAIT_FOR_DELIVERY))) {
				if($c['paid_fee'] > 0)
				$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-warning cdorefund" data-id="'.$c['uid'].	
							'" data-fee="'.$c['paid_fee'].'" ><span class="am-icon-money"></span> 申请退款</button>';
			}

			if($c['status'] == SpServiceMod::ORDER_WAIT_GROUP_DONE) {
				if($c['go_uid']) {
				$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-warning cdorefundgroup" data-id="'.$c['uid'].
					'" go-id="'.$c['go_uid'].'"><span class="am-icon-money"></span> 退团</button>';
				}
			}
		
			$html .= '</div></div></td>';

		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>
<!--<button class="choosedall am-btn am-btn-success btn-loading-example" style="margin-left:1.6rem">批量选择配送员</button>-->
<div class="am-u-sm-12">
<?php
	echo $pagination;
?>
</div>

<?php
	//$extra_js = $static_path.'/js/orderlist.js';
?>
<?php

	$extra_js =  array(
		  '/static/js/select_group_user.js',
		  $static_path.'/js/orderlist.js?1',
);
?>
<script>
	var status = <?php echo $option['status']; ?>;
	var option= <?php echo json_encode($option); ?>;

	$(function() {
		var startDate = new Date($('#my-startDate').text());
		var endDate = new Date($('#my-endDate').text());
		$('#my-start').datepicker().
		on('changeDate.datepicker.amui', function(event) {
			if (event.date.valueOf() > endDate.valueOf()) {
				showTip("err","结束日期应大于开始日期",1000);
			} else {

				startDate = new Date(event.date);
				$('#my-startDate').text($('#my-start').data('date'));
			}
			$(this).datepicker('close');
		});

		$('#my-end').datepicker().
		on('changeDate.datepicker.amui', function(event) {
			if (event.date.valueOf() < startDate.valueOf()) {
				showTip("err","结束日期应大于开始日期",1000);
			} else {

				endDate = new Date(event.date);
				$('#my-endDate').text($('#my-end').data('date'));
			}
			$(this).datepicker('close');
		});
	});
	$('.btn_show').click(function(){


		var start_time = new Date($('#my-startDate').text());
		var end_time = new Date($('#my-endDate').text());
		start_time = start_time.getTime()/1000;
		end_time = end_time.getTime()/1000;
		var url = '?_a=shop&_u=sp.orderlist';
//        console.log(start_time);

		if(start_time!=undefined) url+='&start_time='+start_time;
		if(end_time!=undefined) url+='&end_time='+end_time;
		if(status!=undefined) url+='&status='+status;

		window.location.href=url;

	});

	$('#download_excel').click(function(){
		var start_time = new Date($('#my-startDate').text());
		var end_time = new Date($('#my-endDate').text());
		start_time = start_time.getTime()/1000;
		end_time = end_time.getTime()/1000;
		var url = '?_a=shop&_u=sp.order_address_excel';
//        console.log(start_time);//order_record_excel

		if(start_time!=undefined) url+='&start_time='+start_time;
		if(end_time!=undefined) url+='&end_time='+end_time;
		if(status!=undefined) url+='&status='+status;

		window.location.href=url;

	});

</script>
