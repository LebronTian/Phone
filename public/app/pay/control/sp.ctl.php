<?php

class SpCtl {
	/*
		获取左侧菜单项
	*/
	public function get_menu_array() {
		/*
			activeurl 确定是否为选中状态
		*/
		return array(
			array('name' => '介绍说明', 'icon' => 'am-icon-home', 'link' => '?_a=pay&_u=sp', 'activeurl' => 'sp.index'),
			array('name' => '用户提现', 'icon' => 'am-icon-rmb', 'menus' => array(
				array('name' => '设置', 'icon' => 'am-icon-gear', 'link' => '?_a=pay&_u=sp.withdraw', 
						'activeurl' => 'sp.withdraw'),
				array('name' => '提现记录', 'icon' => 'am-icon-list', 'link' => '?_a=pay&_u=sp.withdrawlist',
						'activeurl' => 'sp.withdrawlist'),
				)),
			/*
			array('name' => '平台代收', 'icon' => 'am-icon-dollar', 'menus' => array(
				array('name' => '设置', 'icon' => 'am-icon-gear', 'link' => '?_a=pay&_u=sp.uctpay', 
						'activeurl' => 'sp.uctpay'),
				array('name' => '收款记录', 'icon' => 'am-icon-list', 'link' => '?_a=pay&_u=sp.uctpaylist',
						'activeurl' => 'sp.uctpaylist'),
				array('name' => '提现', 'icon' => 'am-icon-money', 'link' => '?_a=pay&_u=sp.transfer',
						'activeurl' => 'sp.transfer'),
				)),
			*/
			array('name' => '余额支付', 'icon' => 'am-icon-credit-card', 'menus' => array(
				array('name' => '设置', 'icon' => 'am-icon-gear', 'link' => '?_a=pay&_u=sp.balancepay', 
						'activeurl' => 'sp.balancepay'),
				array('name' => '全部用户', 'icon' => 'am-icon-list', 'link' => '?_a=pay&_u=sp.balanceuserlist',
						'activeurl' => 'sp.balanceuserlist'),
				#array('name' => '充值/提现', 'icon' => 'am-icon-flash', 'link' => '?_a=pay&_u=sp.balanceuser',
				#		'activeurl' => 'sp.balanceuser'),
				)),
			#array('name' => '微信支付', 'icon' => 'am-icon-weixin', 'link' => '?_a=pay&_u=sp.weixinpay', 'activeurl' => 'sp.weixinpay'),
			array('name' => '支付宝', 'icon' => 'am-icon-shield', 'link' => '?_a=pay&_u=sp.alipay', 'activeurl' => 'sp.alipay'),
			array('name' => '测试支付', 'icon' => 'am-icon-bug', 'link' => '?_a=pay&_u=sp.testpay', 'activeurl' => 'sp.testpay'),
			array('name' => '退款设置', 'icon' => 'am-icon-gear', 'link' => '?_a=pay&_u=sp.set_refund', 'activeurl' => 'sp.set_refund'),
		);
	}

	protected function sp_render($params = array()) {
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index() {
		$this->sp_render();
	}

	/*
		设置微信支付参数
	*/
	public function weixinpay() {
		$cfg = PayMod::get_sp_weixinpay_cfg(AccountMod::get_current_service_provider('uid'));

		//如果启用了uct代收款
		if(PayMod::is_sp_uctpay_available(AccountMod::get_current_service_provider('uid'))) {
			$cfg = array();
		}
		$params = array('cfg' => $cfg);
		$this->sp_render($params);
	}

	/*
		设置小程序支付参数
	*/
	public function xiaochengxupay() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($public_uid = requestInt('uid')) || 
		  !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
		  $public['sp_uid'] != $sp_uid) {
			$public = Dba::readRowAssoc('select * from weixin_public where sp_uid = '.$sp_uid.
							' && public_type & 8 = 8', 'WeixinMod::func_get_weixin');	
		}

		if(!$public) {
			header('Content-Type: text/html; charset=utf-8');
			echo '您还未添加小程序！无法进行设置!';exit;
		}

		$cfg = PayMod::get_sp_xiaochengxupay_cfg($public['uid']);

