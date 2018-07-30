<?php

class IndexCtl {
	protected function render($params = array()) {
		$GLOBALS['_UCT']['TPL'] = 'v1';
		render_fg('', $params);	
	}

	
	/*
		首页门店列表
	*/
	public function index() {
		$option['sp_uid'] = AccountMod::require_sp_uid();
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['status'] = 0;

		$stores = StoreMod::get_store_list($option);
		$params = array('stores' => $stores, 'option' => $option);
		$this->render($params);
	}

	/*
		自助领取优惠券页面
	*/
	public function coupons() {
		$option['sp_uid'] = AccountMod::require_sp_uid();
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$coupons = StoreCouponMod::get_store_coupon_list($option);
		$pagination = uct_pagination($option['page'], ceil($coupons['count']/$option['limit']), 
						'?_a=store&_u=index.coupons&limit='.$option['limit'].'&page=');

		$params = array('coupons' => $coupons, 'option' => $option, 'pagination' => $pagination);

		$this->render($params);
	}

	/*
		优惠券详情	
	*/
	public function coupondetail() {
		$sp_uid = AccountMod::require_sp_uid();
		if(!($uid = requestInt('uid')) ||
			!($coupon = StoreCouponMod::get_store_coupon_by_uid($uid)) ||
			$coupon['sp_uid'] != $sp_uid) {
			redirectTo('?_a=store');
		}

		$params = array('coupon' => $coupon);
		$this->render($params);
	}

	
	/*
		用户优惠券列表
	*/
	public function usercoupons() {
		$option['sp_uid'] = AccountMod::require_sp_uid();
		uct_use_app('su');
		$option['user_id'] = SuMod::require_su_uid();
		$option['writeoff'] = requestInt('writeoff');    //0 不限， 1 已核销， 2 未核销
		$option['available'] = requestInt('available');  //0 不限， 1 只要可用优惠券
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$coupons = StoreCouponMod::get_user_coupon_list($option);

		$pagination = uct_pagination($option['page'], ceil($coupons['count']/$option['limit']), 
						'?_a=store&_u=index.usercoupons&writeoff='.$option['writeoff'].'&available='.$option['available']
						.'&limit='.$option['limit'].'&page=');
		

		$coupons = StoreCouponMod::get_user_coupon_list($option);
		$params = array('coupons' => $coupons, 'option' => $option, 'pagination' => $pagination);

		$this->render($params);
	}

	/*
		用户优惠券详情,	可以展示一个核销二维码		
	*/
	public function usercoupondetail() {
		uct_use_app('su');
		$su_uid = SuMod::require_su_uid();
		if(!($uid = requestInt('uid')) ||
			!($coupon = StoreCouponMod::get_user_coupon_by_uid($uid)) ||
			$coupon['user_id'] != $su_uid) {
			redirectTo('?_a=store&_u=index.useercoupons');
		}

		$params = array('coupon' => $coupon);
		$this->render($params);
	}

	/*
		核销人员看到的  用户优惠券核销页面 
	*/
	public function writeoff() {
		uct_use_app('su');
		$sp_uid = AccountMod::require_sp_uid(); 
		$su_uid = SuMod::require_su_uid();
		if(!StoreWriteoffMod::check_su_writeoff_access($su_uid, $sp_uid)) {
			echo '<h2>核销员专用页面！请联系核销员核销!</h2>';
			exit();
		}

		if(!($uid = requestInt('uid')) ||
			!($coupon = StoreCouponMod::get_user_coupon_by_uid($uid)) ||
			$coupon['sp_uid'] != $sp_uid) {
			redirectTo('?_a=store');
		}
	
		$params = array('coupon' => $coupon);
		$this->render($params);
	}
}


