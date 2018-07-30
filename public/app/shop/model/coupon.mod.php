<?php

/*
	优惠劵

	注意 user_coupon_id 和 shop_coupon_id 的不同
*/

class CouponMod {
	public static function func_get_coupon($item) {
		$item['title'] = htmlspecialchars($item['title']);
		if(!empty($item['brief'])) $item['brief'] = XssHtml::clean_xss($item['brief']);
		if(!empty($item['rule'])) $item['rule'] = json_decode($item['rule'], true);
	
		return $item;
	}

	public static function func_get_user_coupon($item) {
		if(!empty($item['info'])) $item['info'] = json_decode($item['info'], true);
		if(!empty($item['order_uid'])){
			$item['used_time'] = Dba::readOne('select create_time from shop_order where uid='.$item['order_uid']);
		}
		if(!(empty($GLOBALS['_TMP']['paid_fee']))
			&& !empty($item['info']['rule']['min_price'])
			&& $GLOBALS['_TMP']['paid_fee']<$item['info']['rule']['min_price'] )
		{
			$item['out_limit_price'] = true;
		}
		return $item;
	}

		/*
			店铺优惠劵列表
		*/
	public static function get_shop_coupon_list($option) {
		$sql = 'select * from shop_coupon';
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		if(isset($option['valuation']) && $option['valuation'] >= 0) {
			$where_arr[] = 'valuation = '.$option['valuation'];
		}
		if(!empty($option['available'])) {
            $where_arr[] = '(publish_cnt = 0 || publish_cnt >= used_cnt)';
		}
        $time = time();//过期消失
        $where_arr[] = '(duration = 0 || create_time+duration >='.$time.')';
		if(!empty($option['key'])) {
			$where_arr[] = '(title like "%'.addslashes($option['key']).'%" || brief like "%'.addslashes($option['key']).'%")';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		$sort = 'uid desc';
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'CouponMod::func_get_coupon');
	}

	public static function get_shop_coupon_by_uid($uid) {
		$sql = 'select * from shop_coupon where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'CouponMod::func_get_coupon');
	}

