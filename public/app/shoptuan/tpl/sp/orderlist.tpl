<style>
.zhicwl-bdan-img{
margin-bottom:10px;
margin-left:5px;
}
</style>
		<!--面包削导航位置-->
		<div class="zhicwl-mib-nav">
			<ul>
				<li><a href="?_a=shop&_u=sp.orderlist">全部订单</a></li>
				<li><a href="?_a=shop&_u=sp.orderlist&isnormal=1">普通订单</a></li>
				<li class="on"><a href="?_a=shoptuan&_u=sp.orderlist">拼团订单</a></li>
				<li><a href="?_a=shopdist&_u=sp.orderlist">分销订单</a></li>
				<li><a href="?_a=qrposter&_u=sp.orderlist">积分订单</a></li>
			</ul>
		</div>
		<!--/面包削导航位置-->
		
		<div class="zhicwl-damr">
			
			<div class="zhicwl-damr-left">
				<!--下拉选择组件-->
				<div class="zhicwl-damr-left zhiclw-llcj">
					<h5>所有订单</h5>
					<ul style="display: none;">
						<li>所有订单</li>
						<li>普通订单</li>
						<li>拼团订单</li>
						<li>分销订单</li>
						<li>积分订单</li>
					</ul>
				</div>
				<!--/下拉选择组件-->
	
				<!--时间日期选择组件-->
				<div class="zhicwl-sjcjas" style="font-size:12px;">
					<span>下单时间</span>
					<div class="zhicwl-sjcjas-input">
<!--
<input class="demo-input" placeholder="点击选择时间" readonly="" type="text" id="sj1" lay-key="1"><samp class="iconfont icon-rilicalendar107"></samp>
-->
		<button type="button" class="am-btn am-btn-default am-margin-right" id="my-start">开始日期</button>
		<span id="my-startDate"><?php echo date('Y-m-d', (empty($option['start_time']) ? strtotime(date('Y-m',time())): $option['start_time'])) ?></span>
</div>
					<span>至</span>
					<div class="zhicwl-sjcjas-input">
		<button type="button" class="am-btn am-btn-default am-margin-right" id="my-end">结束日期</button>
		<span
				id="my-endDate"><?php echo date('Y-m-d', (empty($option['end_time']) ? time() : $option['end_time'])) ?></span>
<!--
<input class="demo-input" placeholder="点击选择时间" readonly="" type="text" id="sj2" lay-key="2"><samp class="iconfont icon-rilicalendar107"></samp>
-->
</div>
					<button type="button" class="zhicwl-btn btn_show">查看</button>
				</div>
				<!--/时间日期选择组件-->
			</div>
			
			<div class="zhicwl-replab">
				<input type="text" class="zhicwl-btn2 option_key" value="<?php echo $option['key']; ?> ">
				<button type="button" class="zhicwl-btn2 option_key_btn"><span>搜索</span></button>
				<button id="download_excel" type="button" class="zhicwl-btn">数据导出</button>
			</div>
			
			<div class="clear-both"></div>
		</div>


		<!--TAB切换-->
		<div class="zhicwl-tabs">
			<div class="zhicwl-tabs-hd">
				<ul>
<?php
	$cats = array(
		array('uid' => 0,     'title' => '全部'),	
		array('uid' => OrderMod::ORDER_WAIT_USER_PAY,     'title' => '待付款'),	
		array('uid' => OrderMod::ORDER_WAIT_FOR_DELIVERY, 'title' => '待发货'),	
		array('uid' => OrderMod::ORDER_WAIT_USER_RECEIPT, 'title' => '已发货'),	
		array('uid' => OrderMod::ORDER_DELIVERY_OK,       'title' => '已完成'),	
		array('uid' => OrderMod::ORDER_CANCELED,          'title' => '已关闭'),	
		array('uid' => OrderMod::ORDER_UNDER_NEGOTATION,  'title' => '退款中'),	
	);
