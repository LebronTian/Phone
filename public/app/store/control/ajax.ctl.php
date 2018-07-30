<?php

class AjaxCtl {
	/*
		给用户发一张优惠券
		必须登陆
	*/
	public function get_coupon() {
		if(!($su_uid = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		//优惠券uid, 如果不指定,那么随机抽取一张优惠券
		if(!$uid = requestInt('uid')) {
			//可以指定随机的概率
			$lucky = isset($_REQUEST['lucky']) ? requestInt('lucky', 10000) : 10000;
			if(mt_rand(0, 9999) < $lucky) {
				$option = array('sp_uid' => AccountMod::require_sp_uid(), 'available' => true, 'page' => 0, 'limit' => -1);
				$cs = StoreCouponMod::get_store_coupon_list($option);
				if(empty($cs['list'])) {
					outError(ERROR_INVALID_REQUEST_PARAM);	
				}

				$uid = $cs['list'][mt_rand(0, count($cs['list']) -1)]['uid'];
			}
		}

		if(!empty($uid)) {
			$uid = StoreCouponMod::add_a_coupon_to_user($uid, $su_uid);
			if(!$uid) {
				$ret = false;
			}
			else {
				$ret = StoreCouponMod::get_user_coupon_by_uid($uid);
			}
		}
		else {
			$ret = false;
		}
		
		outRight($ret);
	}

	/*
		用户优惠券列表
		只能看自己的
	*/
	public function user_coupons() {
		if(!($su_uid = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		//支持只取特定的一张
		if(($uid = requestInt('uid')) && ($c = CouponMod::get_user_coupon_by_uid($uid))) {
			if($c['user_id'] != $user_id) {
				$c = array();
			}
			outRight($c);
		}

		$option['store_uid'] = requestInt('store_uid');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['user_id'] = $su_uid;
		$option['available'] = requestInt('available', 1);
		outRight(StoreCouponMod::get_user_coupon_list($option));
	}

	/*
		 优惠券核销
	*/
	public function writeoff_coupon() {
		//用户优惠券uid
		if(!($uid = requestInt('uid')) && !($uid = requestPsInt('uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}

		$info = array();
		isset($_REQUEST['store_uid']) && $info['store_uid'] = requestInt('store_uid');

		/*
			//检查核销员权限
			if(!$su_uid = AccountMod::has_su_login()) {
				outError(ERROR_USER_HAS_NOT_LOGIN);
			}
			$sp_uid = AccountMod::require_sp_uid();
			if(!StoreWriteoffMod::check_su_writeoff_access($su_uid, $sp_uid, isset($info['store_uid']) ? $info['store_uid'] : null)) {
				outError(ERROR_PERMISSION_DENIED);
			}
		*/

		outRight(StoreCouponMod::writeoff_coupon($uid, $info));
	}

	/*
		获取门店优惠券
	*/
	public function store_coupon() {
        $option['sp_uid'] = AccountMod::require_sp_uid();
        $option['store_uid'] = requestInt('store_uid');
        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', 10);
		$option['available'] = 1;
        outRight(StoreCouponMod::get_store_coupon_list($option));
	}

}

