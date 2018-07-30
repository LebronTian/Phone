<?php
/*
	f类订单 微信车票订单
*/

class FOrderMod {
	public function __construct($uid) {
		uct_use_app('ticket');
		if(!($this->o = TicketOrderMod::get_ticket_provider_order_by_uid($uid))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
		}
		else {
		$this->o['sp_uid'] = Dba::readOne('select sp_uid from ticket_provider where uid = '.$this->o['tp_uid']);

		//支付成功 注意不要重复添加事件
		Event::addHandlerOnce('AfterPayTicketOrder', array('TicketOrderMod', 'onAfterTicketOrderPay'));
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

		)
	*/
	public function PreparePayInfo() {
		if(!$this->o) {
			return false;
		}
		if($this->o['status'] != SpServiceMod::ORDER_WAIT_USER_PAY) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		$title = $this->o['line_info']['src_station'].'-'.$this->o['line_info']['dst_station'].' X ['.$this->o['quantity'].']';
		$detail = '发车时间： '.date('Y-m-d H:i:s', $this->o['line_info']['start_time']);

		return array(
					'trade_no' => 'f'.$this->o['uid'],
					'total_fee'=> $this->o['paid_fee'],
					'title'    => $title,
					'detail'   => $detail,
					'su_uid' => $this->o['user_id'],
					'sp_uid' => Dba::readOne('select sp_uid from ticket_provider where uid = '.$this->o['tp_uid']),
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
		$title = $this->o['line_info']['src_station'].'-'.$this->o['line_info']['dst_station'].' X ['.$this->o['quantity'].']';
		return array(
					'trade_no' => 'f'.$this->o['uid'],
					'status'   => $this->o['status'],
					'create_time' => $this->o['create_time'],
					'paid_time' => $this->o['paid_time'],
					'total_fee'=> $this->o['paid_fee'],
					'title' => $title,
					'return_url' => '?_a=ticket&_u=index.orderdetail&uid='.$this->o['uid'],
					'pay_type' => $this->o['pay_type'],			
					'pay_info' => $this->o['pay_info'],	
					'su_uid' => $this->o['user_id'],
					'sp_uid' => Dba::readOne('select sp_uid from ticket_provider where uid = '.$this->o['tp_uid']),
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
		return TicketOrderMod::edit_order($update);
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
		if($this->o['status'] != SpServiceMod::ORDER_WAIT_USER_PAY) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		$update = array('uid' => $this->o['uid'],
						'status' => SpServiceMod::ORDER_WAIT_FOR_DELIVERY, //已付款,待发车
						'pay_type' => $params['pay_type'],
						'paid_time' => isset($params['paid_time']) ? $params['paid_time'] :$_SERVER['REQUEST_TIME'],
						'pay_info' => $params['pay_info'],
					);
		
		Dba::beginTransaction(); {
			TicketOrderMod::edit_order($update);
			Event::handle('AfterPayTicketOrder', array(TicketOrderMod::get_ticket_provider_order_by_uid($this->o['uid'])));
		} Dba::commit();
		return true;
	}

}

