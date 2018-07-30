<?php
/*
	h类订单 用户捐赠打赏
*/

class HOrderMod {
	public function __construct($uid) {
		uct_use_app('donate');
		if(!($this->o = DonateOrderMod::get_donate_order_by_uid($uid))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
		}

		//系统支付成功 注意不要重复添加事件
		Event::addHandlerOnce('AfterDonateOrderPay', array('DonateOrderMod', 'onAfterDonateOrderPay'));
	}

	/*
		获取订单信息, 必须为待支付状态
		todo 是否还要检查一下商户登陆权限
	
		return array(
					'trade_no' => 订单号 hxxxxxx
					'total_fee'=> 费用
					'title'    => 支付名称
					'detail'   => 支付详情

					'sp_uid' => 商户uid         这2个参数主要用于选择不同商户的支付参数
					'su_uid' => 用户uid, 如果sp_uid=0那么su_uid表示商户uid

					'product_uid' => 商品uid, 可选
					'expire'  => 订单过期时间(秒), 可选
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

		return array(
					'trade_no' => 'h'.$this->o['uid'],
					'total_fee'=> $this->o['paid_fee'],
					'title'    => '捐赠'.($this->o['paid_fee']/100).'元',
					'detail'   => (!empty($this->o['donate_info']['title']) ? $this->o['donate_info']['title'] : ' ')
									.'捐赠'.($this->o['paid_fee']/100).'元',
					'product_uid' => $this->o['donate_uid'],

					'sp_uid' => $this->o['sp_uid'],
					'su_uid' => $this->o['su_uid'],
					);
	}

	/*
		获取订单信息, 包括状态和支付信息
		return array(
					'status' => 订单状态
					'create_time' => 下单时间
					'create_time' => 支付时间
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
					'trade_no' => 'h'.$this->o['uid'],
					'status'   => $this->o['status'],
					'create_time' => $this->o['create_time'],
					'paid_time' => $this->o['paid_time'],
					'total_fee'=> $this->o['paid_fee'],
					'title'    => '捐赠'.($this->o['paid_fee']/100).'元',
					'return_url' => '?_a=donate&_u=index.donatedetail&uid='.$this->o['uid'],
					'pay_type' => $this->o['pay_type'],			
					'pay_info' => $this->o['pay_info'],	
					'sp_uid' => $this->o['sp_uid'],
					'su_uid' => $this->o['su_uid'],
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
		return DonateOrderMod::make_a_donate_order($update);
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
						'status' => SpServiceMod::ORDER_WAIT_FOR_DELIVERY, //服务订单标记订单为等待发货
						'pay_type' => $params['pay_type'],
						'paid_time' => isset($params['paid_time']) ? $params['paid_time'] :$_SERVER['REQUEST_TIME'],
						'pay_info' => $params['pay_info'],
					);
		
		Dba::beginTransaction(); {
			DonateOrderMod::make_a_donate_order($update);
			//付款成功
			Event::handle('AfterDonateOrderPay', array(DonateOrderMod::get_donate_order_by_uid($this->o['uid'])));
		} Dba::commit();
		return true;
	}

}

