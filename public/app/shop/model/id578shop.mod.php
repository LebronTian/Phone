<?php

/*
	uid 为578商铺的特殊功能
*/
class Id578ShopMod {
	/*
		获取用户会员等级

		@return 返回string 
				'初级会员'
				'中级会员'
				'高级会员'
				''
	*/
	public static function get_user_level($su_uid) {
		$gs = SuGroupMod::get_user_groups($su_uid);
		if($gs)
		foreach($gs as $g) {
			if(in_array($g['name'], array('初级会员', '中级会员', '高级会员')))
				return $g['name'];
		}

		return '';
	}

	/*
		获取上级用户等级
		@return array($from_su_uid, $level)
	*/
	public static function get_parent_user_level($su_uid) {
		if(!$from_su_uid = Dba::readOne('select from_su_uid from service_user where uid = '.$su_uid)) {
			return array(false, false);
		}

		return array($from_su_uid, self::get_user_level($from_su_uid));
	}

	/*
		获取符合条件的第一个上级用户
		@return array($from_su_uid, $level)
	*/
	public static function find_first_upper_user($su_uid, $levels = array()) {
		$has_visited = array();
		while(1) {
			if(in_array($su_uid, $has_visited)) {
				return array(false, false);
			}
			else {
				$has_visited[] = $su_uid;
			}

			if(!$from_su_uid = Dba::readOne('select from_su_uid from service_user where uid = '.$su_uid)) {
				return array(false, false);
			}

			$level = self::get_user_level($from_su_uid);
			if(in_array($level, $levels)) {
				return array($from_su_uid, $level);
			}

			//echo $su_uid.' -> '.$from_su_uid.';';
			$su_uid = $from_su_uid;
		}
	}


	/*
		设置会员等级
	*/
	public static function set_user_level($su_uid, $level) {
		$sp_uid = Dba::readOne('select sp_uid from service_user where uid = '.$su_uid);					
		if(!$sp_uid) {
			return false;
		}
		if(!$g_uid = Dba::readOne('select uid from groups_all where sp_uid = '.$sp_uid
									.' && name like "%'.$level.'%"')) {
			$g_uid = SuGroupMod::add_or_edit_group(array('sp_uid' => $sp_uid, 'name' => $level));
		}
		if(!$g_uid) {
			return false;
		}

		return SuGroupMod::move_user_to_group($su_uid, $g_uid, $sp_uid);
	}

