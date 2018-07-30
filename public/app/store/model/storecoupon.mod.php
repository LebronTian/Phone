<?php

/*
	门店优惠劵

	线下门店核销使用, 这个与商城中的优惠券有所不同.
	门店优惠券只能在线下门店核销使用,而不能作为在线支付抵用

	注意 user_coupon_id 和 store_coupon_id 的不同
*/

class StoreCouponMod {
	public static function func_get_coupon($item) {
		$item['title'] = htmlspecialchars($item['title']);
		if(!empty($item['brief'])) $item['brief'] = XssHtml::clean_xss($item['brief']);
		if(!empty($item['rule'])) $item['rule'] = json_decode($item['rule'], true);
		if(!empty($item['store_uids'])) $item['store_uids'] = explode(';', $item['store_uids']);
	
		return $item;
	}

	public static function func_get_user_coupon($item) {
		if(!empty($item['info'])) $item['info'] = json_decode($item['info'], true);
		$item['ps_uid'] = ps_int(array($item['uid'], $item['sp_uid']));
		return $item;
	}

	/*
		商户优惠劵列表
	*/
	public static function get_store_coupon_list($option) {
		$sql = 'select * from store_coupon';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(!empty($option['store_uid'])) {
			$where_arr[] = 'store_uids like "%'.$option['store_uid'].'%"';
		}
	
		//优惠券类型  0 现金券, 1 折扣券, 2 礼品劵, 3 团购券
		if(isset($option['valuation']) && $option['valuation'] >= 0) {
			$where_arr[] = 'valuation = '.$option['valuation'];
		}
		if(!empty($option['available'])) {
			//$where_arr[] = '(publish_cnt = 0 || publish_cnt > used_cnt)';
			$where_arr[] = '(publish_cnt > used_cnt)';
		}
		if(!empty($option['key'])) {
			$where_arr[] = '(title like "%'.addslashes($option['key']).'%" || brief like "%'.addslashes($option['key']).'%")';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		$sort = 'uid desc';
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'StoreCouponMod::func_get_coupon');
	}

	public static function get_store_coupon_by_uid($uid) {
		$sql = 'select * from store_coupon where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'StoreCouponMod::func_get_coupon');
	}

	/*
		新增或编辑商家优惠劵
		coupon = array(
			...

			'rule' => array(
				'max_cnt'    => 1, //每个用户最多允许抽奖多少次, 0不限制 
				'max_cnt_day'=> 1, //每个用户每天最多允许抽奖多少次, 0不限制 
			),
	*/
	public static function add_or_edit_store_coupon($coupon) {
		if(!empty($coupon['uid'])) {
			Dba::update('store_coupon', $coupon, 'uid = '.$coupon['uid'].' && sp_uid = '.$coupon['sp_uid']);
		}
		else {
			$coupon['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('store_coupon', $coupon);
			$coupon['uid'] = Dba::insertID();
		}

		return $coupon['uid'];
	}

	/*
		删除商家优惠劵
		返回删除的条数
	*/
	public static function delete_store_coupon($cids, $sp_uid) {
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'delete from store_coupon where uid in ('.implode(',',$cids).') and sp_uid = '.$sp_uid;

		return Dba::write($sql);
	}

	/*
		用户优惠劵列表
		$option['writeoff'] 0 不限， 1 已核销， 2 未核销
	*/
	public static function get_user_coupon_list($option) {	
		$sql = 'select * from store_user_coupon';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(!empty($option['store_uid'])) {
			$where_arr[] = ' (store_uid = '.$option['store_uid'].' || info like \'%"store_uids":["'.$option['store_uid'].'"]%\')';
		}
		if(!empty($option['writeoff'])) {
			if($option['writeoff'] == 1) {
				$where_arr[] = 'used_time > 0';
			}
			else {
				$where_arr[] = 'used_time = 0';
			}
		}
		if(!empty($option['coupon_uid'])) {
			$where_arr[] = 'coupon_uid = '.$option['coupon_uid'];
		}
		if(!empty($option['user_id'])) {
			$where_arr[] = 'user_id= '.$option['user_id'];
		}
		if(!empty($option['available'])) {
			$where_arr[] = 'used_time = 0 && store_uid = 0 && (expire_time = 0 || expire_time >= '.$_SERVER['REQUEST_TIME'].')';
		}


		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		$sort = 'uid desc';
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'StoreCouponMod::func_get_user_coupon');
	}

	public static function get_user_coupon_by_uid($uid) {
		$sql = 'select * from store_user_coupon where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'StoreCouponMod::func_get_user_coupon');
	}

