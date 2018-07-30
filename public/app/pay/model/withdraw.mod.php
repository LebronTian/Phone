<?php

/*
	用户提现
*/
class WithdrawMod {
	const WDPAY_TYPE_WX_REDPACK  = 1; //提现微信红包
	const WDPAY_TYPE_WX_TRANSFER = 2; //提现微信企业付款
	const WDPAY_TYPE_TEST        = 3; //提现测试, 直接成功
	const WDPAY_TYPE_OFFLINE     = 4; //todo 线下提现
	const WDPAY_TYPE_WX_BANK     = 5; //提现微信支付到银行卡

	public static function func_get_withdraw($item) {
		!empty($item['withdraw_rule']) && $item['withdraw_rule'] = json_decode($item['withdraw_rule'], true);
		return $item;
	}

	public static function func_get_withdraw_record($item) {
		!empty($item['wd_info']) && $item['wd_info'] = json_decode($item['wd_info'], true);
		return $item;
	}

	/*	
		取商户提现设置
	*/
	public static function get_sp_withdraw($sp_uid) {
		return Dba::readRowAssoc('select * from sp_user_withdraw where sp_uid = '.$sp_uid, 'WithdrawMod::func_get_withdraw');
	}

	public static function set_sp_withdraw($sp_uid, $wd) {
		if(Dba::readOne('select 1 from sp_user_withdraw where sp_uid = '.$sp_uid)) {
			Dba::update('sp_user_withdraw', $wd, 'sp_uid = '.$sp_uid);
		}
		else {
			$wd['sp_uid'] = $sp_uid;
			$wd['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('sp_user_withdraw', $wd);
		}

		return true;
	}

	public static function get_sp_user_withdraw_record_by_uid($uid) {
		return Dba::readRowAssoc('select * from sp_user_withdraw_record where uid = '.$uid, 
													'WithdrawMod::func_get_withdraw_record');
	}

	/*
		获取用户提现明细列表
	*/
	public static function get_sp_user_withdraw_record_list($option) {
		$sql = 'select * from sp_user_withdraw_record';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(!empty($option['su_uid'])) {
			$where_arr[] = 'su_uid = '.$option['su_uid'];
		}
		if(!empty($option['wd_type'])) {
			$where_arr[] = 'wd_type= '.$option['wd_type'];
		}
		if(isset($option['status']) && $option['status'] >= 0) {
			$where_arr[] = 'status = '.$option['status'];
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sort = 'create_time desc';
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'WithdrawMod::func_get_withdraw_record');
	}

	/*
		用户自助提现	
		$wd = array(	
			'su_uid' => 
			'sp_uid' =>
			'cash' =>  提现金额，单位为分
			'info' => 备注信息
		)

		返回成功提现uid，失败false
	*/
	public static function do_withdraw($wd) {
		$wd_cfg = self::get_sp_withdraw($wd['sp_uid']);
		if(!$wd_cfg || empty($wd_cfg['enabled'])) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}

		//可能是小程序发起的提现, 那么使用小程序的微信支付配置
		if(!empty($_GET['_uct_token']) && ($xcx_uid = 
			Dba::readOne('select uid from weixin_public where uid = '.
				WeixinMod::get_current_weixin_public('uid').
				' &&  sp_uid = '.$wd['sp_uid'].' && (public_type & 8)'))) {
			$wx_cfg = PayMod::get_sp_xiaochengxupay_cfg($xcx_uid);	
		} else {
			$wx_cfg = PayMod::is_sp_weixinpay_cert_available($wd['sp_uid']);
		}

		if(PayMod::is_sp_uctpay_available($wd['sp_uid']) ||
			!$wx_cfg) {
			if(!in_array($wd_cfg['wd_type'], array(WithdrawMod::WDPAY_TYPE_TEST))) {
				setLastError(ERROR_SERVICE_NOT_AVAILABLE);
				return false;
			}
			else {
				$wx_cfg = array();
			}
		}

		WxPayMod::setConfig($wx_cfg);

		if(!empty($wd_cfg['withdraw_rule']['min_price']) && $wd_cfg['withdraw_rule']['min_price'] > $wd['cash']) {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}
		if(!empty($wd_cfg['withdraw_rule']['max_price']) && $wd_cfg['withdraw_rule']['max_price'] < $wd['cash']) {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}
		if(!empty($wd_cfg['withdraw_rule']['max_price_day'])) {
			$today = strtotime('today');
			$sql = 'select sum(cash) from sp_user_withdraw_record where sp_uid = '.$wd['sp_uid'].' && su_uid = '.$wd['su_uid']
					.' && status = 1 && create_time >= '.$today.' && create_time < '.($today + 86400);
			$today = Dba::readOne($sql);	
			if($today + $wd['cash'] > $wd_cfg['withdraw_rule']['max_price_day']) {
				setLastError(ERROR_INVALID_REQUEST_PARAM);
				return false;
			}
		}
		//每日最多提现次数
		if(!empty($wd_cfg['withdraw_rule']['max_cnt_day'])) {
			$today = strtotime('today');
			$sql = 'select count(*) from sp_user_withdraw_record where sp_uid = '.$wd['sp_uid'].' && su_uid = '.$wd['su_uid']
					.' && create_time >= '.$today.' && create_time < '.($today + 86400);
			$today = Dba::readOne($sql);	
			if($today  >= $wd_cfg['withdraw_rule']['max_cnt_day']) {
				setLastError(ERROR_SERVICE_NOT_AVAILABLE);
				return false;
			}
		}
		//大额提现强制人工审核
		if(!empty($wd_cfg['withdraw_rule']['check_price']) && $wd_cfg['withdraw_rule']['check_price'] <= $wd['cash']) {
			$wd_cfg['withdraw_rule']['need_check'] = 1;
		}
		
		uct_use_app('su');
		$pr = array('su_uid' => $wd['su_uid'], 'cash' => $wd['cash'], 'info' => $wd['info']);
		$wd['create_time'] = $_SERVER['REQUEST_TIME'];
		$wd['status'] = 0;
		$wd['wd_type'] = $wd_cfg['wd_type'];

		$pw = array('su_uid' => $wd['su_uid'], 'cash' => $wd['cash'], 'info' => $wd['info']);

		//被封号
		if(!($su = AccountMod::get_service_user_by_uid($wd['su_uid'])) ||
			$su['status'] >= 2) {
			setLastError(ERROR_PERMISSION_DENIED);
			return false;
		}

		//todo 取openid 
		if(in_array($wd_cfg['wd_type'], array(WithdrawMod::WDPAY_TYPE_WX_REDPACK, WithdrawMod::WDPAY_TYPE_WX_TRANSFER,))) {
			if(defined('DEBUG_WXPAY') && DEBUG_WXPAY) {
				$pw['open_id'] = 'oWhGnjjYvTd0aQf-IRH9w4KJM6vU';
				$pw['open_id'] = 'oF71Mwa21giGJ-S3cGCucawFHxsc';
			}
			else {
				if(!$pw['open_id'] = requestString('openid', PATTERN_NORMAL_STRING)) {
					if(isset($xcx_uid)) {
						$pw['open_id'] = Dba::readOne('select open_id from weixin_fans_xiaochengxu where su_uid = '.$wd['su_uid']);
					} else {
						$pw['open_id'] = Dba::readOne('select open_id from weixin_fans where su_uid = '.$wd['su_uid']);
					}
					if(!$pw['open_id']) {
						setLastError(ERROR_INVALID_REQUEST_PARAM);
						return false;
					}
				}
			}
		}
		//取银行卡信息
		else if(in_array($wd_cfg['wd_type'], array(WithdrawMod::WDPAY_TYPE_WX_BANK))) {
			if(1||(defined('DEBUG_WXPAY') && DEBUG_WXPAY)) {
				$pw['bank_name'] = '招商银行';
				$pw['true_name'] = '刘路浩';
				$pw['bank_no'] = '6225887847257462';
			} else {
				if(!($pw['bank_name'] = requestString('bankName', PATTERN_NORMAL_STRING)) ||
					!($pw['true_name'] = requestString('realName', PATTERN_USER_NAME)) ||
					!($pw['bank_no'] = requestString('bankId', PATTERN_NORMAL_STRING))) {
					$ei = Dba::readOne('select extra_info from service_user_profile where uid = '.$wd['su_uid']);	
					if(!$ei || !($ei = json_decode($ei, true)) 
						|| empty($ei['bankName']) || empty($ei['realName']) || empty($ei['bankId'])) {
						setLastError(ERROR_INVALID_REQUEST_PARAM);
						return false;
					}
					$pw['bank_name'] = $ei['bankName'];
					$pw['true_name'] = $ei['realName'];
					$pw['bank_no'] = $ei['bankId'];
				}
			}
		}

		Dba::beginTransaction(); {
			/*
				特定店铺处理, 这里可能会扣手续费，实际打款$wd['cash'] 可能会变小
				但是扣款记录 $pr['cash'] 不变
			*/
			$cls = 'Id'.$wd['sp_uid'].'ShopMod';
			if(uct_class_exists($cls, 'shop')) {
				$wd = $cls::on_before_withdraw($wd);
			}

			if($wd['cash'] < $pr['cash']) {
				$pr['info'] .= ' 含手续费 '.(($pr['cash'] - $wd['cash'])/100);
			}
			if(!SuPointMod::decrease_user_cash($pr)) {
				Dba::rollBack();
				return false;
			}	
			//先在wd_info里保存打款信息, 等审核通过的时候再打款
			if(isset($pw['open_id'])) {
				$wd['wd_info'] = array('open_id' => $pw['open_id']);
				if(isset($xcx_uid)) $wd['wd_info']['xcx_uid'] = $xcx_uid;
			}
			else if(isset($pw['bank_name'])) {
				$wd['wd_info'] = array('bank_name' => $pw['bank_name'], 'true_name' => $pw['true_name'], 'bank_no' => $pw['bank_no']);
				if(isset($xcx_uid)) $wd['wd_info']['xcx_uid'] = $xcx_uid;
			}
			

			Dba::insert('sp_user_withdraw_record', $wd);
			$wd['uid'] = Dba::insertID();
			$pw['trade_no'] = 'zb'.$wd['uid'];

			//需要审核
			if(!empty($wd_cfg['withdraw_rule']['need_check'])) {
				setLastError(ERROR_WAIT_CONFIRM);
			}
			else {
				if($wd_info = self::pay_withdraw($wd['wd_type'], $pw)) {
					$update = array('status' => 1, 'wd_info' => $wd_info);
					Dba::update('sp_user_withdraw_record', $update, 'uid = '.$wd['uid']);
					Dba::write('update sp_user_withdraw set cash_withdrawed = cash_withdrawed + '.$wd['cash']
							.' where sp_uid = '.$wd['sp_uid']);

				}
				else {
					Weixin::weixin_log('pay withdraw fail'. var_export($pw, true));
					setLastError(ERROR_IN_WEIXIN_API);
					Dba::rollBack();
					return false;
				}
			}
		} Dba::commit();

		return $wd['uid'];
	}