	/*
		新增或编辑商家优惠劵
	*/
	public static function add_or_edit_shop_coupon($coupon) {
		if(!empty($coupon['uid'])) {
			Dba::update('shop_coupon', $coupon, 'uid = '.$coupon['uid'].' && shop_uid = '.$coupon['shop_uid']);
		}
		else {
			$coupon['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('shop_coupon', $coupon);
			$coupon['uid'] = Dba::insertID();
		}

		return $coupon['uid'];
	}

	/*
		删除商家优惠劵
		返回删除的条数
	*/
	public static function delete_shop_coupon($cids, $shop_uid) {
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'delete from shop_coupon where uid in ('.implode(',',$cids).') and shop_uid = '.$shop_uid;

		return Dba::write($sql);
	}

	/*
		用户优惠劵列表
	*/
	public static function get_user_coupon_list($option) {	
		$sql = 'select * from shop_user_coupon';
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		if(!empty($option['user_id'])) {
			$where_arr[] = 'user_id= '.$option['user_id'];
		}
		if(!empty($option['available'])) {
			$where_arr[] = 'order_uid = 0 && (expire_time = 0 || expire_time >= '.$_SERVER['REQUEST_TIME'].')';
		}

		if(!empty($option['unread'])) {
			$where_arr[] = 'read_time= 0';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		$sort = 'uid desc';
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'CouponMod::func_get_user_coupon');
	}

	public static function get_user_coupon_by_uid($uid) {
		$sql = 'select * from shop_user_coupon where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'CouponMod::func_get_user_coupon');
	}

	/*
		发放一张优惠劵给user_id
	*/
	public static function add_a_coupon_to_user($coupon, $user_id) {
		if(is_numeric($coupon)) $coupon = self::get_shop_coupon_by_uid($coupon);
		if(!$coupon || ($coupon['publish_cnt'] && ($coupon['used_cnt'] >= $coupon['publish_cnt']))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		//用户领取次数检查
		if(!empty($coupon['rule']['max_cnt'])) {
			$sql = 'select count(*) from shop_user_coupon where shop_uid ='.$coupon['shop_uid'].' && user_id = '.$user_id
				.' && coupon_uid = '.$coupon['uid'];
			$max_cnt = Dba::readOne($sql);
			if($max_cnt >= $coupon['rule']['max_cnt']) {
				setLastError(ERROR_OUT_OF_LIMIT);
				return false;
			}
		}

		//用户每日领取次数检查
		if(!empty($coupon['rule']['max_cnt_day'])) {
			$sql = 'select count(*) from shop_user_coupon where shop_uid ='.$coupon['shop_uid'].' && user_id = '.$user_id
				.' && coupon_uid = '.$coupon['uid'].' && create_time >= '.strtotime('today').' && create_time < '.strtotime('tomorrow');
			$max_cnt_day = Dba::readOne($sql);
			if($max_cnt_day >= $coupon['rule']['max_cnt_day']) {
				setLastError(ERROR_OUT_OF_LIMIT);
				return false;
			}
		}
		$sql = 'update shop_coupon set used_cnt = used_cnt + 1 where uid = '.$coupon['uid']
				.' && (publish_cnt = 0 || used_cnt < publish_cnt)';
		$insert = array('shop_uid' => $coupon['shop_uid'],
						'user_id' => $user_id,
						'create_time' => $_SERVER['REQUEST_TIME'],
						'expire_time' => ($coupon['duration'] ? ($_SERVER['REQUEST_TIME'] + $coupon['duration']) : 0),
						'order_uid' => 0,
						'coupon_uid' => $coupon['uid'],
						'info' => array('title' => $coupon['title'],
										'img' => $coupon['img'],
										'valuation' => $coupon['valuation'],
										'rule' => $coupon['rule'],
								),
					);

		Dba::beginTransaction(); {
			if(!Dba::write($sql)) {
				setLastError(ERROR_DB_CHANGED_BY_OTHERS);	
				Dba::rollBack();
				return false;
			}
			
			Dba::insert('shop_user_coupon', $insert);
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
			Dba::update('shop_user_coupon', $coupon, 'uid = '.$coupon['uid']);
		}
		else {
			$coupon['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('shop_user_coupon', $coupon);
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
		$sql = 'delete from shop_user_coupon where uid in ('.implode(',',$cids).') and user_id = '.$user_id;

		return Dba::write($sql);
	}

	/*
		计算优惠劵信息
		可以实现现金劵, 折扣劵, 满就减, 几件包邮等

		$coupon 优惠劵 uid
		$order_info = array(
				'user_id' => 顾客uid
				'opaid_fee' => 商品总价
				'odelivery_fee' => 邮费
				'products' => 商品列表
		)
	*/
	public static function calc_coupon_fee($coupon, $order_info) {
		if(is_numeric($coupon)) $coupon = self::get_user_coupon_by_uid($coupon);
		if(!$coupon || ($coupon['user_id'] != $order_info['user_id']) ||
			($coupon['order_uid'] || (($coupon['expire_time'] > 0) && ($coupon['expire_time'] < $_SERVER['REQUEST_TIME'])))) {
			setLastError(ERROR_DBG_STEP_1);
			return 0;
		}
		if(isset($coupon['info']['rule']['min_price']) && $coupon['info']['rule']['min_price']>$order_info['opaid_fee'])
		{
			setLastError(ERROR_DBG_STEP_2);
			return 0;
		}
		switch($coupon['info']['valuation']) {
			case 0: { //现金劵
				$ret = $coupon['info']['rule']['discount'];
				break;
			}

			default :
			return 0;
		}

		$GLOBALS['_TMP']['coupon_uid'] = $coupon['uid'];
		Event::addHandler('AfterMakeOrder', array('CouponMod', 'onAfterMakeOrder'));
		return $ret;
	}

	/*
		下单后,标记优惠劵为已使用
	*/
	public static function onAfterMakeOrder($order) {
		$sql = 'update shop_user_coupon set order_uid = '.$order['uid'].' where uid = '.$GLOBALS['_TMP']['coupon_uid'].' && order_uid = 0';
		if(!Dba::write($sql)) {
			setLastError(ERROR_DB_CHANGED_BY_OTHERS);
			Dba::rollBack();
			return false;
		}

		return true;
	}

	/*
	下单后,标记优惠劵为已使用
	*/
	public static function onAfterDeleteOrder($order) {

		$coupon_uid   = Dba::readone('select uid from shop_user_coupon where order_uid=' . $order['uid'].' and user_id='.$order['user_id']);
		if($coupon_uid)
		{
			$coupon = array('uid'=>$coupon_uid,'order_uid'=>0);
			self::add_or_edit_user_coupon($coupon);
		}
	}

	public static function do_read_user_coupon($cids,$user_id)
	{
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'update  shop_user_coupon set read_time = '.$_SERVER['REQUEST_TIME'].' where uid in ('.implode(',',$cids).') and user_id = '.$user_id;

		return Dba::write($sql);
	}

}

