<?php
/*
	退款

*/

class RefundMod {
	const REFUND_WAIT_SHOP_ACCEEPT = 0; //待卖家确定
	const REFUND_WAIT_REFUND = 1; //待退款
	const REFUND_OK = 2; //退款成功
	const REFUND_SHOP_CANCELED = 3; //卖家拒绝退款 
	const REFUND_USER_CANCELED = 4; //买家取消退款 not used


	public static function func_get_refund($item) {
		//if(!empty($item['user_id'])) $item['user'] = AccountMod::get_service_user_by_uid($item['user_id']);
		if(!empty($item['refund_info'])) $item['refund_info'] = json_decode($item['refund_info'], true);
		return $item;
	}

	/*
		退款记录列表
	*/
	public static function get_refund_list($option) {
		$sql = 'select * from shop_order';	
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		if(!empty($option['user_id'])) {
			$where_arr[] = 'user_id = '.$option['user_id'];
		}
		if(!empty($option['status'])) {
			$where_arr[] = 'status = '.$option['status'];
		}
		if(!empty($option['uids'])) {
			$where_arr[] = 'uid in('.implode(',', $option['uids']).')';
		}
		
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		if(!empty($option['uids'])) {
			$sort = 'find_in_set(uid, "'.implode(',', $option['uids']).'")';
		}
		else {
			empty($option['sort']) && $option['sort'] = SORT_CREATE_TIME;
			switch($option['sort']) {
				default:
					$sort = 'create_time desc';
			}
		}
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'RefundMod::func_get_refund');
	}


	/*
		退款单详情
	*/
	public static function get_refund_by_order_uid($uid) {
		$sql = 'select * from shop_refund where order_uid = '.$uid;
		return Dba::readRowAssoc($sql, 'RefundMod::func_get_refund');
	}

	/*
		退款申请	
	*/
	public static function onAfterAddRefund($order) {
		$sp_uid = Dba::readOne('select sp_uid from shop where uid = ' . $order['shop_uid']);
		$msg = array(
					'title'   => '微商城 用户退款提醒',
					'content' => '您的微商城收到了用户退款申请, 请及时处理. <a href="?_a=shop&_u=sp.orderlist&key='.$order['uid'].'">点击查看</a>',
					'sp_uid'  => $sp_uid,
		);
		uct_use_app('sp');
		SpMsgMod::add_sp_msg($msg);

		uct_use_app('templatemsg');

		$su_uid = $order['user_id'];
		//		$su_uid = 1;
		$args  = Template_Msg_WxPlugMod::get_shop_args_by_order($order);
		Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__.'.'.__FUNCTION__,$sp_uid,$su_uid,$args);


	}

	/*
		 买家申请退款

		$o 订单数组
		$r = array(
			'refund_info' => 退款信息
			'refund_fee' => 退款金额
		)
	*/
	public static function do_add_refund($o, $r = array()) {
		if(in_array($o['status'], array(OrderMod::ORDER_WAIT_USER_PAY,OrderMod::ORDER_NEGOTATION_OK,
										OrderMod::ORDER_UNDER_NEGOTATION,OrderMod::ORDER_CANCELED,
									))) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		if(empty($o['paid_time']) || empty($o['paid_fee']) || empty($o['pay_type'])) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		if(Dba::readOne('select 1 from shop_refund where order_uid = '.$o['uid'])) {
			setLastError(ERROR_OBJECT_ALREADY_EXIST);
			return false;
		}

		if(!isset($r['refund_fee']) || $r['refund_fee'] <= 0 || $r['refund_fee'] > $o['paid_fee']) {
			$r['refund_fee'] = $o['paid_fee'];
		}
		!isset($r['status']) && $r['status'] = RefundMod::REFUND_WAIT_SHOP_ACCEEPT;
		!isset($r['create_time']) && $r['create_time'] = $_SERVER['REQUEST_TIME'];
		$r = array_merge($r, array(
			'order_uid'   => $o['uid'],
			'shop_uid'    => $o['shop_uid'],
			'user_id'     => $o['user_id'],
			'o_status'    => $o['status'],
		));

		Dba::beginTransaction(); {
			Dba::insert('shop_refund', $r);
			$r['uid'] = Dba::insertID();
			Dba::update('shop_order', array('status' => OrderMod::ORDER_UNDER_NEGOTATION), 'uid = '.$o['uid']);

//			可以发送通知给卖家
			$o['refund'] = $r;
			Event::handle('AfterAddRefund', array($o));
		} Dba::commit();

		return $r['uid'];
	}



	/*
		商家接受或拒绝退款
		$accept 1 接受, 0 拒绝
		$refund_info = array('sp_reason' =>  如果拒绝,可以填写拒绝理由)
	*/
	public static function do_accept_refund($r, $accept = 1, $refund_info = array()) {
		if($r['status'] != RefundMod::REFUND_WAIT_SHOP_ACCEEPT) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		$ret = true;
		if(!($order = OrderMod::get_order_by_uid($r['order_uid'])) ||
			!($order['sp_uid'] = Dba::readOne('select sp_uid from shop where uid = '.$order['shop_uid']))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		if($accept) {
			$update = array('status' => RefundMod::REFUND_WAIT_REFUND,
							'accept_time' => $_SERVER['REQUEST_TIME'],
							);
			

			$order['refund_fee'] = $r['refund_fee'];
			//$order['refund_no'] = $r['uid']; 不填可以防止重复

			$r = array_merge($r, $update);
			uct_use_app('pay');
			Dba::beginTransaction(); {
				//发起退款操作
				if($ret = PayMod::do_refund($order)) {
					//如果是支付宝, 需要跳转到退款页面
					if(getLastError() == ERROR_NEED_REDIRECT) {
						Dba::commit();
						return $ret;
					}
					else {
						//微信支付等直接退款成功
						RefundMod::do_pay_refund($r);
					}
				}
				else {
					//这里把错误日志也rollback了
					Dba::rollBack();
					return false;
				}
				Dba::update('shop_refund', $update, 'uid = '.$r['uid']);
			} Dba::commit();
		}
		else {
			Dba::beginTransaction(); {
			$update = array('status' => RefundMod::REFUND_SHOP_CANCELED,);
			if($refund_info) {
				$update['refund_info'] = array_merge(($r['refund_info'] ? $r['refund_info'] : array()), $refund_info);
			}
						
			Dba::update('shop_refund', $update, 'uid = '.$r['uid']);
				$r = RefundMod::get_refund_by_order_uid($order['uid']);
				$order['refund'] = $r;
				Event::handle('AfterAcceptRefund', array($order));
				Dba::write('update shop_order set status = '.OrderMod::ORDER_SHOP_CANCELED.' where uid = '.$r['order_uid']);
		} Dba::commit();
		}

		return $ret;
	}



	/*
	 * 商户确认退款操作  同意/拒绝
	 */
	public static function onAfterAcceptRefund($order)
	{


		$sp_uid = Dba::readOne('select sp_uid from shop where uid = ' . $order['shop_uid']);

		//		$msg = array(
//			'title'   => '微商城 用户退款提醒',
//			'content' => '您的微商城收到了用户退款申请, 请及时处理. <a href="?_a=shop&_u=sp.orderlist&key='.$order['uid'].'">点击查看</a>',
//			'sp_uid'  =>$sp_uid,
//		);
//		uct_use_app('sp');
//		SpMsgMod::add_sp_msg($msg);


		uct_use_app('templatemsg');
		$su_uid = $order['user_id'];
		//		$su_uid = 1;
		$args  = Template_Msg_WxPlugMod::get_shop_args_by_order($order);
		Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__.'.'.__FUNCTION__,$sp_uid,$su_uid,$args);

	}

	/*
		买家取消退款
	*/
	public static function do_cancel_refund($r) {
		if(!in_array($r['status'], array(RefundMod::REFUND_WAIT_SHOP_ACCEEPT, RefundMod::REFUND_SHOP_CANCELED))) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		Dba::beginTransaction(); {
			Dba::update('shop_refund', array('status' => RefundMod::REFUND_USER_CANCELED), 'order_uid = '.$r['order_uid']);
			Dba::update('shop_order', array('status' => $r['o_status']), 'uid = '.$r['order_uid'].' && status = '
						.OrderMod::ORDER_UNDER_NEGOTATION);
			$order = OrderMod::get_order_by_uid($r['order_uid']);
			Event::handle('AfterCancelRefund', array($order));
		} Dba::commit();

		return true;
	}

	public static function onAfterCancelRefund($order)
	{
		$sp_uid = Dba::readOne('select sp_uid from shop where uid = ' . $order['shop_uid']);

		$msg = array(
			'title'   => '微商城 用户取消退款提醒',
			'content' => '您的微商城收到了用户取消退款. <a href="?_a=shop&_u=sp.orderlist&key='.$order['uid'].'">点击查看</a>',
			'sp_uid'  => $sp_uid,
		);
		uct_use_app('sp');
		SpMsgMod::add_sp_msg($msg);

		uct_use_app('templatemsg');

		$su_uid = $order['user_id'];
		//		$su_uid = 1;
		$args  = Template_Msg_WxPlugMod::get_shop_args_by_order($order);
		Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__.'.'.__FUNCTION__,$sp_uid,$su_uid,$args);
	}


	/*
		在一个事务中调用 

		退款支付
		$pay_info = array(
			'refund_time' => //支付时间
		)
	*/
	public static function do_pay_refund($r, $pay_info = array()) {
		if($r['status'] != RefundMod::REFUND_WAIT_REFUND) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		$update = array('status' => RefundMod::REFUND_OK,
						'refund_time' => !empty($pay_info['refund_time']) ? $pay_info['refund_time'] : $_SERVER['REQUEST_TIME'],
						);
		Dba::update('shop_refund', $update, 'uid = '.$r['uid']);
		Dba::write('update shop_order set status = '.OrderMod::ORDER_NEGOTATION_OK.' where uid = '.$r['order_uid']);

		//退款时,删除积分, 注意这里如果积分不足会出错, 但仍然允许退款
		$order = OrderMod::get_order_by_uid($r['order_uid']);
		if($order && $order['back_point'] > 0) {
			uct_use_app('su');
			SuPointMod::decrease_user_point(array('su_uid' => $order['user_id'], 'point' => $order['back_point'], 
					'info' => '退款扣除积分 -订单号- '.$order['uid']));
		}

		//退款成功, 可以发送短信通知顾客等
		Event::handle('AfterPayRefund', array($order));
		return true;
	}

	/*
		退款成功
	*/
	public static function onAfterPayRefund($order) {
		//退款成功， 这里把库存加回去
        foreach ($order['products'] as $p) {
            ProductMod::increase_product_quantity($p['sku_uid'], $p['quantity']);
        }

		//如果订单属于某个代理的
		if(($agent_order = AgentMod::get_agent_order_by_order_uid($order['uid'])))
		{
			$a_uid = $agent_order['a_uid'];
			//删除订单表标记关系 退款用删
//			AgentMod::delete_agent_order($order['uid'],$a_uid);
			//订单数+1
			$sql = 'update shop_agent set order_count = order_count-1 where uid = '.$a_uid;
			Dba::write($sql);
			//订单总额++
			$sql = 'update shop_agent set order_fee_sum = order_fee_sum-'.$order['paid_fee'].' where uid ='.$a_uid;
			Dba::write($sql);
		}



		$sp_uid = Dba::readOne('select sp_uid from shop where uid = ' . $order['shop_uid']);

		uct_use_app('templatemsg');

		$su_uid = $order['user_id'];
		//		$su_uid = 1;
		$args  = Template_Msg_WxPlugMod::get_shop_args_by_order($order);
		Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__.'.'.__FUNCTION__,$sp_uid,$su_uid,$args);

	}

	/*
		退团
		
		直接退款	
	*/
	public static function do_refund_group($o) {
		if(!in_array($o['status'], array(OrderMod::ORDER_WAIT_GROUP_DONE))) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		$o['sp_uid'] = Dba::readOne('select sp_uid from shop where uid = '.$o['shop_uid']);

		uct_use_app('pay');
		$o['refund_fee'] = $o['paid_fee'];
			Dba::beginTransaction(); {
				//发起退款操作
				if($ret = PayMod::do_refund($o)) {
					// 如果是支付宝, 需要跳转到退款页面
					if(getLastError() == ERROR_NEED_REDIRECT) {
						//todo  这里是不支持支付宝的
						Dba::rollBack();
						return false;
						Dba::commit();
						return $ret;
					}
					else {
						//微信支付等直接退款成功
						$r = array('uid' => 0,'order_uid' => $o['uid'], 'status' => RefundMod::REFUND_WAIT_REFUND);
						RefundMod::do_pay_refund($r);
					}
				}
				else {
					//这里把错误日志也rollback了
					Dba::rollBack();
					return false;
				}
			} Dba::commit();

		return $ret;
	}

	/*
		退团 退款成功

		剩余人数+1， 订单状态 改为 已取消
	*/
	public static function onAfterPayRefundGroup($order) {
		//如果是团长退团， 那么修改一下go_uid
		if(($order['uid'] == $order['go_uid']) &&
			($go_uid = Dba::readOne('select uid from shop_order where go_uid = '.$order['uid'].
									' && uid != '.$order['uid'].' order by uid desc limit 1'))) {
		}

		Dba::write('update shop_order set remain_cnt = remain_cnt + 1'.
					(!empty($go_uid) ? ', go_uid = '.$go_uid : '').' where go_uid = '.$order['go_uid']);
		Dba::write('update shop_order set status = '.OrderMod::ORDER_CANCELED.' where uid = '.$order['uid']);

	}

}