		$params = array('cfg' => $cfg, 'public' => $public);
		$this->sp_render($params);
	}

	/*
		设置支付宝参数
	*/
	public function alipay() {
		$cfg = PayMod::get_sp_alipay_cfg(AccountMod::get_current_service_provider('uid'));

		if(PayMod::is_sp_uctpay_available(AccountMod::get_current_service_provider('uid'))) {
			$cfg = array();
		}
		$params = array('cfg' => $cfg);
		$this->sp_render($params);
	}

	public function testpay() {
		$cfg = PayMod::get_sp_testpay_cfg(AccountMod::get_current_service_provider('uid'));
		$params = array('cfg' => $cfg);
		$this->sp_render($params);
	}

	/*
		余额支付
	*/
	public function balancepay() {
		$cfg = PayMod::get_sp_balancepay_cfg(AccountMod::get_current_service_provider('uid'));
		$params = array('cfg' => $cfg);
		$this->sp_render($params);
	}

	public function uctpay() {
		$cfg = PayMod::get_sp_uctpay_cfg(AccountMod::get_current_service_provider('uid'));
		$params = array('cfg' => $cfg);
		$this->sp_render($params);
	}

	public function uctpaylist() {
		$option['type'] = requestInt('type');
		$option['page'] = requestInt('page', 0);
		$option['limit'] = requestInt('limit', 10);
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$data = UctpayMod::get_uctpay_cash_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=pay&_u=sp.uctpaylist&type='.$option['type'].'&limit='.$option['limit'].'&page=');

		$cfg = PayMod::get_sp_uctpay_cfg(AccountMod::get_current_service_provider('uid'));

		$params = array('cfg' => $cfg, 'option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		uct代收款提现
	*/
	public function transfer() {
		$cfg = PayMod::get_sp_uctpay_cfg(AccountMod::get_current_service_provider('uid'));

		$params = array('cfg' => $cfg);
		$this->sp_render($params);
	}

	/*
		所有用户余额列表
	*/
	public function balanceuserlist() {
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['key']    = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']   = requestInt('page');
		$option['limit']  = requestInt('limit', 10);
		$option['sort']   =  requestInt('sort');

		uct_use_app('su');
		$users = SuChargeMod::get_balance_user_list($option);
		$pagination = uct_pagination($option['page'], ceil($users['count'] / $option['limit']),
			'?_a=pay&_u=sp.balanceuserlist&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('option' => $option,
						'users' => $users,
						'pagination' => $pagination,
				);
		$this->sp_render($params);
	}

	/*
		用户余额充值或提现
	*/
	public function balanceuser() {
		if(!($su_uid = requestInt('uid')) ||
			!($su = AccountMod::get_service_user_by_uid($su_uid)) ||
			$su['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
			redirectTo('?_a=pay&_u=sp.balanceuserlist');
		}
		uct_use_app('su');
		$point = SuPointMod::get_user_points_by_su_uid($su_uid);

		//1 提现， 2 充值
		$type = requestInt('type', 1); 
		
		$params = array('su' => $su, 'type' => $type, 'point' => $point);
		$this->sp_render($params);
	}

	public function withdraw() {
		$wd = WithdrawMod::get_sp_withdraw(AccountMod::get_current_service_provider('uid'));
		$params = array('wd' => $wd);
		$this->sp_render($params);
	}

	public function withdrawlist() {
		$option['wd_type'] = requestInt('wd_type');
		$option['page'] = requestInt('page', 0);
		$option['limit'] = requestInt('limit', 10);
		$option['status'] = requestInt('status', -1);
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$data = WithdrawMod::get_sp_user_withdraw_record_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=pay&_u=sp.withdrawlist&wd_type='.$option['wd_type'].'&limit='.$option['limit'].'&page=');

		$wd = WithdrawMod::get_sp_withdraw(AccountMod::get_current_service_provider('uid'));

		$params = array('wd' => $wd, 'option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
    退款设置
	*/
	public function set_refund() {
		$cfg = PayMod::get_sp_refund_cfg(AccountMod::get_current_service_provider('uid'));
//		var_dump($cfg);
		$params = array('cfg' => $cfg);
		$this->sp_render($params);
	}


}