	/*
		发放一张优惠劵给user_id
	*/
	public static function add_a_coupon_to_user($coupon, $user_id) {
		if(is_numeric($coupon)) $coupon = self::get_store_coupon_by_uid($coupon);
		if(!$coupon || (/*$coupon['publish_cnt'] && */($coupon['used_cnt'] >= $coupon['publish_cnt']))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		//用户领取次数检查
		if(!empty($coupon['rule']['max_cnt'])) {
			$sql = 'select count(*) from store_user_coupon where sp_uid ='.$coupon['sp_uid'].' && user_id = '.$user_id
					.' && coupon_uid = '.$coupon['uid'];
			$max_cnt = Dba::readOne($sql);
			if($max_cnt >= $coupon['rule']['max_cnt']) {
				setLastError(ERROR_OUT_OF_LIMIT);
				return false;
			}
		}

		//用户每日领取次数检查
		if(!empty($coupon['rule']['max_cnt_day'])) {
			$sql = 'select count(*) from store_user_coupon where sp_uid ='.$coupon['sp_uid'].' && user_id = '.$user_id
					.' && coupon_uid = '.$coupon['uid'].' && create_time >= '.strtotime('today').' && create_time < '.strtotime('tomorrow');
			$max_cnt_day = Dba::readOne($sql);
			if($max_cnt_day >= $coupon['rule']['max_cnt_day']) {
				setLastError(ERROR_OUT_OF_LIMIT);
				return false;
			}
		}

		$sql = 'update store_coupon set used_cnt = used_cnt + 1 where uid = '.$coupon['uid']
				//.' && (publish_cnt = 0 || used_cnt < publish_cnt)';
				.' && (used_cnt < publish_cnt)';
		$insert = array('sp_uid' => $coupon['sp_uid'],
						'user_id' => $user_id,
						'create_time' => $_SERVER['REQUEST_TIME'],
						'expire_time' => (!$coupon['duration'] ? 0 :
						(($coupon['duration'] > 86400 * 30) ? $coupon['duration'] : ($_SERVER['REQUEST_TIME'] + $coupon['duration']))),
						'store_uid' => (!empty($coupon['store_uids'][0]) && count($coupon['store_uids'])== 1)?$coupon['store_uids'][0]: 0,
						'coupon_uid' => $coupon['uid'],
						'info' => array('title' => $coupon['title'],
										'img' => $coupon['img'],
										'valuation' => $coupon['valuation'],
										'store_uids' => $coupon['store_uids'],
										'rule' => $coupon['rule'],
								),
					);

		Dba::beginTransaction(); {
			if(!Dba::write($sql)) {
				setLastError(ERROR_DB_CHANGED_BY_OTHERS);	
				Dba::rollBack();
				return false;
			}
			
			Dba::insert('store_user_coupon', $insert);
			$insert['uid'] = Dba::insertID();
		} Dba::commit();

		//todo 可以发个通知消息给用户

		return $insert['uid'];
	}
	
	/*
		@deprecated
		新增或编辑用户优惠劵
	*/
	public static function add_or_edit_user_coupon($coupon) {
		if(!empty($coupon['uid'])) {
			Dba::update('store_user_coupon', $coupon, 'uid = '.$coupon['uid']);
		}
		else {
			$coupon['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('store_user_coupon', $coupon);
			$coupon['uid'] = Dba::insertID();
		}

		return $coupon['uid'];
	}

	/*
		删除用户优惠劵
		返回删除的条数
	*/
	public static function delete_user_coupon($cids, $user_id) {
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'delete from store_user_coupon where uid in ('.implode(',',$cids).') and user_id = '.$user_id;

		return Dba::write($sql);
	}

	/*
		删除用户优惠劵
		返回删除的条数
	*/
	public static function delete_user_coupon_sp($cids, $sp_uid) {
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$coupons = Dba::readAllAssoc('select count(*) as cnt, coupon_uid from store_user_coupon where uid in('.implode(',',$cids)
										.') group by coupon_uid');

		Dba::beginTransaction(); {
		$sql = 'delete from store_user_coupon where uid in ('.implode(',',$cids).') and sp_uid = '.$sp_uid;
		$ret = Dba::write($sql);

		//更新优惠券已发放的数目
		foreach($coupons as $c) {
			Dba::write('update store_coupon set used_cnt = used_cnt - '.$c['cnt'].' where uid = '.$c['uid']);
		}
		} Dba::commit();

		return $ret;
	}

	/*
		优惠劵核销

		$coupon 优惠劵 uid
		$info = array(
				'store_uid' => 核销门店uid 选填
				'user_id' => 用户uid 选填,检查优惠券是否属于该用户
		)

		返回 成功1,  失败 0
	*/
	public static function writeoff_coupon($coupon, $info) {
		if(is_numeric($coupon)) $coupon = self::get_user_coupon_by_uid($coupon);
		if(empty($info['user_id'])) $info['user_id'] = $coupon['user_id'];
		
		if(!$coupon || ($coupon['user_id'] != $info['user_id']) ||
			($coupon['used_time'] || (($coupon['expire_time'] > 0) && ($coupon['expire_time'] < $_SERVER['REQUEST_TIME'])))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return 0;
		}

		//检查一下适用门店
		if(!empty($coupon['info']['store_uids'])) { 
			//默认设为第一个门店
			empty($info['store_uid']) && $info['store_uid'] = $coupon['info']['store_uids'][0];
			if(empty($info['store_uid']) || !in_array($info['store_uid'], $coupon['info']['store_uids'])) {
				setLastError(ERROR_PERMISSION_DENIED);
				return 0;	
			}
		}

		//每天核销不超过4次 xxxxxx
		$sql = 'select count(*) from store_user_coupon where sp_uid = '.$coupon['sp_uid'].' && user_id = '.$coupon['user_id']
				.' && used_time > '.strtotime('today');
		$cnt = Dba::readOne($sql);
		if($cnt && $cnt >=4) {
			setLastError(ERROR_OUT_OF_LIMIT);
			return 0;
		}

		$update = array('used_time' => $_SERVER['REQUEST_TIME'],
						'store_uid' => !empty($info['store_uid']) ? $info['store_uid'] : 0,
					);
		Dba::update('store_user_coupon', $update, 'uid = '.$coupon['uid']);

		return 1;
	}

	/*	
		后台批量核销
		$store_uid 指定门店
		返回核销成功条数
	*/
	public static function writeoff_coupon_sp($uids, $sp_uid, $store_uid = 0) {
		$ret = 0;
		foreach($uids as $uid) {
			if(!($coupon = self::get_user_coupon_by_uid($uid)) || $coupon['sp_uid'] != $sp_uid) {
				setLastError(ERROR_OBJ_NOT_EXIST);
				continue;
			}
			$ret += self::writeoff_coupon($coupon, array('store_uid' => $store_uid));
		}
		return $ret;
	}

}