$html = '';
if(!isset($option['status'])) $option['status']=0;
foreach($cats as $c) {
$html .= '<a href="?_a=shoptuan&_u=sp.orderlist&status='.$c['uid'].'"><li';
if($option['status'] == $c['uid']) $html .= ' class="on"';
$html .= '>'.$c['title'].'</li></a>';
}
echo $html;
?>
					
					<div class="clear-both"></div>
				</ul>
			</div>
			
			<div class="zhicwl-tabs-bd">
				
				<!--全部-->
				<div class="zhicwltabs-setr" style="display: block;">
					
					<div class="zhicwl-bdan zhicwl-bdan1">
						<dl class="display-box box-align-center">
							<dt><input type="checkbox" class="qbxf-reverse"></dt>
							<dd class="zhicwl-bdan-datit box-flex"><span>商品</span></dd>
							<dd><span>买家信息</span></dd>
							<dd><span>下单时间</span></dd>
							<dd><span>实付金额</span></dd>
							<dd><span>订单状态</span></dd>
						</dl>
					</div>					
					
					<ul class="qbxf-list">
<?php
$html = '';
if($data['list'])
foreach($data['list'] as $o) {
$su = AccountMod::get_service_user_by_uid($o['user_id']);
$html .= '
						<li>
							<div class="zhicwl-dklspt display-box box-align-center">
								<div>订单号：'.$o['uid']; 
if($o['go_uid']) {
	$html .= ' <span class="am-btn-warning">团</span>';
	if($o['remain_cnt']) $html .= ' <small class="am-text-danger">差'.$o['remain_cnt'].'人</small>';
}
$html .= '</div>
								<div class="box-flex"></div>
								<div class="zhicwl-dklspt-rig color1"><a class="color1" href="?_a=shop&_u=sp.orderdetail&uid='.$o['uid'].'">订单详情</a>';
if(in_array($o['status'], array(SpServiceMod::ORDER_WAIT_USER_PAY, SpServiceMod::ORDER_CANCELED,))) {
$html .= ' - <span class="cdopaid" data-id="'.$o['uid'].'" data-fee="'.$o['paid_fee'].'">改价</span> - <span class="cdelete" data-id="'.$o['uid'].'">删除</span>'; 
}
if($o['status'] == SpServiceMod::ORDER_WAIT_GROUP_DONE) {
	if($o['go_uid']) {
	$html .= ' - <a class="am-text-warning cdorefundgroup" data-id="'.$o['uid'].
			'" go-id="'.$o['go_uid'].'">退团</a>';
	}
}

$html .= '</div>
							</div>
							<div class="zhicwl-bdan zhicwl-bdan2">
								<dl class="display-box box-align-center" data-id="'.$o['uid'].'">
									<dt><input type="checkbox"></dt>
									<dd class="zhicwl-bdan-datit display-box box-align-center box-flex" style="flex-wrap:wrap;-webkit-flex-wrap:wrap;-moz-flex-wrap:wrap;display:flex;">';
foreach($o['products'] as $p) {
	$html .= '
			<div class="zhicwl-bdan-img"><img style="width:64px;" src="'.$p['main_img'].'"></div>
			<div><span class="color1">'.$p['title'].'</span><br><span>x '.$p['quantity'].'</span></div>
									';
}
$html .= '</dd>
									<dd><a href="?_a=su&_u=sp.fansdetail&uid='.$o['user_id'].'" class="color1">'.($su['name'] ? $su['name'] : $su['account']).'</a><br><span>'.(@$o['address']['name']).'</span><br><span>'.(@$o['address']['phone']).'</span></dd>
									<dd>'.date('Y-m-d\<\b\r\>H-i:s', $o['create_time']).'</dd>
									<dd><span>&yen; '.($o['paid_fee']/100).'</span></dd>
									<dd>';

	switch($o['status']) {
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
$html .= '</dd>
								</dl>';
if(!empty($o['info']['remark'])) {
	$html .= '<p class="zhicwl-bdan-beiz">买家备注： '.htmlspecialchars($o['info']['remark']).'</p>';
}
$html .= '</div>							
</li>';
}
echo $html;
?>
					</ul>
					<div class="zhicwl-botsrew display-box box-align-center">
						<div class="zhicwl-shnaol"><button type="button" class="zhicwl-btn"><span>删除</span></button></div>
						<div class="box-flex"></div>
<?php echo $pagination;?>
					</div>
				</div>
				<!--/全部-->
			</div>
		</div>
		<!--/TAB切换-->
		
		<div class="iekdl" style="height:80px;"></div>

<!-- 下面是一些弹框 -->
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

<?php

	$extra_js =  array(
		  '/static/js/laydate/laydate.js',
		  '/static/js/select_group_user.js',
		  '/spv3/shop/static/js/orderlist.js',
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