	/*
		提现打款
		要求调用之前已经设置好了wx_cfg

		$wd_type => 打款方式 1 红包， 2企业付款
		$pw = array(
			'trade_no'
			'open_id'
			'cash'
			'info'
		)

		成功返回wd_info, 失败false
	*/
	protected static function pay_withdraw($wd_type, $pw) {
		switch($wd_type) {
			//微信企业付款
			case WithdrawMod::WDPAY_TYPE_WX_TRANSFER: {
				$opt = array(
							'trade_no' => $pw['trade_no'],
							'openid' => $pw['open_id'],
							'amount' => $pw['cash'],
							'check_name' => 'NO_CHECK',
							'desc' => $pw['info'],
				);
				
				return WxPayMod::transfers($opt);
			}

			//微信企业付款到银行卡
			case WithdrawMod::WDPAY_TYPE_WX_BANK: {
				$opt = array(
							'trade_no' => $pw['trade_no'],
							'bank_name' => $pw['bank_name'],
							'true_name' => $pw['true_name'],
							'bank_no' => $pw['bank_no'],
							'amount' => $pw['cash'],
							'desc' => $pw['info'],
				);
				
				return WxPayMod::pay_bank($opt);
			}

			//微信红包
			case WithdrawMod::WDPAY_TYPE_WX_REDPACK:  {
				$opt = array(
							'trade_no' => $pw['trade_no'],
							'openid' => $pw['open_id'],
							'total_amount' => $pw['cash'],
							'nick_name' => '',
							'send_name' => isset($GLOBALS['_TMP']['send_name']) ? 
									$GLOBALS['_TMP']['send_name'] : '提现',
							'wishing' => isset($GLOBALS['_TMP']['wishing']) ? 
									$GLOBALS['_TMP']['wishing']:'自助提现',
							'act_name' => !empty($pw['info']) ? substr($pw['info'], 0, 32) : '恭喜发财',
							'remark' => '自助提现',
							'logo_imgurl' => 'http://weixin.uctphp.com/app/sp/static/images/logo-b.png',
							'share_url' => 'http://weixin.uctphp.com/',
							'share_imgurl' => 'http://weixin.uctphp.com/app/sp/static/images/login-bj.png',
							'share_content' => '',
				);
				
				return WxPayMod::redpack($opt);
			}

			//提现测试
			case WithdrawMod::WDPAY_TYPE_TEST: {
				return true;
			}

			//todo  线下操作
			case WithdrawMod::WDPAY_TYPE_OFFLINE: {
				return false;
			}
			
			default:
				return false;
		}

		return false;
	}

