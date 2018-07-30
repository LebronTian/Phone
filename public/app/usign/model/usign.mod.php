<?php


class UsignMod {

	/*
	 * 初始化 签到配置
	 */
	public static function init_usign_set($sp_uid)
	{
		$usign_set = array(
			'sp_uid' =>$sp_uid,
			'create_time' => $_SERVER['REQUEST_TIME'],
			'status' => 0,
			'rule_data'=>array(0,1),
			'tpl'=>''
		);
		return Dba::insert('usign_set',$usign_set);
	}

	/*
	 * 编辑签到配置
	 */
	public static function edit_usign_set($usign_set)
	{
		if(empty($usign_set['uid'])) return false;
		return  Dba::update('usign_set',$usign_set,'uid ='.$usign_set['uid']);
	}

	/*
	 * 通过uid 获取签到配置
	 */
	public static function get_usign_set_by_uid($uid)
	{
		return  Dba::readRowAssoc('select * from usign_set where uid='.$uid,'UsignMod::func_get_usign_set');
	}

	/*
	 * 通过商户uid 获取签到配置
	 */
	public static function get_usign_set_by_sp_uid($sp_uid)
	{
		$sql = 'select * from usign_set where sp_uid='.$sp_uid;
		if(!($usign_set = Dba::readRowAssoc($sql,'UsignMod::func_get_usign_set')))
		{
			self::init_usign_set($sp_uid);
			$usign_set = Dba::readRowAssoc($sql,'UsignMod::func_get_usign_set');
		}
		return  $usign_set;

	}

	public static function func_get_usign_set($item)
	{
		if(!empty($item['rule_data']))
		{
			$item['rule_data'] = json_decode($item['rule_data'],true);
		}
		return $item;
	}

	public static function add_or_edit_usign_record($usign_record)
	{
		if(!empty($usign_record['uid']))
		{
			Dba::update('usign_record',$usign_record,'uid ='.$usign_record['uid']);
		}
		else
		{
			!isset($usign_record['create_time']) && $usign_record['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('usign_record',$usign_record);
			$usign_record['uid'] = Dba::insertID();
		}
		return $usign_record['uid'];
	}

	public static function get_usign_reocrd_by_uid($uid)
	{
		return Dba::readRowAssoc('select * from usign_reocrd where uid='.$uid,'UsignMod::fun_get_usign_record');
	}

	public static function get_usign_record_list($option)
	{
		$sql = 'select * from usign_record ';
		if (!empty($option['sp_uid']))
		{
			$where_arr[] = 'su_uid in (select uid from service_user where sp_uid=' . $option['sp_uid'].')';
		}
		if (!empty($option['su_uid'])) {
			$where_arr[] = 'su_uid = '.$option['su_uid'];
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by uid desc';
		$option['page']  = isset($option['page']) ? $option['page'] : 0;
		$option['limit'] = isset($option['limit']) ? $option['limit'] : 10;
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'UsignMod::fun_get_usign_record');
	}

	public static function fun_get_usign_record($item)
	{
		if(!empty($item['su_uid']))
		{
			$item['user'] = AccountMod::get_service_user_by_uid($item['su_uid']);
		}

		return $item;
	}

	public static function get_usign_set_sp()
	{
		if ($uid = requestInt('usign_uid'))
		{
			$usign_set = self::get_usign_set_by_uid($uid);
		}
		else
		{
			if ($sp_uid = AccountMod::require_sp_uid())
			{
				$usign_set = self::get_usign_set_by_sp_uid($sp_uid);
			}
			else
			{
				setLastError(ERROR_INVALID_REQUEST_PARAM);
				return false;
			}
		}
		if ($usign_set['status'])
		{
			setLastError(ERROR_BAD_STATUS);

			return false;
		}

		return $usign_set;
	}


	public static function do_usign($su_uid)
	{
		$usign_record  =array( 'su_uid'=>$su_uid);
		Dba::beginTransaction();
		{
			$usign_record['uid'] = self::add_or_edit_usign_record($usign_record);
			$su = AccountMod::get_service_user_by_uid($su_uid);
			$usign_set  =  self::get_usign_set_by_sp_uid($su['sp_uid']);
			UsignRuleMod::do_sign_by_rule($su_uid,$usign_set['rule_data']);
			if(!empty($GLOBALS['_TMP']['INFO_DATA']))
			{
				$usign_record['info_data'] = $GLOBALS['_TMP']['INFO_DATA'];
				$usign_record['uid'] = self::add_or_edit_usign_record($usign_record);
			}
		}
		Dba::commit();
		return $usign_record['uid'];
	}

	public static function onAfterdousign()
	{

	}

	public static function check_usign_status($su_uid)
	{
		return Dba::readone('select count(*) from usign_record where su_uid = '.$su_uid.' and FROM_UNIXTIME(create_time,"%Y-%m-%d")="'.date('Y-m-d').'"');
	}

	
	/*
		签到, 加积分
	*/
	public static function just_sign($su_uid, $sp_uid, $time = null) {
		$set = self::get_usign_set_by_sp_uid($sp_uid);
		if(!$set || ($set['status'] != 0)) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}

		if(!$time) $time = $_SERVER['REQUEST_TIME'];
		
		$begin_time = strtotime('today', $time);
		$end_time = $begin_time + 86400;
		if(Dba::readOne('select create_time from usign_record where su_uid = '.
		$su_uid.' && create_time >= '.$begin_time.' && create_time < '.$end_time)) {
			setLastError(ERROR_OBJECT_ALREADY_EXIST);
			return false;
		}
		
		$r = array('su_uid' => $su_uid, 'create_time' => $time);
		$ret = self::add_or_edit_usign_record($r);
		if($ret && !empty($set['rule_data'][1])) {
			uct_use_app('su');
			SuPointMod::increase_user_point(array('su_uid' => $su_uid,
		                                      'point' => $set['rule_data'][1],
		                                      'info' => '签到送积分 '.date('Y-m-d', $time)));
			$ret = $set['rule_data'][1];
		} else {
			$ret = 0;
		}

		//返回增加的积分数
		return $ret;
	}

}

