<?php

/*
	uid 为2商铺的特殊功能
*/
class Id2ShopMod {
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
		//2016-09-19 增加二期结算返利方式
		if (1 && in_array($order['paid_fee'], array(1900000, 3800000,7600000,15200000))) {
			return self::on_pay2($order);
		}


		#$cfgx_cnt = $set_cnt = floor(($order['paid_fee'] /* + $order['discount_fee']*/) / 180000); //1800一套， 套数
		$set_cnt = 0;
		$jingying_cnt = 0;
		foreach($order['products'] as $p) {
			if($p['paid_price'] >= 180000) {
				$set_cnt += $p['quantity'];
			}
			if($p['paid_price'] >= 72000 && $p['paid_price'] < 180000) {
				$jingying_cnt += $p['quantity'];
			}
		}
		$cfgx_cnt = $set_cnt;

		if($set_cnt <= 0 && $jingying_cnt <= 0) {
			return;
		}

		uct_use_app('su');	
		//0. 自动成为会员
		$origin_level = $level = self::get_user_level($order['user_id']);
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
				//2016-09-04 修改为全部进行财富共享奖
				#$cfgx_cnt = max(0, $set_cnt - $bu);	
			}
		}


		//1. 引导奖
		if($set_cnt > 0) {
		//奖励给上级
			if($su_uid = Dba::readOne('select from_su_uid from service_user where uid = '
									.$order['user_id'])) {
				$record = array('su_uid' => $su_uid, 'cash' => 36000 * $set_cnt,
						'info' => '引导奖 360/套 #'.$order['uid']);
				SuPointMod::increase_user_cash($record);	
			}
		}

		//2. 服务奖
		if($set_cnt > 0) {
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
		}
		
		//3. 经营奖
		if($jingying_cnt > 0) {
		list($parent_1, $level_1) = self::find_first_upper_user($order['user_id'], 
									array('中级会员', '高级会员'));
		if($level_1 == '高级会员') {
			$record = array('su_uid' => $parent_1, 'cash' => 10000 * $jingying_cnt,
							'info' => '经营奖 100/套 #'.$order['uid']);
			SuPointMod::increase_user_cash($record);	
		}
		else if($level_1 == '中级会员') {
			$record = array('su_uid' => $parent_1, 'cash' => 5000 * $jingying_cnt,
							'info' => '经营奖 50/套 #'.$order['uid']);
			SuPointMod::increase_user_cash($record);	

			list($parent_2, $level_2) = self::find_first_upper_user($parent_1, 
									array('中级会员', '高级会员'));
			if($parent_2) {
				$record = array('su_uid' => $parent_2, 'cash' => 5000 * $jingying_cnt,
								'info' => '经营奖二级 50/套 #'.$order['uid']);
				SuPointMod::increase_user_cash($record);	
			}
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
		//2016-07-04 店铺补助改为 重复消费的四折优惠产品
		$set_cnt = $jingying_cnt;
		if($set_cnt > 0 && (0 || $origin_level == '高级会员')) {
			$money = 180000;
			$money = 72000;
			list($gparent_1, $glevel_1) = self::find_first_upper_user($order['user_id'], 
									array('高级会员'));
			if($gparent_1) {
				$record = array('su_uid' => $gparent_1, 'cash' => $money * 0.05 * $set_cnt,
							'info' => '店铺补助 5%/套 #'.$order['uid']);
				SuPointMod::increase_user_cash($record);	

				list($gparent_2, $glevel_2) = self::find_first_upper_user($gparent_1, 
									array('高级会员'));
				if($gparent_2) {
					$record = array('su_uid' => $gparent_2, 'cash' => $money * 0.03 * $set_cnt,
							'info' => '店铺补助 3%/套 #'.$order['uid']);
					SuPointMod::increase_user_cash($record);	

					list($gparent_3, $glevel_3) = self::find_first_upper_user($gparent_2, 
									array('高级会员'));
					if($gparent_3) {
						$record = array('su_uid' => $gparent_3, 'cash' => $money * 0.02 * $set_cnt,
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
		$uids_zhongji = Dba::readAllOne('select su_uid from groups_users where g_uid = (select uid from groups_all where sp_uid = '.$sp_uid.' && name like "%中级会员%" limit 1)');			
		$uids_chuji = Dba::readAllOne('select su_uid from groups_users where g_uid = (select uid from groups_all where sp_uid = '.$sp_uid.' && name like "%初级会员%" limit 1)');			

		$cnt_uids = $uids ? count($uids) : 0;
		$cnt_uids_zhongji = $uids_zhongji ? count($uids_zhongji) : 0;
		$cnt_uids_chuji = $uids_chuji ? count($uids_chuji) : 0;

		$total = 10 * $cnt_uids + 5 * $cnt_uids_zhongji + $cnt_uids_chuji;
		if(!$total) return;
		$max_fee = 10000 * $set_cnt;
		$has_set = 0;

		if($uids) {
			$fee = max(1, floor(10 * $max_fee/$total));
			foreach($uids as $uid) {
				$key = $key_pre.$uid;
				$has_get = !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
				if ($has_get < 3600000 && $has_set < $max_fee) {
					$GLOBALS['arraydb_sys'][$key] = $has_get + $fee;
					$record = array('su_uid' => $uid, 'cash' => $fee,
							'info' => '财富共享奖 高级会员 #'.$order['uid']);
					SuPointMod::increase_user_cash($record);	
					$has_set += $fee;
				}
			}
		}

		if($uids_zhongji) {
			$fee = max(1, floor(5 * $max_fee/$total));
			foreach($uids_zhongji as $uid) {
				$key = $key_pre.$uid;
				$has_get = !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
				if ($has_get < 1350000 && $has_set < $max_fee) {
					$GLOBALS['arraydb_sys'][$key] = $has_get + $fee;
					$record = array('su_uid' => $uid, 'cash' => $fee,
							'info' => '财富共享奖 中级会员 #'.$order['uid']);
					SuPointMod::increase_user_cash($record);	
					$has_set += $fee;
				}
			}
		}
			
		if($uids_chuji) {
			$fee = max(1, floor(1 * $max_fee/$total));
			foreach($uids_chuji as $uid) {
				$key = $key_pre.$uid;
				$has_get = !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
				if ($has_get < 180000 && $has_set < $max_fee) {
					$GLOBALS['arraydb_sys'][$key] = $has_get + $fee;
					$record = array('su_uid' => $uid, 'cash' => $fee,
							'info' => '财富共享奖 初级会员 #'.$order['uid']);
					SuPointMod::increase_user_cash($record);	
					$has_set += $fee;
				}
			}
		}
		//2016-07-18 改为 10:5:1保持比例分配
		return;

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

		if($uids_zhongji) {
			$max_fee = 3125 * $set_cnt;
			$avg_fee = floor($max_fee/count($uids_zhongji));
			$has_set = 0;
			foreach($uids_zhongji as $uid) {
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

		if($uids_chuji) {
			$max_fee = 625 * $set_cnt;
			$avg_fee = floor($max_fee/count($uids_chuji));
			$has_set = 0;
			foreach($uids_chuji as $uid) {
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

	/*
		用户二类级别 0, 1,2,3,4 
	*/
	public static function get_user_level2($su_uid) {
		$key = __CLASS__.'_level2_'.$su_uid;
		return !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
	}
	
	/*
		设置用户二类级别 0, 1,2,3,4 
	*/
	public static function set_user_level2($su_uid, $level) {
		$key = __CLASS__.'_level2_'.$su_uid;
		return $GLOBALS['arraydb_sys'][$key] = $level;
	}
	
	public static function on_pay2($order) {
		$paid_price = $order['paid_fee'];
		$su_uid = $order['user_id'];
		$levels = array(
			'1900000' => 1,
			'3800000' => 2,
			'7600000' => 3,
			'15200000' => 4,
		);
		if(!isset($levels[$paid_price])) {
			return false;
		}

		if(self::get_user_level2($su_uid) < $levels[$paid_price]) {
			self::set_user_level2($su_uid, $levels[$paid_price]);
		}

		uct_use_app('su');
		//1. 直推奖
		if($from_su_uid = Dba::readOne('select from_su_uid from service_user where uid = '
						.$order['user_id'])) {
			$record = array('su_uid' => $from_su_uid, 'cash' => 0.15 * $paid_price,
				'info' => '直推奖 15% #'.$order['uid']);
			SuPointMod::increase_user_cash($record);	
		}
		
		//2. 培育奖
		$upper_su_uid = $from_su_uid;
		$price = 0.15 * $paid_price;
		if($upper_su_uid)
		$i = 0;
		$has_visited = array();
		while(1) {
			$upper_su_uid = Dba::readOne('select from_su_uid from service_user where uid = '.$upper_su_uid);
			if(!$upper_su_uid) break;
			if(in_array($upper_su_uid, $has_visited)) {
				break;
			}
			$has_visited[] = $upper_su_uid;

			$price *= 0.5;
			if($price < 100) break;
			
			$i++;
			$record = array('su_uid' => $upper_su_uid, 'cash' => $price,
					'info' => '培育奖 '.$i.'级 #'.$order['uid']);
			SuPointMod::increase_user_cash($record);	
		}
	}

	
	/*
		福利与分红

		每个月初结算上月的情况

		$time 指定月份时间 默认上个月
	*/
	public static function pay2_yuejie($time = 0) {
		if(!$time) $time = time();
		$last_month = strtotime('first day of last month midnight', $time);
		$this_month = strtotime('first day of this month midnight', $time);

		$month = date('Y-m', $last_month);

		$key = __CLASS__ . '_yuejie_'.$month;
		if(!empty($GLOBALS['arraydb_sys'][$key])) {
			return '该月已经结算过了'.$month;
		}
		$GLOBALS['arraydb_sys'][$key] = 1;

		$sp_uid = checkNatInt(__CLASS__);
		$shop = ShopMod::get_shop_by_sp_uid($sp_uid);
		$sql = 'select sum(paid_fee) from shop_order where shop_uid = '.$shop['uid'].' &&
				create_time >= '.$last_month.' && create_time < '.$this_month.
				' && status in(4,5)';
		//上月总营收
		$total_price = Dba::readOne($sql); 
		if(!$total_price) {
			return '该月无营收！'.$month;
		}
		
		$uids = Dba::readAllOne('select uid from service_user where sp_uid = '.$sp_uid);
		if(!$uids) {
			return '没有用户！sp_uid '.$sp_uid;
		}
		//全部会员
		$uids_all = array();
		//月入>=3万 < 8万
		$uids_3 = array();
		//月入>= 8万
		$uids_8 = array();
		uct_use_app('su');

		foreach($uids as $uid) {
			$level = self::get_user_level2($uid);
			if($level <= 0) continue;

			$uids_all[$level][] = $uid;
			$sql = 'select sum(cash) from user_cash_record where su_uid = '.$uid.
					' && type = 2 && create_time >= '.$last_month.' && create_time < '.$this_month;
			$income = Dba::readOne($sql);
			if($income >= 8000000) {
				$uids_8[$uid] = $level;
			}
			else if($income >= 3000000) {
				$uids_3[$uid] = $level;
			}
		}

		//福利
		if($uids_8) {
			$price = floor($total_price * 0.01 / count($uids_8));
			foreach(array_keys($uids_8) as $uid) {
				$record = array('su_uid' => $uid, 'cash' => $price,
						'info' => '福利奖 1% #'.$month);
				SuPointMod::increase_user_cash($record);	
			}
		}
		if($uids_3) {
			$price = floor($total_price * 0.02 / count($uids_8));
			foreach(array_keys($uids_3) as $uid) {
				$record = array('su_uid' => $uid, 'cash' => $price,
						'info' => '福利奖 2% #'.$month);
				SuPointMod::increase_user_cash($record);	
			}
		}

		//分红
		if(!empty($uids_all[1])) {
			$price = floor($total_price * 0.05 * 1 / (15 * count($uids_all[1])));
			foreach($uids_all[1] as $uid) {
				$key = __CLASS__ . '_fenhong_'.$uid.'_1';
				$has_get = !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
				if($has_get >= 1900000) {
					continue;
				}

				$GLOBALS['arraydb_sys'][$key] = $has_get + $price;
				$record = array('su_uid' => $uid, 'cash' => $price,
						'info' => '分红奖 1 #'.$month);
				SuPointMod::increase_user_cash($record);	
			}
		}
		if(!empty($uids_all[2])) {
			$price = floor($total_price * 0.05 * 2 / (15 * count($uids_all[2])));
			foreach($uids_all[2] as $uid) {
				$key = __CLASS__ . '_fenhong_'.$uid.'_2';
				$has_get = !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
				if($has_get >= 5700000) {
					continue;
				}

				$GLOBALS['arraydb_sys'][$key] = $has_get + $price;
				$record = array('su_uid' => $upper_su_uid, 'cash' => $price,
						'info' => '分红奖 2 #'.$month);
				SuPointMod::increase_user_cash($record);	
			}
		}
		if(!empty($uids_all[3])) {
			$price = floor($total_price * 0.05 * 4 / (15 * count($uids_all[3])));
			foreach($uids_all[3] as $uid) {
				$key = __CLASS__ . '_fenhong_'.$uid.'_3';
				$has_get = !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
				if($has_get >= 15200000) {
					continue;
				}

				$GLOBALS['arraydb_sys'][$key] = $has_get + $price;
				$record = array('su_uid' => $uid, 'cash' => $price,
						'info' => '分红奖 3 #'.$month);
				SuPointMod::increase_user_cash($record);	
			}
		}
		if(!empty($uids_all[4])) {
			$price = floor($total_price * 0.05 * 8 / (15 * count($uids_all[1])));
			foreach($uids_all[4] as $uid) {
				$key = __CLASS__ . '_fenhong_'.$uid.'_4';
				$has_get = !empty($GLOBALS['arraydb_sys'][$key]) ? $GLOBALS['arraydb_sys'][$key] : 0;
				if($has_get >= 45600000) {
					continue;
				}

				$GLOBALS['arraydb_sys'][$key] = $has_get + $price;
				$record = array('su_uid' => $uid, 'cash' => $price,
						'info' => '分红奖 4 #'.$month);
				SuPointMod::increase_user_cash($record);	
			}
		}

		return 'ok!'.$month;
	}

}