	public static function on_pay($order) {
		#$cfgx_cnt = $set_cnt = floor(($order['paid_fee'] /* + $order['discount_fee']*/) / 180000); //1800一套， 套数
		$set_cnt = 0;
		foreach($order['products'] as $p) {
			if($p['paid_price'] >= 180000) {
				$set_cnt += $p['quantity'];
			}
		}
		$cfgx_cnt = $set_cnt;

		if($set_cnt <= 0) {
			return;
		}

		uct_use_app('su');	
		//0. 自动成为会员
		$level = self::get_user_level($order['user_id']);
		if(!$level) {
			if($set_cnt >= 10) $level = '高级会员';	
			else if($set_cnt >= 5) $level = '中级会员';	
			else $level = '初级会员';

			self::set_user_level($order['user_id'], $level);
		}
		else {
			//已经是会员了，就都是4折购买，不再有奖励
			#return;
			if ($level != '高级会员') { //
				if($level == '初级会员') $bu = 9;
				else if($level == '中级会员') $bu = 4;

				//购买升级为高级会员， 此时不参与财富共享奖
				if($set_cnt >= $bu) {
					$level = '高级会员';
					self::set_user_level($order['user_id'], $level);
				}
				$cfgx_cnt = max(0, $set_cnt - $bu);	
			}
		}


		//1. 引导奖
		$record = array('su_uid' => $order['user_id'], 'cash' => 36000 * $set_cnt,
						'info' => '引导奖 360/套 #'.$order['uid']);
		SuPointMod::increase_user_cash($record);	

		//2. 服务奖
		list($parent_1, $level_1) = self::find_first_upper_user($order['user_id'], 
									array('中级会员', '高级会员'));
		if($level_1 == '高级会员') {
			$record = array('su_uid' => $parent_1, 'cash' => 20000 * $set_cnt,
							'info' => '服务奖 200/套 #'.$order['uid']);
			SuPointMod::increase_user_cash($record);	
		}
		else if($level_1 == '中级会员') {
			$record = array('su_uid' => $parent_1, 'cash' => 10000 * $set_cnt,
							'info' => '服务奖 100/套 #'.$order['uid']);
			SuPointMod::increase_user_cash($record);	

			list($parent_2, $level_2) = self::find_first_upper_user($parent_1, 
									array('中级会员', '高级会员'));
			if($parent_2) {
				$record = array('su_uid' => $parent_2, 'cash' => 10000 * $set_cnt,
								'info' => '服务奖二级 100/套 #'.$order['uid']);
				SuPointMod::increase_user_cash($record);	
			}
		}
		
		//3. 经营奖
		list($parent_1, $level_1) = self::find_first_upper_user($order['user_id'], 
									array('中级会员', '高级会员'));
		if($level_1 == '高级会员') {
			$record = array('su_uid' => $parent_1, 'cash' => 10000 * $set_cnt,
							'info' => '经营奖 100/套 #'.$order['uid']);
			SuPointMod::increase_user_cash($record);	
		}
		else if($level_1 == '中级会员') {
			$record = array('su_uid' => $parent_1, 'cash' => 5000 * $set_cnt,
							'info' => '经营奖 50/套 #'.$order['uid']);
			SuPointMod::increase_user_cash($record);	

			list($parent_2, $level_2) = self::find_first_upper_user($parent_1, 
									array('中级会员', '高级会员'));
			if($parent_2) {
				$record = array('su_uid' => $parent_2, 'cash' => 5000 * $set_cnt,
								'info' => '经营奖二级 50/套 #'.$order['uid']);
				SuPointMod::increase_user_cash($record);	
			}
		}
		
		//4. 财富共享奖
		if($cfgx_cnt > 0)
		{
		list($dparent_1, $dlevel_1) = self::get_parent_user_level($order['user_id']);
		if($dlevel_1) {
			$record = array('su_uid' => $dparent_1, 'cash' => 10000 * $cfgx_cnt,
							'info' => '财富共享奖 100/套 #'.$order['uid']);
			SuPointMod::increase_user_cash($record);	
		}
		$sp_uid = Dba::readOne('select sp_uid from service_user where uid = '.$order['user_id']);					
		self::cfgx_jiang($cfgx_cnt, $sp_uid, $order);
		}
		
		//5. 店铺补助、三级分销
		if(1 || $level == '高级会员') {
			list($gparent_1, $glevel_1) = self::find_first_upper_user($order['user_id'], 
									array('高级会员'));
			if($gparent_1) {
				$record = array('su_uid' => $gparent_1, 'cash' => 180000 * 0.05 * $set_cnt,
							'info' => '店铺补助 5%/套 #'.$order['uid']);
				SuPointMod::increase_user_cash($record);	

				list($gparent_2, $glevel_2) = self::find_first_upper_user($gparent_1, 
									array('高级会员'));
				if($gparent_2) {
					$record = array('su_uid' => $gparent_2, 'cash' => 180000 * 0.03 * $set_cnt,
							'info' => '店铺补助 3%/套 #'.$order['uid']);
					SuPointMod::increase_user_cash($record);	

					list($gparent_3, $glevel_3) = self::find_first_upper_user($gparent_2, 
									array('高级会员'));
					if($gparent_3) {
						$record = array('su_uid' => $gparent_3, 'cash' => 180000 * 0.02 * $set_cnt,
								'info' => '店铺补助 2%/套 #'.$order['uid']);
						SuPointMod::increase_user_cash($record);	
					}
				}
			}
		}

	}

