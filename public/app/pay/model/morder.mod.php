<?php
/*
	m类订单 分类信息
*/

class MOrderMod {
	public function __construct($uid) {
		uct_use_app('classmsg');
		if(!($this->a = ClassmsgMod::get_classmsg_by_uid($uid))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
		}
		$this->b = ClassmsgMod::get_classmsg_cat_by_uid($this->a['cat_uid']);

		//表单支付成功 注意不要重复添加事件
		Event::addHandlerOnce('AfterClassMsgOrderPay', array('ClassmsgMod', 'onAfterClassMsgOrderPay'));
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
		if(!$this->a) {
			return false;
		}
		if($this->a['paid_time'] > 0) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		if(empty($this->b)){
			$this->b['paid_fee'] = 0;
		}

		return array(
					'trade_no' => 'm'.$this->a['uid'],
					'total_fee'=> $this->a['else_info']['paid_fee']+$this->b['paid_fee'],
					'title'    => '分类信息',#$this->a['title'],
					'detail'   => 'mm',#$this->a['brief'],
					'sp_uid' => $this->a['sp_uid'],
					'su_uid' => $this->a['su_uid'],
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
		if(!$this->a) {
			return false;
		}
		if(empty($this->b)){
			$this->b['paid_fee'] = 0;
		}
		return array(
					'trade_no' => 'a'.$this->a['uid'],
					'status'   => $this->a['paid_time'] > 0 ? SpServiceMod::ORDER_DELIVERY_OK : SpServiceMod::ORDER_WAIT_USER_PAY,
					'create_time' => $this->a['create_time'],
					'paid_time' => $this->a['paid_time'],
					'total_fee'=> $this->a['else_info']['paid_fee']+$this->b['paid_fee'],
					'title'    => $this->a['title'],
					'return_url' => '',
					'sp_uid' => $this->a['sp_uid'],
					'su_uid' => $this->a['su_uid'],
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
		if(!$this->a) {
			return false;
		}

		$update = array('a_uid' => $this->a['uid'],
						'pay_type' => $params['pay_type'],
						'pay_info' => $params['pay_info'],
		);

		return 1;
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
		if(!$this->a) {
			return false;
		}
		if($this->a['paid_time'] > 0) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		$paid_time = isset($params['paid_time']) ? $params['paid_time'] :$_SERVER['REQUEST_TIME'];
		$top_time = $paid_time+($this->a['else_info']['days'])*86400;
		$update = array('paid_time' => $paid_time,
						'top_time' => $top_time
					);
		
		Dba::beginTransaction(); {
			Dba::update('classmsg', $update, 'uid = '.$this->a['uid']);
			//付款成功, , todo 通知管理员
			Event::handle('AfterClassMsgOrderPay', array(ClassmsgMod::get_classmsg_by_uid($this->a['uid'])));
		} Dba::commit();
		return true;
	}

}

