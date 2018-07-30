<?php

class ApiCtl {

    /*
     * 砍价商品表
     */
    public function get_bargains(){
        $option['sp_uid'] = AccountMod::get_current_service_provider('uid');
        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', -1);
        $option['status'] = requestInt('status', 0);//默认获取进行中商品

        outRight(BargainMod::get_bargainlist($option));
    }

	/*
	 * 添加砍价商品
	 */
	public function add_bargain()
	{
		if (isset($_REQUEST['title']) && !($option['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['all_quantity']) && $option['all_quantity'] = requestInt('all_quantity');
		isset($_REQUEST['quantity']) && $option['quantity'] = requestInt('quantity');
		isset($_REQUEST['ori_price']) && $option['ori_price'] = requestInt('ori_price');
		isset($_REQUEST['lowest_price']) && $option['lowest_price'] = requestInt('lowest_price');
		isset($_REQUEST['status']) && $option['status'] = requestInt('status');
		isset($_REQUEST['img']) && $option['img'] = requestString('img', PATTERN_URL);
		isset($_REQUEST['info']) && $option['info'] = requestString('info');
		isset($_REQUEST['product_info']) && !($option['product_info'] = requestKvJson('product_info', array(
			array('img', 'String'),
			array('p_uid', 'Int'),
		)));
		isset($_REQUEST['rule']) && !($option['rule'] = requestKvJson('rule', array(
			array('end_time', 'Int'),
			array('times', 'Int'),
			//array('unique_field', 'String', PATTERN_NORMAL_STRING),
		)));

		if (empty($option))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!empty($option['product_info']['p_uid'])){
			uct_use_app('shop');
			$product = ProductMod::get_shop_product_by_uid($option['product_info']['p_uid']);
			if(empty($product)){
				outError(ERROR_OBJ_NOT_EXIST);
			}
		}

		isset($_REQUEST['uid']) && $option['uid'] = requestInt('uid');
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');

		outRight(BargainMod::add_or_edit_bargain($option));

	}

	/*
	 * 删除砍价
	 */
	public function del_bargain()
	{
		if (!($fids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(BargainMod::delete_bargain($fids, AccountMod::get_current_service_provider('uid')));
	}

	/*
	 * 砍价状态修改
	 */
	public function edit_user_bargain_by_uid(){

		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		isset($_REQUEST['uid']) && $option['uid'] = requestInt('uid');
		isset($_REQUEST['status']) && $option['status'] = requestInt('status');

		outRight(BargainMod::add_or_edit_user_bargain($option));
	}

	/*
	 * 删除砍价
	 */
	public function del_bargain_user()
	{
		if (!($fids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(BargainMod::delete_bargain_user($fids, AccountMod::get_current_service_provider('uid')));
	}
	/*
	 * 删除帮砍
	 */
	public function del_bargain_help()
	{
		if (!($fids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(BargainMod::delete_bargain_help($fids));
	}

	public function cdo_card_img(){
		$key = 'bargain_card_img';

		if($card_img = requestString('card_img')){
			$public_uid = WeixinMod::get_current_weixin_public('uid');

			$GLOBALS['arraydb_sys'][$key] = json_encode(array('public_uid'=>$public_uid,'url'=>$card_img));
		}

		outRight($card_img);

	}

}

