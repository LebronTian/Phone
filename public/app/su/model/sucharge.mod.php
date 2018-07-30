<?php

/*
用户余额充值
*/

class SuChargeMod {
	public static function func_get_sucharge_order($item) {
		if(!empty($item['charge'])) $item['charge'] = json_decode($item['charge'], true);
		if(!empty($item['pay_info'])) $item['pay_info'] = json_decode($item['pay_info'], true);
		
		return $item;
	}

	/*
		下订单
		$order = array(
			sp_uid
			su_uid
			paid_fee 
			charge_uid => 0
			charge => array(
				charge_price => 
				quantity => 
				uid =>
				paid_price => 
			)
			
		)
	*/
	public static function make_a_sucharge_order($order) {
		if(!empty($order['uid'])) {
			Dba::update('user_charge_order', $order, 'uid = '.$order['uid']);
		}
		else {
			unset($order['uid']);
			$order['create_time'] = $_SERVER['REQUEST_TIME'];
			!isset($order['status']) && $order['status'] = SpServiceMod::ORDER_WAIT_USER_PAY;
			Dba::insert('user_charge_order', $order);
			$order['uid'] = Dba::insertID();

			//商户下单以后事件,可以发送短信通知管理员
			Event::handle('AfterMakeSuChargeOrder', array($order));
		}

		return $order['uid'];
	}

	public static function get_sucharge_order_by_uid($uid) {
		return Dba::readRowAssoc('select * from user_charge_order where uid = '.$uid, 'SuChargeMod::func_get_sucharge_order');
	}

	/*
		订单列表 
	*/
	public static function get_sucharge_order_list($option) {
		$sql = 'select * from user_charge_order';	
			    
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(!empty($option['su_uid'])) {
			$where_arr[] = 'su_uid = '.$option['su_uid'];
		}
		if(!empty($option['status'])) {
			$where_arr[] = 'status = '.$option['status'];
		}
		if(!empty($option['key'])) { //搜索订单号 和 服务名称
			$where_arr[] = '(uid = "'.addslashes($option['key']).'"  || charge like "%'.
							addslashes(trim(str_replace(array('\\u'), array('\\\\u'),json_encode($option['key'])), '"')).'%")';
		}
		
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		empty($option['sort']) && $option['sort'] = SORT_CREATE_TIME;
		switch($option['sort']) {
			default:
				$sort = 'create_time desc';
		}
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SuChargeMod::func_get_sucharge_order');
	}

	/*
		取消订单

		只有在待付款的订单能取消
	*/
	public static function do_cancel_order($o) {
		if(!in_array($o['status'], array(SpServiceMod::ORDER_WAIT_USER_PAY,
										))) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		$update = array(
			'uid' => $o['uid'],
			'status' => SpServiceMod::ORDER_CANCELED,
		);
		self::make_a_sucharge_order($update);

		return true;
	}

	/*
		删除订单

		只有已取消的和未付款的订单可以删除
	*/
	public static function delete_order($o) {
		if(!in_array($o['status'], array(SpServiceMod::ORDER_CANCELED, SpServiceMod::ORDER_WAIT_USER_PAY))) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		$sql = 'delete from user_charge_order where uid = '.$o['uid'];
		Dba::write($sql);
		return true;
	}
	
	/*
		充值订单支付 
	*/
	public static function onAfterSuChargeOrderPay($o) {
		if(is_numeric($o)) {
			$o = self::get_sucharge_order_by_uid($o);
		}
		if(!$o) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		if($o['status'] != SpServiceMod::ORDER_WAIT_FOR_DELIVERY) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		if(!Dba::write('update user_charge_order set status = '.SpServiceMod::ORDER_DELIVERY_OK.' where uid = '.$o['uid']
					.' && status = '.SpServiceMod::ORDER_WAIT_FOR_DELIVERY)) {
			setLastError(ERROR_DB_CHANGED_BY_OTHERS);
			return false;
		}

		//充值满送
		$rule = SuPointMod::get_cash_rule($o['sp_uid']);
		if((!empty($rule))&&$rule['status'] == 1){
			$om_cash = 0;//现分组对应充值金额
			$m_cash = 0;
			$r_cash = 0;
			$u_group = 0;
			//用户旧分组
			$o_group = SuGroupMod::get_user_group($o['su_uid']);
			foreach($rule['rule'] as $v => $r){
				if(($o['charge']['charge_price']>=$r[0])&&(empty($m_cash)||$r[0]>$m_cash)){
					$m_cash = $r[0];
					$r_cash = $r[1];
					$u_group = $r[2];
				}
				if($r[2] == $o_group){
					$om_cash = $r[0];
				}
			}
			//余额充值/购买会员 赠送金额
			$r_record = array(
				'su_uid' => $o['su_uid'],
				'cash' => $r_cash * $o['charge']['quantity'],
				'info' => '充值满'.sprintf("%.2f", $m_cash/100).'送'.sprintf("%.2f", $r_cash/100),
			);
			if(!empty($r_cash)){
				SuPointMod::increase_user_cash($r_record);
			}

			if((!empty($u_group))&&(!empty($o['charge']['pay_vip']))){
				//为用户切换分组
				if((empty($o_group))||((!empty($rule['cgroup']))&&($m_cash>$om_cash))){
					return SuGroupMod::move_user_to_group($o['su_uid'], $u_group, $o['sp_uid']);
				}
				return false;
			}

		}

		//余额充值
		$record = array(
			'su_uid' => $o['su_uid'],
			'cash' => $o['charge']['charge_price'] * $o['charge']['quantity'],
			'info' => '余额充值 #'.$o['uid'],
		);
		return SuPointMod::increase_user_cash($record);
	}

	/*
		取用户余额列表
	*/
	public static function get_balance_user_list($option) {
		$sql = 'select uid, account, name, avatar, ifnull(user_points.cash_remain, 0) as cash_remain, service_user.create_time as create_time from service_user';
		$sql .= ' left join user_points on service_user.uid = user_points.su_uid';

		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'service_user.sp_uid='.$option['sp_uid'];
		}
		if(!empty($option['key'])) {
			$where_arr[] = '(service_user.name like "%'.addslashes($option['key']).'%" || service_user.account like "&'.
							addslashes($option['key']).'&")';
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' && ', $where_arr);
		}
		$sql .= ' order by cash_remain desc, uid desc';

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit']);
	}

}

