<?php

/*
	通用抽奖系统
*/

class RewardMod {
	/*过滤和处理查询出来的数据*/
	public static function func_get_reward($item) {
		$item['title'] = htmlspecialchars($item['title']);
		if(!empty($item['brief'])) $item['brief'] = XssHtml::clean_xss($item['brief']);
		if(!empty($item['access_rule'])) $item['access_rule'] = json_decode($item['access_rule'], true);
		if(!empty($item['win_rule'])) $item['win_rule'] = json_decode($item['win_rule'], true);
		
		return $item;
	}
	/*同上*/
	public static function func_get_reward_item($item) { 
		$item['title'] = htmlspecialchars($item['title']);
		if(!empty($item['brief'])) $item['brief'] = XssHtml::clean_xss($item['brief']);
		if(!empty($item['virtual_info'])) $item['virtual_info'] = json_decode($item['virtual_info'], true);
		
		return $item;
	}
	/*同上*/
	public static function func_get_reward_record($item) {
		if(!empty($item['su_uid'])) $item['user'] = AccountMod::get_service_user_by_uid($item['su_uid']);
		if(!empty($item['item_uid'])) $item['item'] = RewardMod::get_reward_item_by_uid($item['item_uid']);
		if(!empty($item['data'])) $item['data'] = json_decode($item['data'], true);
		return $item;
	}
	/*同上*/
	public static function func_get_user_rule($item) {
		if(!empty($item['access_rule'])) $item['access_rule'] = json_decode($item['access_rule'], true);
		return $item;
	}

	/*
		todo 配额管理

		添加或编辑投票
		reward = array(
			...

			'access_rule' => array(
				'must_login' => true, //是否必须登陆才能抽奖

				'start_time' => 0, //允许抽奖的开始时间戳, 0表示不限制
				'end_time'   => 0, //允许抽奖的截止时间戳, 0表示不限制

				'max_item'   => 5, //最多允许中奖次数, 0不限制 
				'max_cnt'    => 1, //每个用户最多允许抽奖多少次, 0不限制 
				'max_cnt_day'=> 1, //每个用户每天最多允许抽奖多少次, 0不限制 
			),
		)
	*/
	/*新增或者修改抽奖*/
	public static function add_or_edit_reward($reward) {
		if(!empty($reward['uid'])) {
			Dba::update('reward', $reward, 'uid = '.$reward['uid'].' and sp_uid = '.$reward['sp_uid']);
		}
		else {
			$reward['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('reward', $reward);
			$reward['uid'] = Dba::insertID();
		}

		return $reward['uid'];
	}

	/*
		删除投票
							
		返回删除的条数
	*/
	public static function delete_reward($rids, $sp_uid) {
		if(!is_array($rids)) {
			$rids = array($rids);
		}
		$real_rids = Dba::readAllOne('select uid from reward where uid in ('.implode(',', $rids).') && sp_uid = '.$sp_uid);
		if(!$real_rids) {
			return 0;
		}

		$sql = 'delete from reward where uid in ('.implode(',',$real_rids).')';
		Dba::beginTransaction(); {
			if($ret = Dba::write($sql)) {
				$sql = 'delete from reward_item where r_uid in ('.implode(',', $real_rids).')';
				Dba::write($sql);
				$sql = 'delete from reward_record where r_uid in ('.implode(',', $real_rids).')';
				Dba::write($sql);
			}
		} Dba::commit();

		return $ret;
	}
	/*获取*/
	public static function get_reward_by_uid($uid) {

		return Dba::readRowAssoc('select * from reward where uid = '.$uid, 'RewardMod::func_get_reward');
								
	}

	/*
		根据商户uid获取一个抽奖
	*/
	public static function get_default_reward_by_sp_uid($sp_uid) {
		return Dba::readRowAssoc('select * from reward where sp_uid = '.$sp_uid.' && status = 0', 'RewardMod::func_get_reward');
	}

	/*
		新增奖品
	*/
	public static function add_or_edit_reward_item($item) {
		if(!empty($item['uid'])) {
			Dba::update('reward_item', $item, 'uid = '.$item['uid']);
		}
		else {
			Dba::insert('reward_item', $item);
			$item['uid'] = Dba::insertID();
		}

		return $item['uid'];
	}

	/*
		删除奖品

		返回删除的条数
	*/
	public static function delete_reward_item($iids, $r_uid) {
		if(!is_array($iids)) {
			$iids = array($iids);
		}
		return Dba::write('delete from reward_item where uid in ('.implode(',', $iids).') && r_uid = '.$r_uid);
	}

	/*
		取奖品信息
	*/
	public static function get_reward_item_by_uid($uid) {
		return Dba::readRowAssoc('select * from reward_item where uid = '.$uid, 'RewardMod::func_get_reward_item');
	}

	/*
		取奖品列表
	*/
	public static function get_reward_item_list($option) {
		$sql = 'select * from reward_item where r_uid = '.$option['r_uid'];
		if(!empty($option['key'])) {
			$sql .= ' && (title like "%'.addslashes($option['key']).'%" || brief like "%'.addslashes($option['key']).'%")';
		}

		!isset($option['sort']) && $option['sort'] = SORT_VOTE_DESC;
		switch($option['sort']) {
			case SORT_CREATE_TIME_DESC:
			$sort = 'sort desc, uid desc';
			break;
			
			default: 
			$sort = 'sort desc, total_cnt';
		}
		$sql .= ' order by '.$sort;
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'RewardMod::func_get_reward_item');
	}