	/*
		财富共享奖
	*/
	public static function cfgx_jiang($set_cnt, $sp_uid, $order) {
		$key_pre = __CLASS__ .'_cfgx_';

		$uids = Dba::readAllOne('select su_uid from groups_users where g_uid = (select uid from groups_all where sp_uid = '.$sp_uid.' && name like "%高级会员%" limit 1)');			
		if($uids) {
			$max_fee = 6250 * $set_cnt;
			$avg_fee = floor($max_fee/count($uids));
			$has_set = 0;
			foreach($uids as $uid) {
				$key = $key_pre.$uid;
				$has_get = !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
				if ($has_get < 3600000 && $has_set < $max_fee) {
					//如果平均不够1分钱，按顺序每人给1分，分完为止	
					$fee = max(1, min($avg_fee, 3600000 - $has_get));
					$GLOBALS['arraydb_sys'][$key] = $has_get + $fee;
					$record = array('su_uid' => $uid, 'cash' => $fee,
							'info' => '财富共享奖 全体62.5/套 #'.$order['uid']);
					SuPointMod::increase_user_cash($record);	
					$has_set += $fee;
				}
			}
		}

		$uids = Dba::readAllOne('select su_uid from groups_users where g_uid = (select uid from groups_all where sp_uid = '.$sp_uid.' && name like "%中级会员%" limit 1)');			
		if($uids) {
			$max_fee = 3125 * $set_cnt;
			$avg_fee = floor($max_fee/count($uids));
			$has_set = 0;
			foreach($uids as $uid) {
				$key = $key_pre.$uid;
				$has_get = !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
				if ($has_get < 1350000 && $has_set < $max_fee) {
					//如果平均不够1分钱，按顺序每人给1分，分完为止	
					$fee = max(1, min($avg_fee, 1350000 - $has_get));
					$GLOBALS['arraydb_sys'][$key] = $has_get + $fee;
					$record = array('su_uid' => $uid, 'cash' => $fee,
							'info' => '财富共享奖 全体31.25/套 #'.$order['uid']);
					SuPointMod::increase_user_cash($record);	
					$has_set += $fee;
				}
			}
		}

		$uids = Dba::readAllOne('select su_uid from groups_users where g_uid = (select uid from groups_all where sp_uid = '.$sp_uid.' && name like "%初级会员%" limit 1)');			
		if($uids) {
			$max_fee = 625 * $set_cnt;
			$avg_fee = floor($max_fee/count($uids));
			$has_set = 0;
			foreach($uids as $uid) {
				$key = $key_pre.$uid;
				$has_get = !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
				if ($has_get < 180000 && $has_set < $max_fee) {
					//如果平均不够1分钱，按顺序每人给1分，分完为止	
					$fee = max(1, min($avg_fee, 180000 - $has_get));
					$GLOBALS['arraydb_sys'][$key] = $has_get + $fee;
					$record = array('su_uid' => $uid, 'cash' => $fee,
							'info' => '财富共享奖 全体6.25/套 #'.$order['uid']);
					SuPointMod::increase_user_cash($record);	
					$has_set += $fee;
				}
			}
		}
	}

	/*
		提现时计算重复消费奖
		这里可以收手续费
	*/
	public static function on_before_withdraw($wd) {
		//todo 先去掉 快递来啦
		return $wd;

		$key_pre = __CLASS__ .'_cfxf_';
		$key = $key_pre.$wd['su_uid'].'_'.date('Y-m');

		$this_month = !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
		if($this_month >= 180000) {
			return $wd;
		}

		$fee = min(180000 - $this_month, floor(0.05 * $wd['cash']));
		$wd['cash'] -= $fee;
		$GLOBALS['arraydb_sys'][$key] = $this_month + $fee;

		return $wd;
	}

	/*
		获取本月重复消费奖
	*/
	public static function get_user_cfxf($su_uid = 0, $time = 0) {
		if(!$su_uid && !($su_uid = AccountMod::has_su_login())) {
			return false;
		}

		$key_pre = __CLASS__ .'_cfxf_';
		$key = $key_pre.$su_uid.'_'.date('Y-m', $time ? $time : $_SERVER['REQUEST_TIME']);

		return !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
	}

}

