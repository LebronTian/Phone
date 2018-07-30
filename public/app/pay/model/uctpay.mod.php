<?php
/*
	
	uct代收款

*/

class UctpayMod {
	const UCTPAY_CASH_DECREASE = 1; //代收款提现
	const UCTPAY_CASH_INCREASE = 2; //代收款收入

	public static function func_get_uctpay($item) {
		unset($item['passwd']);
		if($item['transfer_info']) $item['transfer_info'] = json_decode($item['transfer_info'], true);
		return $item;
	}

	public static function func_get_uctpay_cash_record($item) {
		if($item['info']) $item['info'] = htmlspecialchars($item['info']);
		return $item;
	}

	public static function get_uctpay_by_sp_uid($sp_uid) {
		return Dba::readRowAssoc('select * from uctpay where sp_uid = '.$sp_uid, 'UctpayMod::func_get_uctpay');
	}

	public static function add_or_edit_uctpay($uctpay) {
		if(Dba::readOne('select sp_uid from uctpay where sp_uid = '.$uctpay['sp_uid'])) {
			Dba::update('uctpay', $uctpay, 'sp_uid = '.$uctpay['sp_uid']);
		}
		else {
			!isset($uctpay['create_time']) && $uctpay['create_time'] = $_SERVER['REQUEST_TIME'];	
			Dba::insert('uctpay', $uctpay);
		}		

		return $uctpay;
	}

	/*
		增加商户收入
		$record = array(		
			'sp_uid' => 
			'cash' => 
			'info' => 
			'create_time' =>  选填
		)
	*/
	public static function increase_uctpay_cash($record) {	
		do{
			if(!($uctpay = self::get_uctpay_by_sp_uid($record['sp_uid']))) {
				setLastError(ERROR_OBJ_NOT_EXIST);
				return false;
			}
			$sql = 'update uctpay set cash_remain = cash_remain + '.$record['cash'].' where sp_uid = '.$record['sp_uid'].
					' && cash_remain = '.$uctpay['cash_remain'];
		} while(!Dba::write($sql));

		$record['type'] = UctpayMod::UCTPAY_CASH_INCREASE;
		if(empty($record['create_time'])) $record['create_time'] = $_SERVER['REQUEST_TIME'];
		$record['cash_remain'] = $uctpay['cash_remain'] + $record['cash'];

		Dba::insert('uctpay_cash_record', $record);
		return Dba::insertID();
	}

	/*
		商户提现
		$record = array(		
			'sp_uid' => 
			'cash' => 
			'info' => 
		)
	*/
	public static function decrease_uctpay_cash($record) {	
		do{
			$uctpay = self::get_uctpay_by_sp_uid($record['sp_uid']);
			if($uctpay['cash_remain'] < $record['cash']) {
				setLastError(ERROR_INVALID_REQUEST_PARAM);
				return false;
			}
			$sql = 'update uctpay set cash_remain = cash_remain - '.$record['cash'].', cash_transfered = cash_transfered + '
					.$record['cash'].' where sp_uid = '.$record['sp_uid'].' && cash_transfered = '.$uctpay['cash_transfered']
					.' && cash_remain = '.$uctpay['cash_remain'];
		} while(!Dba::write($sql));

		$record['type'] = UctpayMod::UCTPAY_CASH_DECREASE;
		$record['sp_uid'] = $uctpay['sp_uid'];
		if(empty($record['create_time'])) $record['create_time'] = $_SERVER['REQUEST_TIME'];
		$record['cash_remain'] = $uctpay['cash_remain'] - $record['cash'];

		Dba::insert('uctpay_cash_record', $record);
		return Dba::insertID();
	}

	/*
		获取商户收支明细
	*/
	public static function get_uctpay_cash_list($option) {
		$sql = 'select * from uctpay_cash_record';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(!empty($option['type'])) {
			$where_arr[] = 'type= '.$option['type'];
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sort = 'create_time desc';
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'UctpayMod::func_get_uctpay_cash_record');
	}

	/*
		取当前登录商户的手机号码

		如果注册时没用手机号码，试着取profile中的手机号码，这种账号可能有安全风险
	*/
	public static function get_current_phone() {
		$phone = AccountMod::get_current_service_provider('account');
		if(checkString($phone, PATTERN_MOBILE)) {
			return $phone;
		}
		$phone = Dba::readOne('select phone from service_provider_profile where uid = '.AccountMod::get_current_service_provider('uid'));
		if(checkString($phone, PATTERN_MOBILE)) {
			return $phone;
		}

		return false;
	}

	/*
		转账提现
	*/
	public static function do_transfer($cash, $sp_uid) {
		$cfg = PayMod::is_sp_uctpay_available($sp_uid);
		if(!$cfg || empty($cfg['transfer_info']['open_id'])) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}

		$su_uid = Dba::readOne('select su_uid from weixin_fans where open_id = "'.addslashes($cfg['transfer_info']['open_id']).'"');
		$user = Dba::readRowAssoc('select uid, name, avatar from service_user where uid = '.$su_uid);
		$record = array('cash' => $cash, 'sp_uid' => $sp_uid, 
						'info' => '自助提现 '.$user['name'].' ('.$cfg['transfer_info']['open_id'].')');

		Dba::beginTransaction(); {
			if(!$uid = UctpayMod::decrease_uctpay_cash($record)) {
				Dba::rollback();
				return false;
			}

			//提现使用企业付款
			$option = array(
							'trade_no' => 'za'.$uid,
							'openid' => $cfg['transfer_info']['open_id'],
							'amount' => $cash,
							'desc'   => '自助提现',
							'check_name' => 'NO_CHECK',
			);
			if(!UctpayMod::uct_transfer($option)) {
				Dba::rollback();
				return false;
			}
		} Dba::commit();

		return $uid;
	}
		

	/*
		uct企业付款

		$option = array(
			'trade_no' =>  zaxxx
			'openid' => 
			'amount' =>  金额，单位为分
			'desc'
		)
	*/
	protected static function uct_transfer($option) {
		if(!$cfg = PayMod::is_sp_weixinpay_cert_available(0)) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}
		WxPayMod::setConfig($cfg);
	
		$ret = WxPayMod::transfers($option);
		return $ret;
	}

}