	/*
		确定打款
	*/
	public static function confirm_pay_withdraw($wd, $sp_uid) {
		$wd_cfg = self::get_sp_withdraw($sp_uid);
		if(!$wd_cfg || empty($wd_cfg['enabled'])) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}

		is_numeric($wd) && $wd = WithdrawMod::get_sp_user_withdraw_record_by_uid($wd);
		if(!$wd || $wd['sp_uid'] != $sp_uid) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		if($wd['status'] == 1) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		if(isset($wd['wd_info']['xcx_uid'])) {
			$xcx_uid = checkInt($wd['wd_info']['xcx_uid']);
			$wx_cfg = PayMod::get_sp_xiaochengxupay_cfg($xcx_uid);	
		} else {
			$wx_cfg = PayMod::is_sp_weixinpay_cert_available($wd['sp_uid']);
		}

		if(PayMod::is_sp_uctpay_available($wd['sp_uid']) ||
			!$wx_cfg) {
			if(!in_array($wd_cfg['wd_type'], array(WithdrawMod::WDPAY_TYPE_TEST))) {
				setLastError(ERROR_SERVICE_NOT_AVAILABLE);
				return false;
			}
			else {
				$wx_cfg = array();
			}
		}
		WxPayMod::setConfig($wx_cfg);

		$pw = array('trade_no' => 'zb'.$wd['uid'], 'su_uid' => $wd['su_uid'], 
					'cash' => $wd['cash'], 'info' => $wd['info']);
		if(in_array($wd_cfg['wd_type'], array(WithdrawMod::WDPAY_TYPE_WX_REDPACK, WithdrawMod::WDPAY_TYPE_WX_TRANSFER,))) {
			if(defined('DEBUG_WXPAY') && DEBUG_WXPAY) {
				$pw['open_id'] = 'oWhGnjjYvTd0aQf-IRH9w4KJM6vU';
				$pw['open_id'] = 'oF71Mwa21giGJ-S3cGCucawFHxsc';
			}
			else {
				if(!isset($wd['wd_info']['open_id']) || 
					!($pw['open_id'] = checkString($wd['wd_info']['open_id']))) {
					if(isset($xcx_uid)) {
						$pw['open_id'] = Dba::readOne('select open_id from weixin_fans_xiaochengxu where su_uid = '.$wd['su_uid']);
					} else {
						$pw['open_id'] = Dba::readOne('select open_id from weixin_fans where su_uid = '.$wd['su_uid']);
					}
					if(!$pw['open_id']) {
						setLastError(ERROR_INVALID_REQUEST_PARAM);
						return false;
					}
				}
			}
		}
		else if(in_array($wd_cfg['wd_type'], array(WithdrawMod::WDPAY_TYPE_WX_BANK))) {
			if(!isset($wd['wd_info']['bank_name']) || 
				!isset($wd['wd_info']['bank_no']) || 
				!isset($wd['wd_info']['true_name']) 
			) {
				setLastError(ERROR_INVALID_REQUEST_PARAM);
				return false;
			}
			$pw['bank_name'] = $wd['wd_info']['bank_name'];
			$pw['bank_no'] = $wd['wd_info']['bank_no'];
			$pw['true_name'] = $wd['wd_info']['true_name'];
		}

