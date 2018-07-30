<?php

class ApiCtl {
	/*
		添加编辑分类
	*/
	public function addcat()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (isset($_REQUEST['title']) && !($cat['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['title_en']) && $cat['title_en'] = requestStringLen('title_en', 128);
		isset($_REQUEST['image']) && $cat['image'] = requestString('image', PATTERN_URL);
		isset($_REQUEST['sort']) && $cat['sort'] = requestInt('sort');
		isset($_REQUEST['status']) && $cat['status'] = requestInt('status');
		isset($_REQUEST['parent_uid']) && $cat['parent_uid'] = requestInt('parent_uid');

		if (empty($cat))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $cat['uid'] = requestInt('uid');
		$cat['shop_uid'] = $shop['uid'];

		outRight(ProductMod::add_or_edit_cat($cat));
	}

	/*
		删除分类
	*/
	public function delcat()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($cids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(ProductMod::delete_cat($cids, $shop['uid']));
	}
	/*
	 * 更新购前须知
	 */
//	public function update_konw_before()
//	{
//		if (!($shop = ShopMod::get_shop_by_sp_uid()))
//		{
//			outError(ERROR_DBG_STEP_1);
//		}
//		isset($_REQUEST['content']) && $product['content'] = requestString('content');
//		isset($_REQUEST['title']) && $product['title'] = requestString('title', PATTERN_URL);
//		isset($_REQUEST['uid']) && $product['uid'] = requestInt('uid');
//		$product['shop_uid'] = $shop['uid'];
//		$product['type_in'] = 1;
//		//
//		outRight(DocumentMod::add_or_edit_document($product));
//	}
	/*
	 * 更新文案
	 */
	public function addradio()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		isset($_REQUEST['content']) && $product['content'] = requestString('content');
		isset($_REQUEST['title']) && $product['title'] = requestString('title', PATTERN_URL);
		isset($_REQUEST['uid']) && $product['uid'] = requestInt('uid');
		$product['shop_uid'] = $shop['uid'];
		$product['type_in'] = requestInt('type_in',0);

		if($product['type_in'] == 2){
			$GLOBALS['arraydb_sys']['cfg_set_red_bag'.$shop['sp_uid']] = requestInt('send_times');;
		}
		//
		outRight(DocumentMod::add_or_edit_document($product));
	}
	/*
    删除广播
	*/
	public function delradio()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($rids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(DocumentMod::delete_radio($rids));
	}
	/*
    添加编辑活动
	*/
	public function addactivity()
	{

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (isset($_REQUEST['title']) && !($product['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['p_uid']) && $product['p_uid'] = requestString('p_uid');
		isset($_REQUEST['content']) && $product['content'] = requestString('content');
		isset($_REQUEST['act_img']) && $product['act_img'] = requestString('act_img', PATTERN_URL);
		isset($_REQUEST['start_time']) && $product['start_time'] = requestString('start_time');
		isset($_REQUEST['end_time']) && $product['end_time'] = requestString('end_time');
		isset($_REQUEST['type']) && $product['type'] = requestString('type');

		if (empty($product))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $product['uid'] = requestInt('uid');
		$product['shop_uid'] = $shop['uid'];

		//
		outRight(ActivityMod::add_or_edit_activity($product));
	}
	/*
    删除活动
	*/
	public function delactivity()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($aids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(ActivityMod::delete_activities($aids, $shop['uid']));
	}
	/*
        添加编辑地址
	*/
	public function addaddress()
	{

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}

		isset($_REQUEST['address_data']) && $addr['address_data'] = requestKvJson('address_data');

		if (empty($addr))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $addr['uid'] = requestInt('uid');
		$addr['shop_uid'] = $shop['uid'];

		outRight(AddressMod::add_or_edit_address($addr));
	}
	/*
    删除地址
	*/
	public function deladdress()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($aids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(AddressMod::delete_address($aids, $shop['uid']));
	}
	/*
	地址级名称修改
	*/
	public function upaddress()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}

		isset($_REQUEST['level']) && $addr['level'] = requestInt('level');
		isset($_REQUEST['address']) && $addr['address'] = requestString('address');
		$addr['shop_uid'] = $shop['uid'];

		outRight(Address_NameMod::update_address($addr));
	}
	/*
    创建添加配送员订单
	*/
	public function adddeliveries()
	{
        isset($_REQUEST['order_uid']) && $order_uids = requestIntArray('order_uid');
        if(!is_array($order_uids)) {
            $order_uids = array($order_uids);
        }
        $outR = array();
        foreach ($order_uids as $k => $order_uid) {

            isset($_REQUEST['uid']) && $product['uid'] = requestInt('uid');
            isset($_REQUEST['su_uid']) && $product['su_uid'] = requestString('su_uid');
            $product['order_uid']=$order_uid;
//            isset($_REQUEST['order_uid']) && $product['order_uid'] = requestInt('order_uid');
            if (empty($product)) {
                outError(ERROR_INVALID_REQUEST_PARAM);
            }
            $outR[$k] = DeliveriesMod::add_or_edit_deliveries($product);
        }

		outRight($outR);
	}
	/*
		删除配送员订单
	*/
	public function deldeliveries()
	{
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(DeliveriesMod::delete_deliveries($uids));
	}

	/*
		取uid
	*/
	public function get_product() {
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		}
		if(!($uid = requestInt('uid')) || !($p = ProductMod::get_shop_product_by_uid($uid)) ||
			$p['shop_uid'] != $shop['uid']) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight($p);
	}


