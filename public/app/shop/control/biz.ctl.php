<?php
/*
	多商家入驻

	相关接口和前端页面都写在这里了

	ajax_xxx 一般是前端接口
	api_xxx 一般是管理端接口
*/

class BizCtl {
	protected function init_biz() {
		uct_use_app('su');
		if(isAjax()) {
			if(!$su_uid = AccountMod::has_su_login()) {
				outError(ERROR_USER_HAS_NOT_LOGIN);
			}
		} else {
			$su_uid = SuMod::require_su_uid();
		}
		$this->shop = ShopMod::get_shop();
		$this->biz = ShopBizMod::get_shop_biz_by_su_uid($su_uid, $this->shop['uid']);
		if(!$this->biz || $this->biz['status'] != 1) {
			if(!in_array($GLOBALS['_UCT']['ACT'], array('apply_for', 'ajax_apply', 'ajax_biz'))) {
			if(isAjax()) {
				outError(ERROR_BAD_STATUS);
			} else {
				redirectTo('?_a=shop&_u=biz.apply_for');
			}
			}
		}

		return $su_uid;
	}

	/*
		商家中心
	*/
	public function index() {
		$this->init_biz();
	}

	/*
		申请入驻
	*/
	public function apply_for() {
		$this->init_biz();
		$params = array('shop' => $this->shop, 'biz' => $this->biz);
		render_fg('', $params);
	}

	/*
		商户的商品列表
	*/
	public function productlist() {
		$this->init_biz();
		render_fg('', $params);
	}