	/*
		获取抽奖列表 
	*/
	public static function get_reward_list($option) {
		$sql = 'select * from reward';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid='.$option['sp_uid'];
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .= ' order by uid desc';
		
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'RewardMod::func_get_reward');
	}

	/*
		检查是否能抽奖
		$user = array(
			'su_uid'  =>  
			'user_ip' => 
		)
	*/
	public static function can_do_reward($reward, $user) {
		$user['do_query'] = 1;
		return self::do_reward($reward, $user);
	}

	/*
		获取某用户抽奖次数信息

		$r_uid 抽奖uid
		$user = array(
			'su_uid'  =>  
			'user_ip' => 
		)

		$field = !empty($user['su_uid']) ? 'su_uid' : 'user_ip';
	*/
	
	public static function get_user_reward_cnt_info($r_uid, $user = null) {
		if(!$user) {
			$user = array('su_uid' => AccountMod::has_su_login(),
						  'user_ip' => requestClientIP());
		}

		$field = !empty($user['su_uid']) ? 'su_uid' : 'user_ip';
		//总计抽奖次数
		$sql = 'select count(*) from reward_record where r_uid = '.$r_uid.' && '.$field.' = "'.addslashes($user[$field]).'"';
		$info['user_max_cnt'] = Dba::readOne($sql);

		//今日抽奖次数
		$sql = 'select count(*) from reward_record where r_uid = '.$r_uid.' && '.$field.' = "'.addslashes($user[$field]).'"'
				.' && create_time >= '.strtotime('today').' && create_time < '.strtotime('tomorrow');
		$info['user_max_cnt_day'] = Dba::readOne($sql);

		//已中奖次数
		$sql = 'select count(*) from reward_record where r_uid = '.$r_uid.' && '.$field.' = "'.addslashes($user[$field]).'"'
				.' && item_uid > 0';
		$info['user_max_item'] = Dba::readOne($sql);
			
		if($info['user_rule'] = RewardMod::get_user_reward_rule($r_uid, $user)) {
			$info['user_rule'] = $info['user_rule']['access_rule'];
		}

		return $info;
	}

	/*
		获取某用户的抽奖规则access_rule
		没有返回false

		$r_uid 抽奖uid
		$user = array(
			'su_uid'  =>  
			'user_ip' => 
		)
	*/
	public static function get_user_reward_rule($r_uid, $user = null) {
		if(!$user) {
			$user = array('su_uid' => AccountMod::has_su_login(),
						  'user_ip' => requestClientIP());
		}

		$field = !empty($user['su_uid']) ? 'su_uid' : 'user_ip';
		$sql = 'select * from reward_rule_user where r_uid = '.$r_uid.' && '.$field.' = "'.addslashes($user[$field]).'"';
		return Dba::readRowAssoc($sql, 'RewardMod::func_get_user_rule');
	}

	/*
		给某用户增加抽奖机会
		$reward
		$user = array(
			'su_uid'  =>  
			'user_ip' => 
		)

		$chance 默认为 array(
			'reason' => 'share_wx', //增加条件，不能重复
			'cnt' => 1, //增加1次机会
		)
	*/
	public static function add_reward_chance_to_user($reward, $user = null, $chance = null) {
		if(is_numeric($reward)) {
			if(!($reward = self::get_reward_by_uid($reward))) {
				setLastError(ERROR_OBJ_NOT_EXIST);
				return false;
			}
		}
		if(!$chance) {
			$chance = array('reason' => 'share_wx', 'cnt' => 1);
		}

		if(!$user) {
			$user = array('su_uid' => AccountMod::has_su_login(),
						  'user_ip' => requestClientIP());
		}

		if($old_rule = RewardMod::get_user_reward_rule($reward['uid'], $user)) {
			$rule_uid = $old_rule['uid'];
			$rule = $old_rule['access_rule'];
		}
		else {
			$max_cnt = !empty($reward['access_rule']['max_cnt']) ? $reward['access_rule']['max_cnt'] : 0;
			$max_cnt_day = !empty($reward['access_rule']['max_cnt_day']) ? $reward['access_rule']['max_cnt_day'] : 0;

			$rule = array('max_cnt' => $max_cnt, 'max_cnt_day' => $max_cnt_day);
		}
		
		if(!empty($rule[$chance['reason']])) {
			setLastError(ERROR_OBJECT_ALREADY_EXIST);
			return false;
		}

		$rule[$chance['reason']] = $chance['cnt'];
		$rule['max_cnt'] && $rule['max_cnt'] += $chance['cnt'];
		$rule['max_cnt_day'] && $rule['max_cnt_day'] += $chance['cnt'];

		if(isset($rule_uid)) {
			Dba::update('reward_rule_user', array('access_rule' => $rule), 'uid = '.$rule_uid);
		}
		else {
			$insert = array('r_uid' => $reward['uid'],
				'access_rule' => $rule,
			);
			!empty($user['su_uid'])	 && $insert['su_uid'] = $user['su_uid'];
			!empty($user['user_ip']) && $insert['user_ip'] = $user['user_ip'];
			Dba::insert('reward_rule_user', $insert);
			$rule_uid = Dba::insertID();
		}
		
		return $rule_uid;
	}

	/*
		进行一次 抽奖
		$record = array(
			'su_uid'  =>  
			'user_ip' => 

			'do_query' => 查询是否能抽奖
		)

		查询返回true或false
		中奖返回 reward_item, 未中奖array()
	*/
	public static function do_reward($reward, $record) {
		// var_dump($reward);die;
		/*系统函数：检测变量是否为数字或者数字字符串*/
		if(is_numeric($reward)) {

			if(!($reward = self::get_reward_by_uid($reward))) {
				
				setLastError(ERROR_OBJ_NOT_EXIST);
				return false;
			}
		}

		if($reward['status'] > 0) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		//登陆检查
		if(!empty($reward['access_rule']['must_login']) && empty($record['su_uid'])) {
			setLastError(ERROR_USER_HAS_NOT_LOGIN);
			return false;
		}
		
		//用户规则, 只在必须登录下启用
		if(!empty($reward['access_rule']['must_login'])) {
			if($rule = RewardMod::get_user_reward_rule($reward['uid'], $record)) {
				$reward['access_rule'] = array_merge($reward['access_rule'], $rule['access_rule']);
			}
		}
		
		
		//提交时间检查
		if(((!empty($reward['access_rule']['start_time']) && $reward['access_rule']['start_time'] > $_SERVER['REQUEST_TIME']) ||
		   (!empty($reward['access_rule']['end_time']) && $reward['access_rule']['end_time'] < $_SERVER['REQUEST_TIME']))) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}

		//用户提交次数检查
		if(!empty($reward['access_rule']['max_cnt'])) {
			$field = !empty($record['su_uid']) ? 'su_uid' : 'user_ip';
			$sql = 'select count(*) from reward_record where r_uid = '.$reward['uid'].' && '.$field.' = "'.addslashes($record[$field]).'"';
			$max_cnt = Dba::readOne($sql);
			if($max_cnt >= $reward['access_rule']['max_cnt']) {
				setLastError(ERROR_OUT_OF_LIMIT);
				return false;
			}
		}

		//用户今日提交次数检查
		if(empty($record['uid']) && !empty($reward['access_rule']['max_cnt_day'])) {
			$field = !empty($record['su_uid']) ? 'su_uid' : 'user_ip';
			$sql = 'select count(*) from reward_record where r_uid = '.$reward['uid'].' && '.$field.' = "'.addslashes($record[$field]).'"'
					.' && create_time >= '.strtotime('today').' && create_time < '.strtotime('tomorrow');
			$max_cnt_day = Dba::readOne($sql);
			if($max_cnt_day >= $reward['access_rule']['max_cnt_day']) {
				setLastError(ERROR_OUT_OF_LIMIT);
				return false; 
			}
		}

		//用户已中奖次数检查
		if(!empty($reward['access_rule']['max_item'])) {
			$field = !empty($record['su_uid']) ? 'su_uid' : 'user_ip';
			$sql = 'select count(*) from reward_record where r_uid = '.$reward['uid'].' && '.$field.' = "'.addslashes($record[$field]).'"'.
					' && item_uid > 0';
			$max_cnt = Dba::readOne($sql);
			if($max_cnt >= $reward['access_rule']['max_item']) {
				//已中奖就不再中奖，但还是加一下抽奖记录
				//setLastError(ERROR_OUT_OF_LIMIT);
				//return false;
				$record['item_uid'] = 0;
			}
		}
		/*检查用户是否为已成交用户*/
		if(!empty($reward['access_rule']['must_deal'])){
			
			$sql = 'select * from shop_order where user_id ='.$record['su_uid'];
			$res = Dba::readOne($sql);
			// var_dump($res);die;
			if(!$res){
				setLastError(ERROR_OUT_OF_LIMIT);
			}
		}
		

		if(isset($record['do_query'])) {
			return true;
		}
		/*抽奖概率逻辑*/
		if(!isset($record['item_uid'])) {
			$items = Dba::readAllAssoc('select uid, weight from reward_item where r_uid = '.$reward['uid'].
									' && weight > 0 &&  (total_cnt = 0 || total_cnt > win_cnt)');
			$r=rand(0,9999);
			$c=0;
			$record['item_uid'] = 0;
			if($items)
			foreach($items as $i) {
				$c += $i['weight'];	
				if($r < $c) {
					$record['item_uid'] = $i['uid'];
					break;
				}
			}
		}

		/*
			指定中奖人
			$reward['access_rule']['zhiding']['$su_uid'] = '$item_uid'; 
			1. 只要是这个人，就中这个奖
			2. 其他人不会中这个奖
		*/
		$reward['access_rule']['zhiding']['343290'] = 228; 
		#$reward['access_rule']['zhiding']['320793'] = 228; 
		if(!empty($reward['access_rule']['zhiding'])) {
			if(isset($reward['access_rule']['zhiding'][$record['su_uid']])) {
				$record['item_uid'] = $reward['access_rule']['zhiding'][$record['su_uid']];
			} else {	
				if($record['item_uid'] && in_array($record['item_uid'], array_values($reward['access_rule']['zhiding']))) {
					$record['item_uid'] = 0;
				}
			}
		}

		/*开启事务处理用户抽奖过程*/
		Dba::beginTransaction(); {
			$record['create_time'] = $_SERVER['REQUEST_TIME'];
			$record['r_uid'] = $reward['uid'];
			if($record['item_uid']) {
				$sql = 'update reward_item set win_cnt = win_cnt + 1 where uid = '.$record['item_uid'].' && r_uid = '.$reward['uid'].
						' && (total_cnt = 0 || total_cnt > win_cnt)';
				if(!Dba::write($sql)) {
					$record['item_uid'] = 0;
				}
			}
			Dba::insert('reward_record', $record);
			$record['uid'] = Dba::insertID();
			Dba::write('update reward set record_cnt = record_cnt + 1'.($record['item_uid'] ? ', win_cnt = win_cnt + 1' : '').' where uid = '.$reward['uid']);
		} Dba::commit();

		if($record['item_uid']) {
            $record['item'] = RewardMod::get_reward_item_by_uid($record['item_uid']);
            RewardMod::onAfterWinReward($record, $record['item'], $reward['sp_uid']);
		}
		return $record['item_uid'] ? $record : array();
	}

	/*
		中奖后  如果是虚拟奖品则直接发放
		$record = array(
			'uid'
			'su_uid'
		)
		$item = array(
			'virtual_info'
		)
	*/
	public static function onAfterWinReward($record, $item, $sp_uid) {
		if(empty($item['virtual_info']['name']) || empty($record['su_uid'])) {
			return;
		}

		$ret = false;
        uct_use_app('sp');
        $ret = VirProdMod::send_to_user($item['virtual_info']['name'],$item['virtual_info']['coupon_uid'],$record['su_uid'],'抽奖 #'.$record['uid']);

		if($ret) {
			//标记一下已领奖
			$update = array('uid' => $record['uid'], 'su_uid' => $record['su_uid'], 'sp_remark' => 2);
			RewardMod::edit_reward_record($update);	
		}

		return $ret;
	}

	/*
	public static function get_all_virtual_items() {
		return array(
			array(
				'name' => 'store_coupon',
			),
			array(
				'name' => 'shop_coupon',
			),
		);
	}
	*/

	/*
		删除抽奖数据 

		返回删除的条数
	*/
	public static function delete_reward_record($rid, $r_uid) {
		if(is_array($rid)) {
			$ret = 0;
			foreach($rid as $r) {
				$ret += self::delete_a_reward_record($r, $r_uid);
			}
			return $ret;
		}

		return self::delete_a_reward_record($rid, $r_uid);
	}

	/*
		删除一条抽奖记录
	*/
	public static function delete_a_reward_record($rid, $r_uid) {
		$item_uid = Dba::readOne('select item_uid from reward_record where uid ='.$rid.' && r_uid = '.$r_uid);
		if(false === $item_uid) {
			return 0;
		}

		Dba::beginTransaction(); {
			Dba::write('delete from reward_record where uid = '.$rid);
			if($item_uid) {
				$sql = 'update reward_item set win_cnt = win_cnt - 1 where uid = '.$item_uid.' && r_uid = '.$r_uid;
				Dba::write($sql);
			}
			$sql = 'update reward set record_cnt = record_cnt - 1'.($item_uid ? ', win_cnt = win_cnt - 1' : '').' where uid = '.$r_uid;
			Dba::write($sql);
		} Dba::commit();

		return 1;
	}

	public static function get_reward_record_by_uid($uid) {
		return Dba::readRowAssoc('select * from reward_record where uid = '.$uid, 'RewardMod::func_get_reward_record');
	}

	/*
		获取抽奖记录列表 
	*/
	public static function get_reward_record_list($option) {
		$sql = 'select r.* from reward_record as r';
		if(!empty($option['key'])){
			$sql .= ',service_user as s';
		}
			
		if(!empty($option['r_uid'])) {
			$where_arr[] = 'r.r_uid='.$option['r_uid'];
		}
		if(!empty($option['su_uid'])) {
			$where_arr[] = 'r.su_uid = '.$option['su_uid'] ;
		}
		if(!empty($option['user_ip'])) {
			$where_arr[] = 'r.user_ip = "'.$option['user_ip'].'"' ;
		}
		if(!empty($option['sp_remark'])&&$option['sp_remark']>0) {
			$where_arr[] = 'r.sp_remark = '.$option['sp_remark'] ;
		}
		if(!empty($option['item_uid'])) {
			$where_arr[] = 'r.item_uid = '.$option['item_uid'];
		}
		if(!empty($option['create_time'])) {
			$where_arr[] = 'r.create_time >= '.$option['create_time'];
		}
		if(!empty($option['create_time_max'])) {
			$where_arr[] = 'r.create_time <= '.$option['create_time_max'];
		}
		
		if(!empty($option['is_win'])) {
			$where_arr[] = 'r.item_uid > 0';
		}
		if(!empty($option['no_remark'])) {
			$where_arr[] = 'r.sp_remark = 0';
		}
		
		if(!empty($option['key'])){
			$where_arr[] = 's.uid = r.su_uid and  s.name like "%'.addslashes($option['key']).'%"';
		}
		
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .= ' order by r.uid desc';
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'RewardMod::func_get_reward_record');
	}

	/*
		编辑抽奖记录, sp_remark  data
		
	*/
	public static function edit_reward_record($record) {

		$where = 'uid='.$record['uid'];
		if(!empty($record['su_uid'])){
			$where .= ' && su_uid = '.$record['su_uid'];
		}
		else {
			$where .= ' && user_ip = "'.$record['user_ip'].'"';
		}
		// var_dump($where);exit;
		return Dba::update('reward_record', $record, $where);
	}

	/*
	标记表单数据

	返回标记的条数
	*/
	public static function remark_reward_record($uids, $sp_remark, $r_uid) {
		if(!is_array($uids)) {
			$uids = array($uids);
		}

		$sql = 'update reward_record set sp_remark = '.$sp_remark.' where uid in ('.implode(',', $uids).') && r_uid = '.$r_uid;
		return	Dba::write($sql);
	}
}