	/*
		添加编辑商品
	*/
	public function addproduct()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (isset($_REQUEST['title']) && !($product['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['title_second']) && $product['title_second'] = requestString('title_second');
		isset($_REQUEST['title_third']) && $product['title_third'] = requestString('title_third');
		isset($_REQUEST['content']) && $product['content'] = requestString('content');
		isset($_REQUEST['main_img']) && $product['main_img'] = requestString('main_img', PATTERN_URL);
		isset($_REQUEST['images']) && $product['images'] = implode(';', requestStringArray('images', PATTERN_URL, ';'));
		isset($_REQUEST['price']) && $product['price'] = requestInt('price');
		isset($_REQUEST['ori_price']) && $product['ori_price'] = requestInt('ori_price');

		isset($_REQUEST['group_price']) && $product['group_price'] = requestInt('group_price');
		isset($_REQUEST['group_cnt']) && $product['group_cnt'] = requestInt('group_cnt');

		isset($_REQUEST['quantity']) && $product['quantity'] = requestInt('quantity');
		isset($_REQUEST['product_code']) && $product['product_code'] = requestString('product_code', PATTERN_NORMAL_STRING);
		isset($_REQUEST['package']) && $product['package'] = requestInt('package');
		isset($_REQUEST['send_time']) && $product['send_time'] = requestKvJson('send_time');
		isset($_REQUEST['kill_time']) && $product['kill_time'] = requestKvJson('kill_time');

		isset($_REQUEST['info']) && $product['info'] = requestInt('info');
		isset($_REQUEST['point_price']) && $product['point_price'] = requestInt('point_price'); //积分兑换所需积分数
		isset($_REQUEST['back_point']) && $product['back_point'] = requestInt('back_point'); //返还积分点数
		isset($_REQUEST['buy_limit']) && $product['buy_limit'] = requestInt('buy_limit');
		isset($_REQUEST['sku_table']) && $product['sku_table'] = requestString('sku_table');//todo check sku_table
		isset($_REQUEST['location']) && $product['location'] = requestString('location');//todo check location 
		isset($_REQUEST['delivery_uid']) && $product['delivery_uid'] = requestInt('delivery_uid');
		isset($_REQUEST['sort']) && $product['sort'] = requestInt('sort');
		isset($_REQUEST['status']) && $product['status'] = requestInt('status');
        isset($_REQUEST['cat_uid']) && $product['cat_uid'] = requestInt('cat_uid');
        isset($_REQUEST['biz_uid']) && $product['biz_uid'] = requestInt('biz_uid');
        isset($_REQUEST['bas_services']) && $product['bas_services'] = requestStringArray('bas_services');
        isset($_REQUEST['else_info']) && $product['else_info'] = requestString('else_info');
        isset($_REQUEST['video_url']) && $product['video_url'] = requestString('video_url',PATTERN_URL);
        isset($_REQUEST['product_uids']) && $product['product_uids'] = requestString('product_uids');

		isset($_REQUEST['virtual_info']) && $product['virtual_info'] = requestKvJson('virtual_info');
		isset($_REQUEST['sell_cnt']) && $product['sell_cnt'] = requestInt('sell_cnt');

		if (empty($product))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $product['uid'] = requestInt('uid');
		$product['shop_uid'] = $shop['uid'];

		outRight(ProductMod::add_or_edit_product($product));
	}
	/*
		复制商品
	*/
	public function copyproduct()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (isset($_REQUEST['uid']) && !($uid = requestInt('uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
//		$product['shop_uid'] = $shop['uid'];

		outRight(ProductMod::copy_product($uid));
	}
	/*
		删除商品
	*/
	public function delproduct()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($aids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		Event::addHandler('Afterdelete_product',array('ProductMod', 'onAfterdelete_product'));

		outRight(ProductMod::delete_products($aids, $shop['uid']));
	}

	/*
		批量上下架, 改分类 等
	*/
	public function bat_edit_product()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['status']) && $option['status'] = requestInt('status');
		isset($_REQUEST['cat_uid']) && $option['cat_uid'] = requestInt('cat_uid');
		isset($_REQUEST['biz_uid']) && $option['biz_uid'] = requestInt('biz_uid');
		isset($_REQUEST['info']) && $option['info'] = requestInt('info');
		if(empty($option)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(ProductMod::bat_edit_product($option, $uids, $shop['uid']));
	}

	/*
		获取运费模板
	*/
	public function getdelivery()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if ($uid = requestInt('uid'))
		{
			$d = DeliveryMod::get_shop_delivery_by_uid($uid);
			if (!$d || ($d['shop_uid'] != $shop['uid']))
			{
				$d = array();
			}
		}
		else
		{
			$d = DeliveryMod::get_shop_delivery($shop['uid']);
		}

		outRight($d);
	}

	/*
		添加编辑运费模板
	*/
	public function adddelivery()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (isset($_REQUEST['title']) && !($d['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['brief']) && $d['brief'] = requestString('brief');
		isset($_REQUEST['valuation']) && $d['valuation'] = requestInt('valuation');
		isset($_REQUEST['rule']) && $d['rule'] = requestString('rule'); //todo check rule

		if (empty($d))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $d['uid'] = requestInt('uid');
		$d['shop_uid'] = $shop['uid'];

		outRight(DeliveryMod::add_or_edit_delivery($d));
	}

	/*
		删除运费模板
	*/
	public function deldelivery()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($dids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(DeliveryMod::delete_shop_delivery($dids, $shop['uid']));
	}

	/*
		店铺设置
	*/
	public function set()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (isset($_REQUEST['title']) && !($new_shop['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['notice']) && $new_shop['notice'] = requestStringLen('notice',128);
		isset($_REQUEST['tpl']) && $new_shop['tpl'] = requestString('tpl', PATTERN_NORMAL_STRING);
		isset($_REQUEST['logo']) && $new_shop['logo'] = requestString('logo', PATTERN_URL);
		isset($_REQUEST['status']) && $new_shop['status'] = requestInt('status');
		isset($_REQUEST['point']) && $point = requestKvJson('point', array(
			array('point_limit', 'Float'),
			array('discount_limit', 'Int'),
			array('discount', 'Int'),
		));
		$point['discount_limit'] = $point['discount_limit']*100;
		$GLOBALS['arraydb_sys']['cfg_set_shop_discount'.$shop['uid']] = json_encode($point);

		if (isset($_REQUEST['language']))
		{
			$new_shop['language'] = requestString('language');
			if (!in_array($new_shop['language'], array('zh_cn', 'en')))
			{
				$new_shop['language'] = 'zh_cn';
			}
		}

		if (empty($new_shop))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$new_shop['uid'] = $shop['uid'];
		outRight(ShopMod::set($new_shop));
	}

	/*
		添加编辑优惠劵
	*/
	public function addshopcoupon()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
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
		$d['shop_uid'] = $shop['uid'];

		outRight(CouponMod::add_or_edit_shop_coupon($d));
	}

	/*
		删除优惠劵
	*/
	public function delshopcoupon()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(CouponMod::delete_shop_coupon($uids, $shop['uid']));
	}

	/*
		发优惠劵给用户
		返回发放的张数
	*/
	public function addusercoupon()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uid = requestInt('coupon_uid')) ||
			!($coupon = CouponMod::get_shop_coupon_by_uid($uid)) ||
			($coupon['shop_uid'] != $shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($user_ids = requestIntArray('user_ids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($publish_cnt = requestInt('publish_cnt', 1)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		$ret = 0;
		foreach ($user_ids as $user_id)
		{
			for ($i = 0; $i < $publish_cnt; $i++)
			{
				if (!CouponMod::add_a_coupon_to_user($coupon, $user_id))
				{
					break;
				}
				$ret++;
			}
		}

		outRight($ret);
	}

	/*
		退款处理 同意/拒绝
	*/
	public function acceptrefund()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uid = requestInt('uid')) ||       //订单号uid
			!($refund = RefundMod::get_refund_by_order_uid($uid)) ||
			!($refund['shop_uid'] == $shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$accept = requestBool('accept', true); //1同意退款, 0 拒绝退款
		//拒绝理由   {sp_reason: 拒不退款}
		$refund_info = requestKvJson('refund_info');
		if ($accept)
		{
			Event::addHandler('AfterPayRefund', array('RefundMod', 'onAfterPayRefund'));

		}
		else
		{
			Event::addHandler('AfterAcceptRefund', array('RefundMod', 'onAfterAcceptRefund'));

		}
		outRight(RefundMod::do_accept_refund($refund, $accept, $refund_info));
	}

	/*
		申请退款
	*/
	public function addrefund()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uid = requestInt('uid')) ||       //订单号uid
			!($order = OrderMod::get_order_by_uid($uid)) ||
			!($order['shop_uid'] == $shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//退款信息 理由,图片等  {reason: 质量不好, images: [1.jpg,2.jpg]}
		$r['refund_info'] = requestKvJson('refund_info');
		$r['refund_fee']  = requestInt('refund_fee');
		Event::addHandler('AfterAddRefund', array('RefundMod', 'onAfterAddRefund'));
		outRight(RefundMod::do_add_refund($order, $r));
	}

	/*
	 * 修改购买价格
	 */
	public function update_paid_fee()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uid = requestInt('uid')) ||       //订单号uid
			!($order = OrderMod::get_order_by_uid($uid)) ||
			!($order['shop_uid'] == $shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$r['uid'] = $uid;
		$r['paid_fee']  = requestInt('paid_fee');
		outRight(OrderMod::edit_pay_order($r));
	}

	/*
		添加编辑幻灯片
	*/
	public function addslide()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (isset($_REQUEST['title']) && !($slide['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['link']) && $slide['link'] = requestString('link', PATTERN_URL);
		isset($_REQUEST['image']) && $slide['image'] = requestString('image', PATTERN_URL);
		isset($_REQUEST['sort']) && $slide['sort'] = requestInt('sort');
		isset($_REQUEST['status']) && $slide['status'] = requestInt('status');
		isset($_REQUEST['slides_in']) && $slide['slides_in'] = requestInt('slides_in');

		if (empty($slide))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $slide['uid'] = requestInt('uid');
		$slide['shop_uid'] = $shop['uid'];

		outRight(ShopMod::add_or_edit_slide($slide));
	}

	/*
		删除幻灯片
	*/
	public function delslide()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($sids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(ShopMod::delete_slides($sids, $shop['uid']));
	}

	/*
		删除留言
	*/
	public function delmessage()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($mids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(ShopMod::delete_message($mids, $shop['uid']));
	}

	/*
		留言审核
	*/
	public function reviewmessage()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($mids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$status = requestInt('status'); //1 通过, 2 拒绝

		outRight(ShopMod::review_message($mids, $status, $shop['uid']));
	}

	/*
		商家回复留言
	*/
	public function reply_message()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		//留言uid
		if (!($m['parent_uid'] = requestInt('uid')) ||
			!($m['brief'] = requestString('brief'))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$m['shop_uid'] = $shop['uid'];

		outRight(ShopMod::reply_message($m));
	}

	/*
		获取留言列表
	*/
	public function get_messages()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		$option['user_id']  = requestInt('user_id'); //某个用户的留言
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['status']   = 1; //默认只要审核成功的
		$option['shop_uid'] = $shop['uid'];

		outRight(ShopMod::get_shop_messages($option));
	}

	public function addcomment(){
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		isset($_REQUEST['product_uid']) && $comm['product_uid'] = requestInt('product_uid');
		isset($_REQUEST['user_id']) && $comm['user_id'] = requestInt('user_id');
		isset($_REQUEST['images']) && $comm['images'] = requestStringArray('images', PATTERN_URL, ';');
		isset($_REQUEST['brief']) && $comm['brief'] = requestString('brief');

		if (empty($comm))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$comm['shop_uid'] = $shop['uid'];
		outRight(CommentMod::add_comment($comm));

	}

	/*
    删除评论
	*/
	public function delcomment()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($cids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(CommentMod::delete_comment($cids, $shop['uid']));
	}

	/*
   评论状态
	*/
	public function reviewcomment()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($mids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$status = requestInt('status'); //0正常, 1 隐藏

		$comment = CommentMod::get_shop_comment_by_uid($mids[0]);/*获取改变前的状态*/
		
		$res = CommentMod::review_comment($mids, $status, $shop['uid']);
		// var_dump($comment);die;	   
		/*判断是隐藏还是正常*/
		if(!($point = CommentMod::get_comment_point_by_shop_uid($shop['uid']))){
					outError(ERROR_DBG_STEP_1); 
		} 
	
		if($res){
			CommentMod::change_user_point($point,$comment,$status); 
		}

		


		
		outRight($res);

	}

	/*
	 * 商家回复评论
	 */

	public function reply_comment()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		//留言uid
		if (!($m['parent_uid'] = requestInt('uid')) ||
			!($m['brief'] = requestString('brief'))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$m['shop_uid'] = $shop['uid'];

		outRight(CommentMod::reply_comment($m));
	}


	/*
		删除订单
	*/
	public function delete_order()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
				
		if(!($uids = requestIntArray('uid')) && !($uids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$ret = 0;
		Event::addHandler('AfterDeleteOrder', array('CouponMod', 'onAfterDeleteOrder'));
		foreach($uids as $uid) {
			if (!($o = OrderMod::get_order_by_uid($uid)) ||
				!($o['shop_uid'] == $shop['uid'])
			){
				continue;
			}

			if(OrderMod::delete_order($o)) {
				$ret++;
			}
		}

		outRight($ret);
	}

	/*
		发货
	*/
	public function do_delivery()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		$uids = requestIntArray('uid');
		if(!is_array($uids)) {
			$uids = array($uids);
		}
		$outR = array();
		foreach ($uids as $k => $uid){
//            $uid = requestInt('uid')
			if (!($uid) ||
				!($o = OrderMod::get_order_by_uid($uid)) ||
				!($o['shop_uid'] == $shop['uid'])
			)
			{
				outError(ERROR_INVALID_REQUEST_PARAM);
			}

			if (!$deliver_info = requestKvJson('delivery_info'))
			{
				$deliver_info = array();
			}
			Event::addHandler('AfterSendGoods', array('OrderMod', 'onAfterSendGoods'));
			$outR[$k] = OrderMod::do_send_goods($o, $deliver_info);

		}

		outRight($outR);
	}

	/*
    修改快递信息
	*/
	public function edit_delivery()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		$ord['uid'] = requestInt('uid');

		if (!($ord['uid']) ||
			!($o = OrderMod::get_order_by_uid($ord['uid'])) ||
			!($o['shop_uid'] == $shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		if (!$ord['delivery_info'] = requestKvJson('delivery_info'))
		{
			$ord['delivery_info'] = array();
		}
		$outR = OrderMod::edit_order($ord);

		outRight($outR);
	}

	/*
		收货
	*/
	public function do_receipt()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uid = requestInt('uid')) ||
			!($o = OrderMod::get_order_by_uid($uid)) ||
			!($o['shop_uid'] == $shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		Event::addHandler('AfterRecvGoods', array('OrderMod', 'onAfterRecvGoods'));
		outRight(OrderMod::do_recv_goods($o));
	}


	/*
		增加或修改商品额外信息
	*/
	public function add_product_extra_info()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($pei['product_uid'] = requestInt('uid')) ||
			!($p = ProductMod::get_shop_product_by_uid($pei['product_uid'])) ||
			!($p['shop_uid'] == $shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		if (!($pei['ukey'] = requestString('ukey', PATTERN_SEARCH_KEY)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($pei['data'] = requestStringLen('data', 512)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$pei['shop_uid'] = $shop['uid'];

		outRight(ProductMod::add_product_extra_info($pei));
	}

	/*
		获取商品额外信息
	*/
	public function get_product_extra_info()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()) ||
			!($shop_uid = $shop['uid'])
		)
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($product_uid = requestInt('product_uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(ProductMod::get_product_extra_info($product_uid, $shop_uid));
	}

	/*
		删除商品额外信息
	*/
	public function delete_product_extra_info()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uid = requestInt('uid')) ||
			!($p = ProductMod::get_shop_product_by_uid($uid)) ||
			!($p['shop_uid'] == $shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		if (!($ukey = requestString('ukey', PATTERN_SEARCH_KEY)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(ProductMod::delete_product_extra_info($uid, $ukey, $shop['uid']));
	}

	/*
     * 编辑商品分销规则
     */
	public function edit_distribution_product_rule()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (
			($dtb_rule['uid'] = requestInt('uid')) &&
			(
				!($p = DistributionMod::get_product_dtb_rule_by_uid($dtb_rule['uid'])) ||
				!($p['shop_uid'] == $shop['uid'])
			)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($dtb_rule['rule_data'] = requestKvJson('rule')) ||
			(array_sum(array_column($dtb_rule['rule_data'],0)) >= 10000)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		//$dtb_rule['status']   = requestInt('status');
        if (!($dtb_rule['p_uid']  = requestInt('p_uid'))||!(Dba::readOne('select uid from product where uid ='.$dtb_rule['p_uid'].' and shop_uid = '.$shop['uid'])))
        {
            outError(ERROR_DBG_STEP_2);//没有商品id/没有该商品/已存在
        }
		$dtb_rule['shop_uid'] = $shop['uid'];
		outRight(DistributionMod::add_or_edit_product_dtb_rule($dtb_rule));
	}

	/*
	 * 编辑 分销规则
	 */
	public function edit_distribution_rule()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (
			($dtb_rule['uid'] = requestInt('uid')) &&
			(
				!($p = DistributionMod::get_dtb_rule_by_uid($dtb_rule['uid'])) ||
				!($p['shop_uid'] == $shop['uid'])
			)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($dtb_rule['rule_data'] = requestKvJson('rule')) ||
			(array_sum(array_column($dtb_rule['rule_data'],0)) >= 10000)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$dtb_rule['status']   = requestInt('status');
		$dtb_rule['need_check']   = requestInt('need_check');
		$dtb_rule['need_vip']   = requestInt('need_vip');
		$dtb_rule['shop_uid'] = $shop['uid'];
//		$dtb_rule['group_name'] = requestString('group_name');
		$dtb_rule['model'] = requestInt('model');
		$dtb_rule['fullprice'] = requestInt('fullprice');
		outRight(DistributionMod::add_or_edit_dtb_rule($dtb_rule));
	}

	/*
		删除分销用户信息
	*/
	public function delete_distribution_user()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}


		if (!($su_uid = requestIntArray('su_uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(DistributionMod::delete_distribution_user($su_uid));
	}

	public function distribution_apply(){
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		}
		if (!($user_ids = requestIntArray('user_ids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		if(!($rule = requestKvJson('rule')) || (array_sum(array_column($rule, 0)) >= 10000)) {
			$rule = array();
		}

		$status = requestInt('status');
		$ret = 0;
		foreach ($user_ids as $su_uid)
		{
			$user = AccountMod::get_service_user_by_uid($su_uid);
			$agent = array(
				'su_uid' => $su_uid,
				'status' => $status,
				'parent_su_uid'=>$user['from_su_uid'],
				'create_time'=>$_SERVER['REQUEST_TIME'],
			);

			if(!empty($rule)) {
				$agent['rule_data'] = $rule;
			}
			DistributionMod::add_or_edit_user_dtb($agent);
			$ret++;
		}

		outRight($ret);
	}

	public function set_group_distribution(){
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		}
		uct_use_app('su');
		if (!($g_uid = requestInt('g_uid')) || !($group = SuGroupMod::get_group_by_uid($g_uid)) ||
			$group['sp_uid'] != $shop['sp_uid']) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		if(!($rule = requestKvJson('rule')) || (array_sum(array_column($rule, 0)) >= 10000)) {
			$rule = array();
		}

		outRight(DistributionMod::set_su_group_dtb($g_uid, $rule));
	}

	public function review_user_dtb()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if(!($user_dtb['su_uid']= requestInt('su_uid'))||
			!($user_dtbs = DistributionMod::get_user_dtb_by_su_uid($user_dtb['su_uid']))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$user_dtb['status'] = requestInt('status');
		outRight(DistributionMod::add_or_edit_user_dtb($user_dtb));
	}

	//增加更改 商城的代理基本设置
	public function add_or_edit_shop_agent_set()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		isset($_REQUEST['status']) && $shop_agent_set['status'] = requestInt('status');
		isset($_REQUEST['need_check']) && $shop_agent_set['need_check'] = requestInt('need_check');
		isset($_REQUEST['rule_data']) && $shop_agent_set['rule_data'] = requestKvJson('rule_data');

		if(empty($shop_agent_set))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		AgentMod::check_rule_data($shop_agent_set['rule_data']);//判断rule_data 是否符合逻辑要求
		$shop_agent_set['shop_uid'] = $shop['uid'];

		outRight(AgentMod::add_or_edit_agent_set($shop_agent_set));
	}
	//获取 分销 推广链接
	public function get_distribution_url()
	{
		$su_uid = requestInt('su_uid');
		echo DomainMod::get_app_url('shop',0,array('parent_su_uid'=>$su_uid));
	}
	//获取  代理商城链接
	public function get_agent_url()
	{
		$s_a_uid = requestInt('agent_uid');
		echo DomainMod::get_app_url('shop',0,array('s_a_uid'=>$s_a_uid));

	}

	//配置可被代理商品
	public function add_or_edit_agent_product()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if(
			!($agent_product['uid'] = requestInt('uid'))
			|| !($shop_product = ProductMod::get_shop_product_by_uid($agent_product['uid'],0))
			|| !($shop_product['shop_uid'] ==$shop['uid'] )
		)
		{
//			var_dump(__file__.' line:'.__line__,AgentMod::require_agent());exit;
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['status']) && $agent_product['status'] = requestInt('status');
		isset($_REQUEST['price_l']) && $agent_product['price_l'] = requestInt('price_l');
		isset($_REQUEST['price_h']) && $agent_product['price_h'] = requestInt('price_h');
		isset($_REQUEST['rule_data']) && $agent_product['rule_data'] = requestKvJson('rule_data');
		if( isset($_REQUEST['price_h']) && isset($_REQUEST['price_l']) && ($agent_product['price_h']<$agent_product['price_l']))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['rule_data']) && AgentMod::check_rule_data($agent_product['rule_data']);//判断rule_data 是否符合逻辑要求
		$agent_product['shop_uid'] =$shop['uid'];
		outRight(AgentMod::add_or_edit_agent_product($agent_product));
	}

	/*
	 * 编辑某个代理
	 */
	public function edit_shop_agent()
	{

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if(!($shop_agent['uid'] = requestInt('uid'))
			||!($shop_agents = AgentMod::get_agent_by_uid($shop_agent['uid']))
			|| !($shop_agents['shop_uid']==$shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['status']) && $shop_agent['status'] = requestInt('status');
		if (isset($_REQUEST['notice']) && !($shop_agent['notice'] = requestStringLen('notice',128)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (isset($_REQUEST['title']) && !($shop_agent['title'] = requestStringLen('title',64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(AgentMod::add_or_edit_agent($shop_agent));
	}

	public function get_shop_agent_product()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if(!($uid = requestInt('uid'))
			|| !($p_shop_uid = Dba::readone('select shop_uid from product where uid = '.$uid))
			|| !($p_shop_uid==$shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$ret = AgentMod::get_agent_product_by_uid($uid);
		if(!$ret && empty($ret['rule_data']))
		{
			$agent_set =  AgentMod::get_agent_set_by_shop_uid($shop['uid']);
			$ret['rule_data'] =$agent_set['rule_data'];
		}
		outRight($ret);
	}

	public function edit_shop_agent_to_user_product()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (isset($_REQUEST['title']) && !($product['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['content']) && $product['content'] = requestString('content');
		isset($_REQUEST['main_img']) && $product['main_img'] = requestString('main_img', PATTERN_URL);
		isset($_REQUEST['images']) && $product['images'] = implode(';', requestStringArray('images', PATTERN_URL, ';'));
		isset($_REQUEST['price']) && $product['price'] = requestInt('price');
		isset($_REQUEST['ori_price']) && $product['ori_price'] = requestInt('ori_price');
		isset($_REQUEST['status']) && $product['status'] = requestInt('status');
		if (empty($product)
			|| !($product['a_uid'] = requestInt('a_uid'))
			|| !($product['uid'] = requestInt('uid'))
			||!($agent_to_user_product = AgentMod::get_agent_to_user_product_by_uid($product['uid'])))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		//判断是否 该代理是否属于该商户
		if( !($shop_agents = AgentMod::get_agent_by_uid($product['a_uid']))
			|| !($shop_agents['shop_uid'] = $shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);

		}
		//对售价 设置判断
		if(!(empty($product['price']))
			&& (!($agent_product = AgentMod::get_agent_product_by_uid($agent_to_user_product['p_uid']))
				|| ($product['price'] >$agent_product['price_h'])
				||($product['price'] <$agent_product['price_l']))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(AgentMod::add_or_edit_agent_to_user_product($product));
	}

	public function add_shop_agent_to_user_product()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		$p_uids = requestIntArray('p_uids');
		$user_product['a_uid'] = requestInt('a_uid');
		//判断是否 该代理是否属于该商户
		if( !($shop_agents = AgentMod::get_agent_by_uid($user_product['a_uid']))
			|| !($su = AccountMod::get_service_user_by_uid($shop_agents['su_uid']))
			|| !($su['sp_uid'] == AccountMod::get_current_service_provider('uid'))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$p_uids = Dba::readAllOne('select uid from shop_agent_product where uid in ('.implode(',',$p_uids).')');

		$user_product['status']  = 1;  //添加时 默认处于下架状态

		foreach($p_uids as $p_uid)
		{
			$user_product['p_uid']  = $p_uid;
			$product = ProductMod::get_shop_product_by_uid($p_uid,0);
			$agent_product = AgentMod::get_agent_product_by_uid($p_uid);
			$user_product['price'] = $agent_product['price_h']; // 默认配置 最高价格
			$user_product['ori_price'] = $product['ori_price'];
			$user_product['title'] = $product['title'];
			$user_product['content'] = $product['content'];
			$user_product['main_img'] = $product['main_img'];
			$user_product['images'] =  implode(';', $product['images']);;
			AgentMod::add_or_edit_agent_to_user_product($user_product);
		}
		outRight(Dba::affectedRows());
	}

    public function get_tpls() {
        $option['key'] = requestString('key', PATTERN_SEARCH_KEY);
        $option['type'] = requestString('type');
        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', 10);
        outRight(SptplMod::get_tpls_list($option));
    }

	/*
		获取商城优惠券
	*/
	public function shop_coupon() {
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		}
        $option['shop_uid'] = $shop['uid'];
        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', -1);
		$option['available'] = requestInt('available', 1);
        outRight(CouponMod::get_shop_coupon_list($option));
	}

	public function setcolors(){
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		}
		$GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']] =requestString('color1', PATTERN_NORMAL_STRING);
		$GLOBALS['arraydb_sys']['cfg_shop_setcolor_2'.$shop['sp_uid']] = requestString('color2', PATTERN_NORMAL_STRING);
		
		if(isset($_REQUEST['theme'])) {
			$GLOBALS['arraydb_sys']['theme_'.$shop['sp_uid']] = requestString('theme', PATTERN_NORMAL_STRING);
		}
		
		outRight(true);
	}

    /*
    删除商品
*/
    public function deldistribution_product()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        if (!($aids = requestIntArray('uids')))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        outRight(DistributionMod::delete_distribution_products($aids, $shop['uid']));
    }

	/*
		商家入驻
	*/
	public function addbiz() {
        if (!($shop = ShopMod::get_shop_by_sp_uid())) {
            outError(ERROR_DBG_STEP_1);
        }
		if(isset($_REQUEST['title']) && !($biz['title'] = requestStringLen('title', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['main_img']) && $biz['main_img'] = requestString('main_img', PATTERN_URL);
		isset($_REQUEST['images']) && $biz['images'] = implode(';', requestStringArray('images', PATTERN_URL, ';'));
		isset($_REQUEST['type']) && $biz['type'] = requestString('type', PATTERN_USER_NAME);
		isset($_REQUEST['per_cost']) && $biz['per_cost'] = requestInt('per_cost');
		isset($_REQUEST['score_total']) && $biz['score_total'] = requestInt('score_total');
		isset($_REQUEST['read_cnt']) && $biz['read_cnt'] = requestInt('read_cnt');
		isset($_REQUEST['location']) && $biz['location'] = requestStringLen('location', 255);
		isset($_REQUEST['lng']) && $biz['lng'] = requestFloat('lng');
		isset($_REQUEST['lat']) && $biz['lat'] = requestFloat('lat');
		isset($_REQUEST['contact']) && $biz['contact'] = requestString('contact');
		isset($_REQUEST['phone']) && $biz['phone'] = requestString('phone', PATTERN_PHONE);
		isset($_REQUEST['extra_info']) && $biz['extra_info'] = requestKvJson('extra_info');
		isset($_REQUEST['brief']) && $biz['brief'] = requestString('brief');
		isset($_REQUEST['status']) && $biz['status'] = requestInt('status');
		isset($_REQUEST['hadv']) && $biz['hadv'] = requestInt('hadv');
		isset($_REQUEST['hadrecommend']) && $biz['hadrecommend'] = requestInt('hadrecommend');
		isset($_REQUEST['sort']) && $biz['sort'] = requestInt('sort');

		isset($_REQUEST['account']) && $biz['account'] = requestStringLen('account',32);
		isset($_REQUEST['passwd']) && $biz['passwd'] = requestString('passwd');

		isset($_REQUEST['su_uid']) && $biz['su_uid'] = requestInt('su_uid');
		$biz['admin_uids'] = requestStringArray('admin_uids');

		isset($_REQUEST['uid']) && $biz['uid'] = requestInt('uid');
		$biz['shop_uid'] = $shop['uid'];
		if(isset($biz['su_uid']) && 
			($biz_uid = Dba::readOne('select uid from shop_biz where su_uid = '.$biz['su_uid']))){
			//修改资料用户可以修改自己，添加时不行
			if(((!empty($biz['uid']))&&$biz_uid != $biz['uid'])||(empty($biz['uid']))){
				outError(ERROR_USERNAME_ALREADY_EXIST);
			}

		}

		if(!empty($biz['account'])){
			$account = ShopBizMod::check_biz_account($biz['account']);
			if((!empty($account))&&(!isset($biz['uid']) || ($account!=$biz['uid']))){
				outError(ERROR_OBJECT_ALREADY_EXIST);
			}
		}
		
		outRight(ShopBizMod::add_or_edit_shop_biz($biz));
	}

	public function delbiz(){
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(ShopBizMod::delete_shop_biz($uids,$shop['uid']));
	}

	public function edit_biz_set(){
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		}
		$key = 'biz_set'.$shop['uid'];
		$default_status = requestInt('default_status');

		$GLOBALS['arraydb_sys'][$key] = json_encode(array('default_status'=>$default_status));
		outRight(json_decode($GLOBALS['arraydb_sys'][$key],true));
	}

	/*
	添加编辑优惠劵
	*/
	public function add_or_edit_bizcoupon()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		}

		if (isset($_REQUEST['title']) && !($d['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['publish_cnt']) && $d['publish_cnt'] = requestInt('publish_cnt');
		isset($_REQUEST['used_cnt']) && $d['used_cnt'] = requestInt('used_cnt');
		isset($_REQUEST['duration']) && $d['duration'] = requestInt('duration');

		isset($_REQUEST['image']) && $d['img'] = requestString('image', PATTERN_URL);
		isset($_REQUEST['brief']) && $d['brief'] = requestString('brief');
		isset($_REQUEST['valuation']) && $d['valuation'] = requestInt('valuation');
		isset($_REQUEST['rule']) && $d['rule'] = requestKvJson('rule'); //todo check rule
		isset($_REQUEST['status']) && $d['status'] = requestInt('status');

		if (empty($d))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!($d['biz_uid'] = requestInt('biz_uid'))){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $d['uid'] = requestInt('uid');

		outRight(BizCouponMod::add_or_edit_biz_coupon($d));
	}

	/*
	删除优惠劵
	*/
	public function delbizcoupon()
	{

		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($biz_uid = requestInt('biz_uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(BizCouponMod::delete_biz_coupon($uids, $biz_uid));
	}

	/*
	删除领取优惠劵
	*/
	public function delbizusercoupon()
	{

		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($biz_uid = requestInt('biz_uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(BizCouponMod::delete_user_coupon($uids, $biz_uid));
	}

	/*
		退团操作
	*/
	public function dorefundgroup()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uid = requestInt('uid')) ||       //订单号uid
			!($order = OrderMod::get_order_by_uid($uid)) ||
			!($order['shop_uid'] == $shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		Event::addHandler('AfterPayRefund', array('RefundMod', 'onAfterPayRefundGroup'));
		outRight(RefundMod::do_refund_group($order));
	}

	/*
		开团 人数不够的时候也能开
	*/
	public function opengroup() {
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uid = requestInt('uid')) ||       //订单号uid
			!($order = OrderMod::get_order_by_uid($uid)) ||
			!($order['shop_uid'] == $shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(OrderMod::do_open_group($order));
	}

	/*
	 * 添加商家分类
	 */
	public function addbizcat()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (isset($_REQUEST['title']) && !($cat['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['title_en']) && $cat['title_en'] = requestStringLen('title_en', 128);
		isset($_REQUEST['image']) && $cat['image'] = requestString('image', PATTERN_URL);
		isset($_REQUEST['sort']) && $cat['sort'] = requestInt('sort');
		isset($_REQUEST['status']) && $cat['status'] = requestInt('status');
		isset($_REQUEST['parent_uid']) && $cat['parent_uid'] = requestInt('parent_uid');

		if (empty($cat))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $cat['uid'] = requestInt('uid');
		$cat['shop_uid'] = $shop['uid'];

		if(!empty($cat['parent_uid'])&&$cat['uid']==$cat['parent_uid']){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(ShopBizMod::add_or_edit_biz_cat($cat));
	}

	/*
	删除分类
	*/
	public function delbizcat()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}
		if (!($cids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(ShopBizMod::delete_biz_cat($cids, $shop['uid']));
	}

	/*
    添加修改打印机
	*/
	public function addguguji() {
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		}

		isset($_REQUEST['name']) && $data['name'] = requestStringLen('name',64);
		isset($_REQUEST['ak']) && $data['ak'] = requestString('ak');
		isset($_REQUEST['memobirdid']) && $data['memobirdid'] = requestString('memobirdid');
		isset($_REQUEST['useridentifying']) && $data['useridentifying'] = requestString('useridentifying');
		isset($_REQUEST['status']) && $data['status'] = requestInt('status');
		isset($_REQUEST['count']) && $data['count'] = requestInt('count', 1);
		isset($_REQUEST['data']) && $data['data'] = requestKvJson('data',array(
			array('times', 'Int',1),
		));

		isset($_REQUEST['type']) && $data['type'] = requestString('type');
		isset($_REQUEST['params']) && $data['params'] = requestKvJson('params');
		

		if(empty($data)){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$data['sp_uid'] = $shop['sp_uid'];
		isset($_REQUEST['uid']) && $data['uid'] = requestInt('uid');

		outRight(GugujiMod::add_or_edit_guguji($data));
	}

	public function delguguji(){
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(GugujiMod::delete_guguji($uids,$shop['sp_uid']));
	}

	/*
    测试打印
	*/
	public function testprint() {
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		}

		$g['type'] = requestString('type');
		$g['name'] = requestStringLen('name',64);
		$g['ak'] = requestString('ak');
		$g['memobirdid'] = requestString('memobirdid');
		$g['useridentifying'] = requestString('useridentifying');
		$g['params'] = requestKvJson('params');
		$g['status'] = 1;

		outRight(GugujiMod::do_print($g['name'].' 工作正常！', $g));
	}

	/*
	 * 测试咕咕机打印
	 */
	public function testguguji(){
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		}
		if (!($uid = requestInt('uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		include_once UCT_PATH.'vendor/gugu/memobird.php';
		$type = 'T';
		$guguji = GugujiMod::get_guguji_by_uid($uid);
		if(empty($guguji)){
			return;
		}

		$mem = new memobird($guguji['ak']);
		$showapi = $mem->getUserId($guguji['memobirdid'],$guguji['useridentifying']);
		$user = json_decode($showapi,true);
		if(empty($user['showapi_userid'])){
//            outError(ERROR_INVALID_REQUEST_PARAM);
			return;
		}

		$content = '打印成功！';
		$content .= "\r\n"."------------"."\r\n";
		$content .= 'END';

		$data = $mem->contentSet($type,$content);
		$ret = $mem->printPaper($data,$guguji['memobirdid'],$user['showapi_userid']);
		outRight($ret);
	}

	/*
	 * 页面修改
	 */
	public function setview()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			outError(ERROR_DBG_STEP_1);
		}

		isset($_REQUEST['mks']) && $option['mks'] = requestStringArray('mks');

		if (empty($option))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $option['uid'] = requestInt('uid');
		$option['shop_uid'] = $shop['uid'];

		outRight(ShopMod::set_index($option));
	}

	/*
		获取商品列表
	*/
	public function products()
	{
		$shop = ShopMod::get_shop_by_sp_uid();
		$option['shop_uid'] = $shop['uid'];
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['sort']     = requestInt('sort');
		$option['cat_uid']  = requestInt('cat_uid');
		//获取分类子项
		if(!empty($option['cat_uid'])){
			$cats = ProductMod::get_all_sons_product_cats(array('shop_uid'=>$shop['uid'],'uid'=>$option['cat_uid']));
			if(!is_array($option['cat_uid'])){
				$option['cat_uid'] = array($option['cat_uid']);
			}
			foreach($cats as $c){
				array_push($option['cat_uid'],$c['uid']);
				foreach($c['son_cats'] as $sc){
					array_push($option['cat_uid'],$sc['uid']);
				}
			}
		}
		//指定商家的商品 
		$option['biz_uid']  = requestInt('biz_uid');
		//只要平台的商品
		isset($_REQUEST['is_biz']) && $option['is_biz'] = requestBool('is_biz');
		//是否为团购商品
		isset($_REQUEST['is_group']) && $option['is_group'] = requestBool('is_group');
		$option['status']   = 0; //只要上架的商品
		if (isset($_REQUEST['ukeys']))
		{
			//多选分类搜索 如 {品牌:[iphone, nokia], 厂家:[富士康]}
			if (!($option['ukeys'] = requestKvJson('ukeys')))
			{
				$option['ukeys'] = true;
			}
		}
		isset($_REQUEST['uids']) && $option['uids'] = requestIntArray('uids');

		//32秒杀商品 64 热门商品, 128 推荐商品
		isset($_REQUEST['info']) && $option['info'] = requestInt('info');
		$products = ProductMod::get_shop_products($option);

		outRight($products);
	}

	/*
		设置
	*/
	public function comment_cfg() {
		$cfg = requestKvJson('cfg');
		$shop = ShopMod::get_shop_by_sp_uid();

		outRight(CommentMod::set_comment_cfg($shop['uid'], $cfg));
	}

}

