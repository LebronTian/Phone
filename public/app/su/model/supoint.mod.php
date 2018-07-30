<?php

/*
	用户积分, 余额
*/

class SuPointMod {
	const POINT_DECREASE = 1; //减少积分,金额
	const POINT_INCREASE = 2; //增加积分,金额

	public static function func_get_sumsg($item) {
		$item['title'] = htmlspecialchars($item['title']);
		$item['content'] = XssHtml::clean_xss($item['content']);
		return $item;
	}

	public static function func_get_user_cash_record($item) {
		if($item['info']) $item['info'] = htmlspecialchars($item['info']);
		return $item;
	}

	public static function func_get_user_top($item) {
		$item['su'] = AccountMod::get_service_user_by_uid($item['su_uid']);
		return $item;
	}

	public static function func_cash_rule($item) {
		if(!empty($item['rule'])) $item['rule'] = json_decode($item['rule'],true);
		return $item;
	}

	/*
		获取用户积分信息
	*/
	public static function get_user_points_by_su_uid($su_uid = 0) {
		if(!$su_uid && !($su_uid = AccountMod::get_current_service_user('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}

		$sql = 'select * from user_points where su_uid = '.$su_uid;
		if(!($ret = Dba::readRowAssoc($sql))) {
			Dba::insert('user_points', array('su_uid' => $su_uid, 'create_time' => $_SERVER['REQUEST_TIME']));			
			$ret = Dba::readRowAssoc($sql);
		}

		return $ret;
	}

	/*
		增加用户收入
		$record = array(		
			'su_uid' => 
			'cash' => 
			'info' => 
			'create_time' =>  选填
		)
	*/
	public static function increase_user_cash($record) {	
		if($record['cash'] <= 0) return;
		do{
			if(!($user = self::get_user_points_by_su_uid($record['su_uid']))) {
				setLastError(ERROR_OBJ_NOT_EXIST);
				return false;
			}
			$sql = 'update user_points set cash_remain = cash_remain + '.$record['cash'].' where su_uid = '.$record['su_uid'].
					' && cash_remain = '.$user['cash_remain'];
		} while(!Dba::write($sql));

		$record['type'] = SuPointMod::POINT_INCREASE;
		if(!isset($record['create_time'])) $record['create_time'] = $_SERVER['REQUEST_TIME'];
		$record['cash_remain'] = $user['cash_remain'] + $record['cash'];

		Dba::insert('user_cash_record', $record);
		$uid = Dba::insertID();

		self::on_usercash_changed($uid);
		return $uid;
	}

	/*
		减少用户收入, 消费或提现
		$record = array(		
			'su_uid' => 
			'cash' => 
			'info' => 
		)

	*/
	public static function decrease_user_cash($record) {	
		do{
			$user = self::get_user_points_by_su_uid($record['su_uid']);
			if($user['cash_remain'] < $record['cash']) {
				setLastError(ERROR_INVALID_REQUEST_PARAM);
				return false;
			}
			$sql = 'update user_points set cash_remain = cash_remain - '.$record['cash'].', cash_transfered = cash_transfered + '
					.$record['cash'].' where su_uid = '.$record['su_uid'].' && cash_transfered = '.$user['cash_transfered']
					.' && cash_remain = '.$user['cash_remain'];
		} while(!Dba::write($sql));

		$record['type'] = SuPointMod::POINT_DECREASE;
		if(!isset($record['create_time'])) $record['create_time'] = $_SERVER['REQUEST_TIME'];
		$record['cash_remain'] = $user['cash_remain'] - $record['cash'];

		Dba::insert('user_cash_record', $record);
		$uid = Dba::insertID();
		self::on_usercash_changed($uid);
		return $uid;
	}

	/*
		获取用户现金收入支出明细
	*/
	public static function get_user_cash_list($option) {
		$sql = 'select * from user_cash_record';
		if(!empty($option['sp_uid'])) {
			$sql = 'select user_cash_record.* from user_cash_record join service_user on user_cash_record.su_uid = service_user.uid';
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}

		if(!empty($option['su_uid'])) {
			$where_arr[] = 'su_uid= '.$option['su_uid'];
		}
		if(!empty($option['type'])) {
			$where_arr[] = 'type= '.$option['type'];
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		//$sort = 'create_time desc';
		$sort = 'user_cash_record.uid desc';
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SuPointMod::func_get_user_cash_record');
	}

	/*
		增加用户积分
		$record = array(		
			'su_uid' => 
			'point' => 
			'info' => 
			'create_time' =>  选填
		)
	*/
	public static function increase_user_point($record) {	
		do{
			if(!($user = self::get_user_points_by_su_uid($record['su_uid']))) {
				setLastError(ERROR_OBJ_NOT_EXIST);
				return false;
			}
			$GLOBALS['_TMP']['point_max'][0] = $user['point_max'];
			$sql = 'update user_points set point_remain = point_remain + '.$record['point'].', point_max = point_max + '.$record['point']
					.' where su_uid = '.$record['su_uid'].' && point_remain = '.$user['point_remain'];
					
		} while(!Dba::write($sql));
		$GLOBALS['_TMP']['point_max'][1] = $user['point_max']+$record['point'];

//		uct_use_app('vipcard');
		Event::addHandler('AfterIncrease_User_Point', array('vipcardmod', 'onAfterIncrease_User_Point'));
		$record['type'] = SuPointMod::POINT_INCREASE;
		if(!isset($record['create_time'])) $record['create_time'] = $_SERVER['REQUEST_TIME'];
		$record['point_remain'] = $user['point_remain'] + $record['point'];

		Dba::insert('user_point_record', $record);
		return Dba::insertID();
	}

	/*
		减少用户积分, 消费
		$record = array(		
			'su_uid' => 
			'point' => 
			'info' => 
		)

	*/
	public static function decrease_user_point($record) {	
		do{
			$user = self::get_user_points_by_su_uid($record['su_uid']);
			if($user['point_remain'] < $record['point']) {
				setLastError(ERROR_INVALID_REQUEST_PARAM);
				return false;
			}
			$sql = 'update user_points set point_remain = point_remain - '.$record['point'].', point_transfered = point_transfered + '
					.$record['point'].' where su_uid = '.$record['su_uid'].' && point_transfered = '.$user['point_transfered']
					.' && point_remain = '.$user['point_remain'];
		} while(!Dba::write($sql));
		$record['type'] = SuPointMod::POINT_DECREASE;
		if(!isset($record['create_time'])) $record['create_time'] = $_SERVER['REQUEST_TIME'];
		$record['point_remain'] = $user['point_remain'] - $record['point'];

		Dba::insert('user_point_record', $record);
		return Dba::insertID();
	}

	/*
		获取用户积分增减明细
	*/
	public static function get_user_point_list($option) {
		$sql = 'select * from user_point_record';
		if(!empty($option['sp_uid'])) {
			$sql = 'select user_point_record.* from user_point_record join service_user on user_point_record.su_uid = service_user.uid';
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}

		if(!empty($option['su_uid'])) {
			$where_arr[] = 'su_uid= '.$option['su_uid'];
		}
		if(!empty($option['type'])) {
			$where_arr[] = 'type= '.$option['type'];
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sort = 'create_time desc';
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SuPointMod::func_get_user_cash_record');
	}

	/*
		积分兑换余额

		$option = array(
			'su_uid' => 
			'point' => 
			'cash' => 
		)
	*/
	public static function user_point_to_cash($option) {
		$rp = array('su_uid' => $option['su_uid'], 'point' => $option['point'], 'info' => '积分兑换余额');
		$rc = array('su_uid' => $option['su_uid'], 'cash'  => $option['cash'],  'info' => '积分兑换余额');

		Dba::beginTransaction(); {
			if(!self::decrease_user_point($rp) ||
				!self::increase_user_cash($rc)) {
				Dba::rollBack();
				return false;
			}
		} Dba::commit();

		return true;
	}

	/*	
		获取余额变更通知设置
		
		@return array(
			'enabled' => 1,
			'tid' =>  模板消息id
			'public_uid' => 公众号uid
		)
	*/
	public static function get_cashnotice_cfg($sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			return false;
		}

		$key = 'cashnotice_'.$sp_uid;
		if(isset($GLOBALS['arraydb_sys'][$key])) {
			return json_decode($GLOBALS['arraydb_sys'][$key], true);
		}
		
		return false;
	}

	//设置余额变更通知设置
	public static function set_cashnotice_cfg($cfg, $sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			return false;
		}

		$key = 'cashnotice_'.$sp_uid;
		if(is_array($cfg)) {
			$cfg = json_encode($cfg);
		}
		return $GLOBALS['arraydb_sys'][$key] = $cfg;
	}

	public static function is_cashnotice_available($sp_uid = 0) {
		if(($cfg = self::get_cashnotice_cfg($sp_uid)) && !empty($cfg['enabled']) &&
			!empty($cfg['tid']) && !empty($cfg['public_uid'])) {
			return $cfg;
		}

		return false;
	}

	/*
		余额变更，发送微信模板通知
	*/
	public static function on_usercash_changed($uid) {
		return Queue::add_job('su_cashnoticeJob', array($uid));	
	}

	public static function get_cash_record_by_uid($uid) {
		return Dba::readRowAssoc('select * from user_cash_record where uid = '.$uid, 'SuPointMod::func_get_user_cash_record');
	}

	/*
		排行榜 积分、余额

		$option = array(
			'sp_uid'
		)
	*/
	public static function get_user_top_list($option) {
		$sql = 'select user_points.* from user_points join service_user on service_user.uid = user_points.su_uid where service_user.sp_uid = '.$option['sp_uid'].' && service_user.status < 2';
		
		!isset($option['sort']) && $option['sort'] = SORT_BY_POINT_MAX_DESC;
		switch($option['sort']) {
			case SORT_BY_POINT_DESC: {
				$sort = '&& point_max > 0 order by point_remain desc';
				break;
			}
			default: {
				$sort = '&& point_max > 0 order by point_max desc, point_remain desc';
			}
		}
		$sql .= $sort;
		
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SuPointMod::func_get_user_top');
	}

	/*
    增加用户point_max
    $record = array(
        'su_uid' =>
        'point_max' =>
    )
	*/
	public static function increase_user_point_max($record) {

		if(!($user = self::get_user_points_by_su_uid($record['su_uid']))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		$GLOBALS['_TMP']['point_max'][0] = $user['point_max'];
		$sql = 'update user_points set point_max = point_max + '.$record['point_max']
			.' where su_uid = '.$record['su_uid'].' && point_remain = '.$user['point_remain'];
		Dba::write($sql);
		$GLOBALS['_TMP']['point_max'][1] = $user['point_max']+$record['point_max'];

		//小程序模板消息
		Event::handle('AfterSetVip', array($record['su_uid']));

		return true;
	}

	/*
	 设置小程序模板消息 todo 发提示, 模板消息
	 */
	public static function onAfterSetVip($su_uid)
	{
		uct_use_app('vipcard');
		$vip = VipcardMod::get_vip_card_by_su_uid_new($su_uid);

		uct_use_app('templatexcxmsg');
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$xcxargs = Templatexcx_Msg_WxPlugMod::get_vip_args_by_su_uid($vip);
		Templatexcx_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__ . '.' . __FUNCTION__, $sp_uid, $su_uid, $xcxargs);
	}

	/*
	 * 充值规则
	 */
	public static function get_cash_rule($sp_uid){
		return Dba::readRowAssoc('select * from cash_rule where sp_uid = '.$sp_uid,'SuPointMod::func_cash_rule');
	}
	/*
	 * 充值规则设置
	 */
	public static function set_cash_rule($option){
		if(empty($option['uid'])){
			$option['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('cash_rule', $option);
			$option['uid'] = Dba::insertID();
		}else{
			Dba::update('cash_rule', $option, 'uid = '.$option['uid']);
		}
		return $option['uid'];
	}

}

