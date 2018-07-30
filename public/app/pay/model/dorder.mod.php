<?php
/*
	d类订单 表单订单
*/

class DOrderMod {
	public function __construct($uid) {
		uct_use_app('form');
		if(!($this->r = FormMod::get_form_record_by_uid($uid)) ||
			empty($this->r['order']) ||
			!($this->f = FormMod::get_form_by_uid($this->r['f_uid']))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			$this->f = false;
		}
		//表单支付成功 注意不要重复添加事件
		Event::addHandlerOnce('AfterFormRecordOrderPay', array('FormMod', 'onAfterFormRecordOrderPay'));
	}

	/*
		获取订单信息, 必须为待支付状态
		todo 是否还要检查一下商户登陆权限
	
		return array(
					'trade_no' => 订单号 axxxxxx
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
		if(!$this->r || !$this->f) {
			return false;
		}
		if($this->r['order']['paid_time'] > 0) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		return array(
					'trade_no' => 'd'.$this->r['uid'],
					'total_fee'=> $this->r['order']['paid_fee'],
					'title'    => $this->f['title'],
					'detail'   => $this->f['brief'],
					'product_uid' => $this->r['uid'],

					'sp_uid' => $this->f['sp_uid'],
					'su_uid' => $this->r['su_uid'],
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
		if(!$this->r || !$this->f) {
			return false;
		}
		return array(
					'trade_no' => 'd'.$this->r['uid'],
					'status'   => $this->r['order']['paid_time'] > 0 ? SpServiceMod::ORDER_DELIVERY_OK : SpServiceMod::ORDER_WAIT_USER_PAY,
					'create_time' => $this->r['create_time'],
					'paid_time' => $this->r['order']['paid_time'],
					'total_fee'=> $this->r['order']['paid_fee'],
					'title'    => $this->f['title'],
					'return_url' => '?_a=form&_u=index.index&r_uid='.$this->r['uid'].'&f_uid='.$this->r['f_uid'],
					'pay_type' => $this->r['order']['pay_type'],			
					'pay_info' => $this->r['order']['pay_info'],	
					'sp_uid' => $this->f['sp_uid'],
					'su_uid' => $this->r['su_uid'],
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
		if(!$this->r) {
			return false;
		}

		$update = array('r_uid' => $this->r['uid'],
						'pay_type' => $params['pay_type'],
						'pay_info' => $params['pay_info'],
		);

		return Dba::update('form_record_order', $update, 'r_uid = '.$this->r['uid']);
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
		if(!$this->r) {
			return false;
		}
		if($this->r['order']['paid_time'] > 0) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		$update = array('r_uid' => $this->r['uid'],
						'pay_type' => $params['pay_type'],
						'paid_time' => isset($params['paid_time']) ? $params['paid_time'] :$_SERVER['REQUEST_TIME'],
						'pay_info' => $params['pay_info'],
					);
		
		Dba::beginTransaction(); {
			Dba::update('form_record_order', $update, 'r_uid = '.$this->r['uid']);
			//付款成功, , todo 通知管理员
			Event::handle('AfterFormRecordOrderPay', array($this->f, FormMod::get_form_record_by_uid($this->r['uid'])));
		} Dba::commit();
		return true;
	}

}

