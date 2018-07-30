<?php
/*
	b类订单 商城订单
*/

class BOrderMod {
	public function __construct($uid) {
		uct_use_app('shop');
		if(!($this->o = OrderMod::get_order_by_uid($uid))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
		}
		else {
		$this->o['sp_uid'] = Dba::readOne('select sp_uid from shop where uid = '.$this->o['shop_uid']);

		//支付成功 注意不要重复添加事件
		Event::addHandlerOnce('AfterPayOrder', array('OrderMod', 'onAfterOrderPay'));
		}
	}

	/*
		获取订单信息, 必须为待支付状态
	
		return array(
					'trade_no' => 订单号 axxxxxx
					'total_fee'=> 费用
					'title'    => 支付名称
					'detail'   => 支付详情

					'sp_uid' => 商户uid
					'su_uid' => 用户uid, 如果sp_uid=0那么su_uid表示商户uid

					'product_uid' => 商品uid, 可选
					'expire'  => 订单过期时间(秒), 可选
		)
	*/
	public function PreparePayInfo() {
		if(!$this->o) {
			return false;
		}
		if($this->o['status'] != OrderMod::ORDER_WAIT_USER_PAY) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		$title = '';
		$detail = '';
		foreach($this->o['products'] as $p) {
			$title .= $p['title'].' ';
			$detail .= $p['title'].'['.$p['quantity'].'] ';
		}

		return array(
					'trade_no' => 'b'.$this->o['uid'],
					'total_fee'=> $this->o['paid_fee'],
					//'title'    => $title,
					'title'    => str_replace(array('（', '）', ' '), array('', '', ''),
						$title),
					'detail'   => $detail,
					'su_uid' => $this->o['user_id'],
					'sp_uid' => Dba::readOne('select sp_uid from shop where uid = '.$this->o['shop_uid']),
					);
	}

	/*
		获取订单信息, 包括状态和支付信息
		return array(
					'status' => 订单状态
					'create_time' => 下单时间
					'paid_time' => 支付时间
					'return_url' => 支付完返回地址,通常是订单详情页

					'pay_type' => 支付类型
					'pay_info' => 支付信息

					'sp_uid' => 商户uid
					'su_uid' => 用户uid, 如果sp_uid=0那么su_uid表示商户uid
	*/
	public function GetOrderInfo() {
		if(!$this->o) {
			return false;
		}
		return array(
					'trade_no' => 'b'.$this->o['uid'],
					'status'   => $this->o['status'],
					'create_time' => $this->o['create_time'],
					'paid_time' => $this->o['paid_time'],
					'total_fee'=> $this->o['paid_fee'],
					//'title'    => implode(' ', array_column($this->o['products'], 'title')),
					'title'    => str_replace(array('（', '）', ' '), array('', '', ''),
						implode(' ', array_column($this->o['products'], 'title'))),
					'return_url' => '?_a=shop&_u=index.orderdetail&uid='.$this->o['uid'],
					'pay_type' => $this->o['pay_type'],			
					'pay_info' => $this->o['pay_info'],	
					'su_uid' => $this->o['user_id'],
					'sp_uid' => Dba::readOne('select sp_uid from shop where uid = '.$this->o['shop_uid']),
					);
	}

	/*
		发出了支付请求, 返回一些支付信息如prepay_id等, 保存一下
		$params = array(
						'pay_type' => 
						'pay_info' => 
		)
	*/
	public function SavePayInfo($params) {
		if(!$this->o) {
			return false;
		}

		$update = array('uid' => $this->o['uid'],
						'pay_type' => $params['pay_type'],
						'pay_info' => $params['pay_info'],
		);
		return OrderMod::edit_order($update);
	}

	/*
		支付成功回调
	
		$params = array(
						'pay_type' => 
						'pay_info' => 

						'paid_time' =>  //支付时间 可选
		)
		
	*/
	public function PaySucceedCallback($params) {
		if(!$this->o) {
			return false;
		}
		if($this->o['status'] != OrderMod::ORDER_WAIT_USER_PAY) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		$order = OrderMod::get_order_by_uid($this->o['uid']);
		
		if(isset($order['pay_info']['prepay_id'])){
			$params['pay_info']['prepay_id'] = $order['pay_info']['prepay_id'];
		}

		$update = array('uid' => $this->o['uid'],
						'status' => OrderMod::ORDER_WAIT_FOR_DELIVERY, //已付款,待发货
						'pay_type' => $params['pay_type'],
						'paid_time' => isset($params['paid_time']) ? $params['paid_time'] :$_SERVER['REQUEST_TIME'],
						'pay_info' => $params['pay_info'],
					);
		
		Dba::beginTransaction(); {
			OrderMod::edit_order($update);
			Event::handle('AfterPayOrder', array(OrderMod::get_order_by_uid($this->o['uid'])));
		} Dba::commit();
		return true;
	}

}

