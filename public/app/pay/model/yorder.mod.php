<?php
/*
	y类订单 财富宝订单
*/

class YOrderMod {
	public function __construct($uid) {
		uct_use_app('caifubao');
		if(!($this->o = CaifubaoMod::get_cfb_ticket_by_uid($uid))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
		}
		else {
		//支付成功 注意不要重复添加事件
		//Event::addHandlerOnce('AfterPayOrder', array('OrderMod', 'onAfterOrderPay'));
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
		if($this->o['status'] != CaifubaoMod::CFB_TICKET_INIT) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		if(empty($this->o['cfg']['baozhengjin']) || empty($this->o['price'])) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		$price = min(100000, floor($this->o['cfg']['baozhengjin'] * $this->o['price'] /10000));
		$price = CfbUserMod::get_baozhengjin_price_by_group(
								CfbUserMod::get_user_level($this->o['su_uid']));	

		#$title = '布施保证金 '.($this->o['cfg']['baozhengjin']/100).'%';
		$title = '布施保证金 ';
		$detail = '';

		return array(
					'trade_no' => 'y'.$this->o['uid'],
					'total_fee'=> $price,
					'title'    => $title,
					'detail'   => $detail,
					'su_uid' => $this->o['su_uid'],
					'sp_uid' => $this->o['sp_uid'],
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

		$price = min(100000, floor($this->o['cfg']['baozhengjin'] * $this->o['price'] /10000));
		$price = CfbUserMod::get_baozhengjin_price_by_group(
								CfbUserMod::get_user_level($this->o['su_uid']));	

		return array(
					'trade_no' => 'y'.$this->o['uid'],
					'status'   => $this->o['status'] == CaifubaoMod::CFB_TICKET_INIT ? 
								SpServiceMod::ORDER_WAIT_USER_PAY : SpServiceMod::ORDER_WAIT_FOR_DELIVERY,
					'create_time' => $this->o['create_time'],
					'paid_time' => $this->o['paid_time'],
					'total_fee'=> $price,
					#'title'    => '布施保证金 '.($this->o['cfg']['baozhengjin']/100).'%',
					'title'    => '布施保证金 ',
					'return_url' => '?_a=caifubao&_u=index.paidan',
					'pay_type' => !empty($this->o['cfg']['pay_type']) ? $this->o['cfg']['pay_type'] : 0,
					'pay_info' => !empty($this->o['cfg']['pay_info']) ? $this->o['cfg']['pay_info'] :array(),
					'su_uid' => $this->o['su_uid'],
					'sp_uid' => $this->o['sp_uid'],
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

		if(empty($this->o['cfg'])) $this->o['cfg'] = array();
		$cfg = array_merge($this->o['cfg'], array('pay_type' => $params['pay_type'],
							'pay_info' => $params['pay_info']));
		$update = array('uid' => $this->o['uid'],
						'sp_uid' => $this->o['sp_uid'],
						'cfg' => $cfg,
		);

		return CaifubaoMod::add_or_edit_cfb_ticket($update);
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
		if($this->o['status'] != CaifubaoMod::CFB_TICKET_INIT) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		if(empty($this->o['cfg'])) $this->o['cfg'] = array();
		$cfg = array_merge($this->o['cfg'], array('pay_type' => $params['pay_type'],
							'pay_info' => $params['pay_info']));
		$update = array('uid' => $this->o['uid'],
						'sp_uid' => $this->o['sp_uid'],
						'status' => CaifubaoMod::CFB_TICKET_PAID, //已付款,待发货
						'paid_time' => isset($params['paid_time']) ? $params['paid_time'] :$_SERVER['REQUEST_TIME'],
						'cfg' => $cfg,
					);
		
		//把保证金加回到余额 打款结束后再释放
		Dba::beginTransaction(); {
			CaifubaoMod::add_or_edit_cfb_ticket($update);
		} Dba::commit();

		return true;
	}

}