	/*
		商户的订单列表
	*/
	public function orderlist() {
		$this->init_biz();
		render_fg('', $params);
	}

#-----------------------------
# 以下为ajax接口部分
#-----------------------------
	/*
		申请入驻	
	*/
	public function ajax_apply() {
		$su_uid = $this->init_biz();
		if($this->biz && $this->biz['status'] == 1) {
			outError(ERROR_BAD_STATUS);
		}

		if(isset($_REQUEST['title']) && !($biz['title'] = requestStringLen('title', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['main_img']) && $biz['main_img'] = requestString('main_img', PATTERN_URL);
		isset($_REQUEST['images']) && $biz['images'] = implode(';', requestStringArray('images', PATTERN_URL, ';'));
		isset($_REQUEST['per_cost']) && $biz['per_cost'] = requestInt('per_cost');
		isset($_REQUEST['score_total']) && $biz['score_total'] = requestInt('score_total');
		isset($_REQUEST['contact']) && $biz['contact'] = requestString('contact');
		isset($_REQUEST['type']) && $biz['type'] = requestString('type');
		isset($_REQUEST['location']) && $biz['location'] = requestStringLen('location', 255);
		isset($_REQUEST['lng']) && $biz['lng'] = requestFloat('lng');
		isset($_REQUEST['lat']) && $biz['lat'] = requestFloat('lat');
		isset($_REQUEST['phone']) && $biz['phone'] = requestString('phone', PATTERN_PHONE);
		isset($_REQUEST['extra_info']) && $biz['extra_info'] = requestKvJson('extra_info');
		isset($_REQUEST['brief']) && $biz['brief'] = requestString('brief');
		isset($_REQUEST['account']) && $biz['account'] = requestStringLen('account',32);
		isset($_REQUEST['passwd']) && $biz['passwd'] = requestStringLen('passwd',32);
		isset($_REQUEST['images']) && $biz['images'] = implode(';',requestStringArray('images', PATTERN_URL));

		$key = 'biz_set'.$this->shop['uid'];

		if(!$GLOBALS['arraydb_sys'][$key]){
			$GLOBALS['arraydb_sys'][$key] = json_encode(array('default_status'=>'1'));
		}
		$data = json_decode($GLOBALS['arraydb_sys'][$key],true);

		if(isset($data['default_status']))  $biz['status'] = $data['default_status'];

		$biz['shop_uid'] = $this->shop['uid'];
		$biz['su_uid'] = $su_uid;

		if(!empty($this->biz['uid'])) $biz['uid'] = $this->biz['uid'];

		if(!empty($biz['account'])){
			$account = ShopBizMod::check_biz_account($biz['account']);
			if((!empty($account))&&(!empty($biz['uid']))&&($account!=$biz['uid'])){
				outError(ERROR_OBJECT_ALREADY_EXIST);
			}
		}

		outRight(ShopBizMod::add_or_edit_shop_biz($biz));
	}

	/*
    修改账号信息
	*/
	public function edit_biz() {
		$su_uid = $this->init_biz();
		if(!$this->biz) {
			outError(ERROR_BAD_STATUS);
		}

		if(isset($_REQUEST['title']) && !($biz['title'] = requestStringLen('title', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['main_img']) && $biz['main_img'] = requestString('main_img', PATTERN_URL);
		isset($_REQUEST['images']) && $biz['images'] = implode(';', requestStringArray('images', PATTERN_URL, ';'));
		isset($_REQUEST['per_cost']) && $biz['per_cost'] = requestInt('per_cost');
		isset($_REQUEST['score_total']) && $biz['score_total'] = requestInt('score_total');
		isset($_REQUEST['contact']) && $biz['contact'] = requestString('contact');
		isset($_REQUEST['type']) && $biz['type'] = requestString('type');
		isset($_REQUEST['location']) && $biz['location'] = requestStringLen('location', 255);
		isset($_REQUEST['lng']) && $biz['lng'] = requestFloat('lng');
		isset($_REQUEST['lat']) && $biz['lat'] = requestFloat('lat');
		isset($_REQUEST['phone']) && $biz['phone'] = requestString('phone', PATTERN_PHONE);
		isset($_REQUEST['extra_info']) && $biz['extra_info'] = requestKvJson('extra_info');
		isset($_REQUEST['brief']) && $biz['brief'] = requestString('brief');
		isset($_REQUEST['account']) && $biz['account'] = requestStringLen('account',32);
		isset($_REQUEST['passwd']) && $biz['passwd'] = requestStringLen('passwd',32);

		if(empty($biz)){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$biz['shop_uid'] = $this->shop['uid'];
		$biz['uid'] = $this->biz['uid'];

		outRight(ShopBizMod::add_or_edit_shop_biz($biz));
	}

	/*
		商家列表
	*/
	public function ajax_bizlist() {
		$shop = ShopMod::get_shop();
		$option['shop_uid'] = $shop['uid'];
		isset($_REQUEST['key']) && $option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		isset($_REQUEST['type']) && $option['type'] = requestString('type', PATTERN_SEARCH_KEY);
		isset($_REQUEST['hadv']) && $option['hadv'] = requestInt('hadv');
		isset($_REQUEST['hadrecommend']) && $option['hadrecommend'] = requestInt('hadrecommend');

		$option['lng'] = requestFloat('lng');
		$option['lat'] = requestFloat('lat');
		$option['sort'] = requestInt('sort');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['status'] = 1;
		outRight(ShopBizMod::get_shop_biz_list($option));
	}

	public function ajax_biz() {
		$shop = ShopMod::get_shop();
//		if(!($uid = requestInt('uid')) ||
//			!($biz = ShopBizMod::get_shop_biz_by_uid($uid))) {
//			outError(ERROR_INVALID_REQUEST_PARAM);
//		}
//		#var_export($uid);
		#var_export($biz);
		if(!$su_uid = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$biz = ShopBizMod::get_shop_biz_by_su_uid($su_uid,$shop['uid']);
		
		outRight($biz);
	}

	public function ajax_biz_uid() {
		$shop = ShopMod::get_shop();
		$su_uid = AccountMod::has_su_login();
		if(!($uid = requestInt('uid')) ||
			!($biz = ShopBizMod::get_shop_biz_by_uid($uid))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$biz['had_fav'] = Dba::readOne('select uid from biz_fav where biz_uid = '.$uid.' and user_id = '.$su_uid);

		Dba::write('update shop_biz set read_cnt = read_cnt + 1 where uid = '.$uid);

		outRight($biz);
	}

	/*
    添加到收藏
	*/
	public function add_biz_fav(){

		$shop = ShopMod::get_shop();
		if (!($item['user_id'] = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($item['biz_uid'] = requestInt('biz_uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$biz = Dba::readOne('select uid from shop_biz where uid = '.$item['biz_uid']);
		if(!$biz){
			outError(ERROR_OBJ_NOT_EXIST);
		}

		outRight(ShopBizMod::add_or_edit_fav($item));
	}

	/*
	 * 删除收藏
	 */
	public function del_biz_fav(){
		$shop = ShopMod::get_shop();
		if (!($user_id = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uid = requestInt('uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(ShopBizMod::delete_fav($uid,$user_id));
	}

	/*
	 * 店铺收藏列表
	 */
	public function get_biz_fav(){
		$shop = ShopMod::get_shop();

		if (!($option['user_id'] = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);


		outRight(ShopBizMod::get_user_fav_list($option));
	}

	/*
    	添加编辑优惠劵
	*/
	public function addbizcoupon()
	{
		$this->init_biz();

		if (isset($_REQUEST['title']) && !($d['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['publish_cnt']) && $d['publish_cnt'] = requestInt('publish_cnt');
		isset($_REQUEST['duration']) && $d['duration'] = requestInt('duration');

		isset($_REQUEST['image']) && $d['img'] = requestString('image', PATTERN_URL);
		isset($_REQUEST['brief']) && $d['brief'] = requestString('brief');
		isset($_REQUEST['valuation']) && $d['valuation'] = requestInt('valuation');
		isset($_REQUEST['rule']) && $d['rule'] = requestKvJson('rule'); //todo check rule

		if (empty($d))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $d['uid'] = requestInt('uid');
		$d['biz_uid'] = $this->biz['uid'];

		outRight(BizCouponMod::add_or_edit_biz_coupon($d));
	}

	/*
    删除优惠劵
	*/
	public function delbizcoupon()
	{
		$this->init_biz();
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(BizCouponMod::delete_biz_coupon($uids, $this->biz['uid']));
	}

	/*
	 * 获取优惠券列表
	 */
	public function get_bizcoupon(){
		if (!($option['biz_uid'] = requestInt('biz_uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$option['key']     = requestString('key');
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);
		$option['hadshow']    = requestInt('hadshow', 1);

		$bizcoupon = BizCouponMod::get_biz_coupon_list($option);

		if (($user_id = AccountMod::has_su_login())&&(!empty($bizcoupon['list'])))
		{
			foreach($bizcoupon['list'] as $kk => $bl){

				$bizcoupon['list'][$kk]['can_get'] = 1;
				if(!$bl || ($bl['publish_cnt'] && ($bl['used_cnt'] >= $bl['publish_cnt']))) {
					$bizcoupon['list'][$kk]['can_get'] = 0;
				}
				//用户领取次数检查
				if(!empty($bl['rule']['max_cnt'])) {
					$sql = 'select count(*) from biz_user_coupon where biz_uid ='.$bl['biz_uid'].' && user_id = '.$user_id.' && coupon_uid = '.$bl['uid'];
					$max_cnt = Dba::readOne($sql);
					if($max_cnt >= $bl['rule']['max_cnt']) {
						$bizcoupon['list'][$kk]['can_get'] = 0;
					}
				}

				//用户每日领取次数检查
				if(!empty($bl['rule']['max_cnt_day'])) {
					$sql = 'select count(*) from biz_user_coupon where biz_uid ='.$bl['shop_uid'].' && user_id = '.$user_id.' && coupon_uid = '.$bl['uid'].' && create_time >= '.strtotime('today').' && create_time < '.strtotime('tomorrow');
					$max_cnt_day = Dba::readOne($sql);
					if($max_cnt_day >= $bl['rule']['max_cnt_day']) {
						$bizcoupon['list'][$kk]['can_get'] = 0;
					}
				}
				$bizcoupon['list'][$kk]['user_had'] = Dba::readOne('select uid from biz_user_coupon where user_id = '.$user_id.' and coupon_uid = '.$bl['uid'].' and use_time = 0');

				$bizcoupon['list'][$kk]['coupon_can_get'] = 0;
				if((!$bizcoupon['list'][$kk]['user_had'])&&$bizcoupon['list'][$kk]['can_get']){
					$bizcoupon['list'][$kk]['coupon_can_get'] = 1;
				}

			}
		}

		outRight($bizcoupon);
	}

	/*
	 * 查看优惠券详情
	 */
	public function bizcoupon()
	{
		if (!($coupon_uid = requestInt('coupon_uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$bizcoupon = BizCouponMod::get_biz_coupon_by_uid($coupon_uid);

		if (($user_id = AccountMod::has_su_login())&&(!empty($bizcoupon)))
		{
			$bizcoupon['can_get'] = 1;
			if(!$bizcoupon || ($bizcoupon['publish_cnt'] && ($bizcoupon['used_cnt'] >= $bizcoupon['publish_cnt']))) {
				$bizcoupon['can_get'] = 0;
			}
			//用户领取次数检查
			if(!empty($bizcoupon['rule']['max_cnt'])) {
				$sql = 'select count(*) from biz_user_coupon where biz_uid ='.$bizcoupon['biz_uid'].' && user_id = '.$user_id.' && coupon_uid = '.$bizcoupon['uid'];
				$max_cnt = Dba::readOne($sql);
				if($max_cnt >= $bizcoupon['rule']['max_cnt']) {
					$bizcoupon['can_get'] = 0;
				}
			}

			//用户每日领取次数检查
			if(!empty($bizcoupon['rule']['max_cnt_day'])) {
				$sql = 'select count(*) from biz_user_coupon where biz_uid ='.$bizcoupon['shop_uid'].' && user_id = '.$user_id.' && coupon_uid = '.$bizcoupon['uid'].' && create_time >= '.strtotime('today').' && create_time < '.strtotime('tomorrow');
				$max_cnt_day = Dba::readOne($sql);
				if($max_cnt_day >= $bizcoupon['rule']['max_cnt_day']) {
					$bizcoupon['can_get'] = 0;
				}
			}

			$bizcoupon['user_had'] = Dba::readOne('select uid from biz_user_coupon where user_id = '.$user_id.' and coupon_uid = '.$coupon_uid.' and use_time = 0');

			$bizcoupon['user_coupon'] = BizCouponMod::get_user_coupon_by_su_uid($user_id,$coupon_uid,$bizcoupon['biz_uid']);

			$bizcoupon['coupon_can_get'] = 0;
			if((!$bizcoupon['user_had'])&&$bizcoupon['can_get']){
				$bizcoupon['coupon_can_get'] = 1;
			}

		}

		outRight($bizcoupon);
	}

	/*
	 * 用户领取优惠券
	 */
	public function addbizusercoupon()
	{
		if(!($biz_uid = requestInt('biz_uid'))){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uid = requestInt('coupon_uid')) ||
			!($coupon = BizCouponMod::get_biz_coupon_by_uid($uid)) ||
			($coupon['biz_uid'] != $biz_uid)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$ret = BizCouponMod::add_a_coupon_to_user($coupon, $su_uid);

		outRight($ret);
	}

	/*
	 * 获取用户领取优惠券
	 */
	public function get_bizusercoupon(){
		if (!($option['user_id'] = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$option['biz_uid'] = requestInt('biz_uid');
		$option['coupon_uid'] = requestInt('coupon_uid');
		$option['available'] = requestInt('available');
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);
		$option['hadshow'] = requestInt('hadshow',1);

		outRight(BizCouponMod::get_user_coupon_list($option));
	}

	/*
	 * 效验优惠券信息
	 */
	public function check_userbizcoupon()
	{
		if (!($uid = requestInt('uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($su_uid = requestInt('su_uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$userbizcoupon = BizCouponMod::get_user_coupon_by_uid($uid);

		if(empty($userbizcoupon)){
			outError(ERROR_OBJ_NOT_EXIST);
		}elseif($userbizcoupon['user_id'] != $su_uid){
			outError(ERROR_OBJ_NOT_EXIST);
		}

		$bizcoupon = BizCouponMod::get_biz_coupon_by_uid($userbizcoupon['coupon_uid']);

		// 可使用：0，已使用：1,已过期：2
		if(!empty($userbizcoupon['use_time'])){
			$userbizcoupon['status'] = 1;
		}elseif(($userbizcoupon['expire_time']<$_SERVER['REQUEST_TIME'])&&($userbizcoupon['expire_time'] != 0)){
			$userbizcoupon['status'] = 2;
		}else{
			$userbizcoupon['status'] = 0;
		}

		if(empty($bizcoupon)){
			$userbizcoupon['status'] = 20;//该优惠券商家已删除
		}

		outRight($userbizcoupon);

	}

	/*
	 * 使用优惠券
	 */
	public function usebizcoupon()
	{
//		$this->init_biz();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		//用户领取优惠券id
		if (!($uid = requestInt('uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($biz_uid = requestInt('biz_uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$biz = ShopBizMod::get_shop_biz_by_uid($biz_uid);
		if(empty($biz)){
			outError(ERROR_OBJ_NOT_EXIST);
		}
		if((!in_array($su_uid,$biz['admin_uids']))&&($su_uid != $biz['su_uid'])){
			outError(ERROR_OBJ_NOT_EXIST);
		}

		outRight(BizCouponMod::use_biz_coupon($uid,$biz_uid));
	}

	/*
	 * 删除我的优惠券（status=20）
	 */
	public function edit_userbizcoupon_status()
	{
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($option['uid'] = requestInt('uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$userbizcoupon = BizCouponMod::get_user_coupon_by_uid($option['uid']);
		if(empty($userbizcoupon)){
			outError(ERROR_OBJ_NOT_EXIST);
		}
		if($userbizcoupon['user_id'] != $su_uid){
			outError(ERROR_OUT_OF_LIMIT);
		}
		$option['status'] = 20;

		outRight(BizCouponMod::add_or_edit_user_coupon($option));
	}



}

