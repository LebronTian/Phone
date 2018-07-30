<?php


class ApiCtl {
	/*
		添加编辑门店
	*/
	public function addstore() {
		if(isset($_REQUEST['name']) && !($store['name'] = requestStringLen('name', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);	}

		isset($_REQUEST['main_img']) && $store['main_img'] = requestString('main_img', PATTERN_URL);
		isset($_REQUEST['images']) && $store['images'] = implode(';', requestStringArray('images', PATTERN_URL, ';'));
		isset($_REQUEST['store_code']) && $store['store_code'] = requestString('store_code', PATTERN_NORMAL_STRING);
		isset($_REQUEST['brief']) && $store['brief'] = requestString('brief');
		isset($_REQUEST['sort']) && $store['sort'] = requestInt('sort');
		isset($_REQUEST['status']) && $store['status'] = requestInt('status');

		isset($_REQUEST['telephone']) && $store['telephone'] = requestString('telephone', PATTERN_PHONE);
		isset($_REQUEST['province']) && $store['province'] = requestString('province', PATTERN_USER_NAME); //广东省
		isset($_REQUEST['city']) && $store['city'] = requestString('city', PATTERN_USER_NAME); //深圳市
		isset($_REQUEST['town']) && $store['town'] = requestString('town', PATTERN_USER_NAME); //福田区
		isset($_REQUEST['address']) && $store['address'] = requestStringLen('address', 64); //

		isset($_REQUEST['lat']) && $store['lat'] = requestFloat('lat');
		isset($_REQUEST['lng']) && $store['lng'] = requestFloat('lng');
		if(isset($store['lng']) && isset($store['lat'])) {
			$store['geohash'] = Geohash::encode($store['lat'], $store['lng']);
		}

		if(empty($store)) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}
		isset($_REQUEST['uid']) && $store['uid'] = requestInt('uid');
		$store['sp_uid'] = AccountMod::get_current_service_provider('uid');

		outRight(StoreMod::add_or_edit_store($store));
	}

	/*
		删除商品
	*/
	public function delstore() {
		if(!($sids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(StoreMod::delete_stores($sids, AccountMod::get_current_service_provider('uid')));
	}

	/*
		获取门店列表
	*/
	public function stores() {
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['sort'] = requestInt('sort');
		$option['status'] = requestInt('status', -1); 

		$stores = StoreMod::get_store_list($option);

		outRight($stores);
	}

	/*
		添加编辑优惠劵
	*/
	public function addstorecoupon() {
		if(isset($_REQUEST['title']) && !($d['title'] = requestStringLen('title', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['store_uids']) && $d['store_uids'] = implode(';', requestIntArray('store_uids', ';'));

		isset($_REQUEST['publish_cnt']) && $d['publish_cnt'] = requestInt('publish_cnt');
		isset($_REQUEST['duration']) && $d['duration'] = requestInt('duration');

		isset($_REQUEST['image']) && $d['img'] = requestString('image', PATTERN_URL);
		isset($_REQUEST['brief']) && $d['brief'] = requestString('brief');
		isset($_REQUEST['valuation']) && $d['valuation'] = requestInt('valuation');
		isset($_REQUEST['rule']) && $d['rule'] = requestKvJson('rule'); //todo check rule

		if(empty($d)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $d['uid'] = requestInt('uid');
		$d['sp_uid'] = AccountMod::get_current_service_provider('uid');

		outRight(StoreCouponMod::add_or_edit_store_coupon($d));
	}

	/*
		删除优惠劵
	*/
	public function delstorecoupon() {
		if(!($uids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(StoreCouponMod::delete_store_coupon($uids, AccountMod::get_current_service_provider('uid')));
	}

	/*
		发优惠劵给用户
		返回发放的张数
	*/
	public function addusercoupon() {
		if(!($uid=requestInt('coupon_uid')) ||
			!($coupon = StoreCouponMod::get_store_coupon_by_uid($uid)) ||
			($coupon['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!($user_ids = requestIntArray('user_ids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!($publish_cnt = requestInt('publish_cnt', 1))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		$ret = 0;
		foreach($user_ids as $user_id) {
			for($i=0; $i < $publish_cnt; $i++) {
				if(!StoreCouponMod::add_a_coupon_to_user($coupon, $user_id)) {
					break;
				}
				$ret++;
			}
		}

		outRight($ret);
	}

	/*
		删除用户领取的优惠劵
	*/
	public function delusercoupon() {
		if(!($uids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(StoreCouponMod::delete_user_coupon_sp($uids, AccountMod::get_current_service_provider('uid')));
	}

	/*
		核销优惠劵
	*/
	public function writeoffcoupon() {
		if(!($uids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$store_uid = requestInt('store_uid');

		outRight(StoreCouponMod::writeoff_coupon_sp($uids, AccountMod::get_current_service_provider('uid'), $store_uid));
	}

	/*
		获取门店优惠券
	*/
	public function store_coupon() {
        $option['sp_uid'] = AccountMod::get_current_service_provider('uid');
        $option['store_uid'] = requestInt('store_uid');
        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', -1);
		$option['available'] = requestInt('available', 1);
        outRight(StoreCouponMod::get_store_coupon_list($option));
	}

	/*
		添加核销员
	*/
	public function addwriteoffer() {
		if(!$uids = requestIntArray('uids', ';')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['store_uids']) && $store_uids = implode(';', requestIntArray('store_uids', ';'));
		$status = requestInt('status', 1);
		
		$ret = array();
		$wo = array('sp_uid' => AccountMod::get_current_service_provider('uid'), 'status' => $status);
		isset($store_uids) && $wo['store_uids'] = $store_uids;
		foreach($uids as $u) {
			$wo['su_uid'] = $u;
			$ret[] = StoreWriteoffMod::add_or_edit_writeoffer($wo);
		}

		outRight($ret);
	}
	
	/*
		审核 核销员
	*/
	public function review_writeoffer() {
		if (!($uids = requestIntArray('uids', ';'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$status = requestInt('status');

		outRight(StoreWriteoffMod::review_writeoffer($uids, $status, AccountMod::get_current_service_provider('uid')));
	}

	/*
		删除 核销员
	*/
	public function del_writeoffer() {
		if (!($uids = requestIntArray('uids', ';'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(StoreWriteoffMod::del_writeoffer($uids, AccountMod::get_current_service_provider('uid')));
	}

	
}