		//以最新设置的打款方式为准
		$wd['wd_type'] = $wd_cfg['wd_type'];
		Dba::beginTransaction(); {
			if($wd_info = self::pay_withdraw($wd['wd_type'], $pw)) {
				$update = array('status' => 1, 'wd_info' => $wd_info);
				Dba::update('sp_user_withdraw_record', $update, 'uid = '.$wd['uid']);
				Dba::write('update sp_user_withdraw set cash_withdrawed = cash_withdrawed + '.$wd['cash']
						.' where sp_uid = '.$wd['sp_uid']);
	
			}
			else {
				Weixin::weixin_log('pay withdraw2 fail', var_export($pw, true));
				setLastError(ERROR_IN_WEIXIN_API);
				Dba::rollBack();
				return false;
			}
		} Dba::commit();

		return true;
	}

	/*
		拒绝打款
	*/
	public static function refuse_pay_withdraw($wd, $sp_uid) {
		$wd_cfg = self::get_sp_withdraw($sp_uid);
		if(!$wd_cfg || empty($wd_cfg['enabled'])) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}

		is_numeric($wd) && $wd = WithdrawMod::get_sp_user_withdraw_record_by_uid($wd);
		if(!$wd || $wd['sp_uid'] != $sp_uid) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		if($wd['status'] != 0) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		uct_use_app('su');
		Dba::beginTransaction(); {
			$update = array('status' => 2);
			Dba::write('delete from sp_user_withdraw_record where uid = '.$wd['uid']);
			$record = array('su_uid' => $wd['su_uid'], 'cash' => $wd['cash'], 
					'info' => '提现退回');
			SuPointMod::increase_user_cash($record);
		} Dba::commit();

		return true;
	}

}


