<?php

/*
	一元夺宝
*/
class IndianaMod {
    const ORDER_WAIT_USER_PAY = 1; //待付款
    const ORDER_WAIT_FOR_OPEN = 2; //待开奖
    const ORDER_NOT_WIN   = 3; //未中奖
    const ORDER_WIN = 4; //已中奖
    const ORDER_CANCELED = 10; //已取消

	const CODE_BASE = 10000001; //幸运编号起始
 
	public static function func_get_indiana($item) {
		if(!empty($item['product_uid'])) { //取一下商品信息
			$item['product'] = Dba::readRowAssoc('select title, main_img, info, uid, images from product where uid = '.$item['product_uid']);
			if(!empty($item['product']['images'])) $$item['product']['images'] = explode(';', $item['product']['images']);
		}
			
		!empty($item['win_info']) && $item['win_info'] = json_decode($item['win_info'], true);
		return $item;
	}

	public static function func_get_indiana_record($item) {
		return $item;
	}

	public static function func_get_indiana_order($item) {
		return $item;
	}

	/*
		添加或编辑夺宝商品 
	*/
	public static function add_or_edit_indiana($pi) {
		if(!empty($pi['uid'])) {
			unset($pi['product_uid']);
			Dba::update('product_indiana', $pi, 'uid = '.$pi['uid'].' and shop_uid = '.$pi['shop_uid']);
		}
		else {
			if((!$p = Dba::readOne('select shop_uid from product where uid = '.$pi['product_uid'])) ||
				($p != $pi['shop_uid'])) {
				setLastError(ERROR_OBJ_NOT_EXIST);
				return false;
			}			

			unset($pi['uid']);
			$pi['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('product_indiana', $pi);
			$pi['uid'] = Dba::insertID();
		}

		return $pi['uid'];
	}

	/*
		取一元夺宝商品列表 
	*/
	public static function get_indiana_list($option) {
		$sql = 'select * from product_indiana';
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		if(!empty($option['product_uid'])) {
			$where_arr[] = 'product_uid = '.$option['product_uid'];
		}

		//参与人次未满
		if(!empty($option['available'])) {
			$where_arr[] = 'price_cnt > total_cnt';
		}
		//等待开奖
		if(!empty($option['waiting_result'])) {
			$where_arr[] = 'price_cnt = total_cnt && !win_info';
		}
		if(!empty($option['not_open'])) {
			$where_arr[] = 'win_info = ""';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		
		$sort = ' order by uid desc';
		$sql .= $sort;
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'IndianaMod::func_get_indiana');
	}

	public static function get_indiana_by_uid($uid) {
		$sql = 'select * from product_indiana where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'IndianaMod::func_get_indiana');
	}

	/*
		下订单

		$order = array(
			'shop_uid'
			'user_id'
			'i_uid' => 商品期号
			'quantity' => 购买次数
		)
	*/
	public static function make_a_indiana_order($order) {
		if(is_numeric($order['i_uid'])) {
			$order['i_uid'] = IndianaMod::get_indiana_by_uid($order['i_uid']);
		}
		if(empty($order['i_uid']) || ($order['i_uid']['shop_uid'] != $order['shop_uid'])) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		if($order['i_uid']['total_cnt'] + $order['quantity'] > $order['i_uid']['price_cnt']) {
			setLastError(ERROR_OUT_OF_LIMIT);
			return false;
		}

		$order['use_cash'] = $order['quantity'] * 100;	//1元一份，单位为分
		$order['i_uid'] = $order['i_uid']['uid'];
		$order['status'] = IndianaMod::ORDER_WAIT_USER_PAY;
		$order['create_time'] = $_SERVER['REQUEST_TIME'];
		$order['user_ip'] = requestClientIP();

		Dba::beginTransaction(); {
			//减人次, 但不分配幸运编号，支付成功后才分配
			if(!IndianaMod::decrease_indiana_product_quantity($order['i_uid'], $order['quantity'])) {
				Dba::rollBack();
				return false;
			}
			Dba::insert('product_indiana_order', $order);
			$order['uid'] = Dba::insertID();

			Event::handle('AfterMakeIndianaOrder', array($order));
		} Dba::commit();
		
		//直接余额支付, 失败直接删除订单
		if(!IndianaMod::do_cash_pay_order($order)) {
			IndianaMod::delete_order($order);
			return false;
		}

		return $order['uid'];
	}

    /*
        订单详情
    */
    public static function get_indiana_order_by_uid($uid)
    {
        $sql = 'select * from product_indiana_order where uid = ' . $uid;

        return Dba::readRowAssoc($sql, 'IndianaMod::func_get_indiana_order');
    }

	/*
		余额支付
		只能用余额付款，(现金先充值再支付). 这样减人次和分配幸运码成了一个统一的过程反而简单
	*/
	public static function do_cash_pay_order($order) {
        if ($order['status'] != OrderMod::ORDER_WAIT_USER_PAY) {
            setLastError(ERROR_BAD_STATUS);
            return false;
        }
		uct_use_app('su');
		$record = array('su_uid' => $order['user_id'],
						'cash' => $order['use_cash'],
						'info' => '一元夺宝订单支付 #'.$order['uid'],
					);
			
			Dba::beginTransaction(); {
				//1. 扣余额
				if(!SuPointMod::decrease_user_cash($record)) {
					Dba::rollBack();
					return false;
				}

				//以下是支付成功
				//2. 分配幸运编号
				if(!$start_code = IndianaMod::increase_indiana_product_code($order['i_uid'], $order['quantity'])) {
					Dba::rollBack();
					return false;
				}

				//3. 更新订单状态
				list($ms, $s) = explode(' ', microtime());
				$ms = floor((date('His', $s) + $ms) * 1000);
				$update = array('status' => IndianaMod::ORDER_WAIT_FOR_OPEN, 'start_code' => $start_code,
								'paid_time' => $s, 'paid_time_ms' => $ms);
				Dba::update('product_indiana_order', $update, 'uid = '.$order['uid']);
				
				//幸运编号分配完后触发开奖动作
				$order = array_merge($order, $update);
				IndianaMod::onAfterIndianaOrderPay($order);
				Event::handle('AfterIndianaOrderPay', array($order));
			} Dba::commit();	
		
			return true;
	}

	/*
		取消订单
		只有未付款的可以取消
	*/
	public static function do_cancel_order($order) {
        if (!in_array($order['status'], array(IndianaMod::ORDER_WAIT_USER_PAY,
            ))){
            setLastError(ERROR_BAD_STATUS);
            return false;
        }

        $update = array(
            'status' => IndianaMod::ORDER_CANCELED,
        );
        Dba::beginTransaction();
        {
            Dba::update('product_indiana_order', $update, 'uid = '.$order['uid']);
            //取消订单, 把人次加回去
        	IndianaMod::increase_indiana_product_quantity($order['i_uid'], $order['quantity']);
        }
        Dba::commit();

        return true;
	}

    /*
        删除订单

        只有已取消的和未付款的订单可以删除
    */
    public static function delete_order($o)
    {
        //先取消一下
        if ($o['status'] == IndianaMod::ORDER_WAIT_USER_PAY) {
            IndianaMod::do_cancel_order($o);
        }

        if (!in_array($o['status'], array(IndianaMod::ORDER_CANCELED, IndianaMod::ORDER_WAIT_USER_PAY))) {
            setLastError(ERROR_BAD_STATUS);
            return false;
        }

        $sql = 'delete from product_indiana_order where uid = ' . $o['uid'];
        Dba::beginTransaction();
        {
            Dba::write($sql);
            Event::handle('AfterDeleteIndianaOrder', array($o));
        }
        Dba::commit();

        return true;
    }

	/*
    	下单成功 清除一下购物车, 加一个15分钟后自动取消任务
	*/
	public static function onAfterMakeIndianaOrder($order) {
        //删除购物车
        if ((!empty($GLOBALS['_TMP']['cart_uid']))) {
            $cart_uids = $GLOBALS['_TMP']['cart_uid'];
            is_numeric($cart_uids) && $cart_uids = array($cart_uids);
            OrderMod::delete_shop_cart($cart_uids, $order['shop_uid'], $order['user_id']);
        }

		//没有必要加了，现在下单成功直接余额支付，失败删除订单
		//Queue::do_job_at($_SERVER['REQUEST_TIME'] + 15 * 60, 'shop_indiana_CancelJob', array($order['uid']));
	}

	/*
		支付成功
		生成幸运编号记录
	*/
	public static function onAfterIndianaOrderPay($order) {
		$ip = requestClientIP();
		$code = $order['start_code'];

		$records = array();
		for($i = 0; $i < $order['quantity']; $i++) {
			$records[] = array(
				'i_uid'   => $order['i_uid'],
				'su_uid'  => $order['user_id'],
				'user_ip' => $ip,
				'create_time' => $order['paid_time'],
				'create_time_ms' => $order['paid_time_ms'],
				'code' => $code,
			);
			
			$code++;
		}

		foreach(array_chunk($records, 100) as $rs) {
			Dba::insertS('product_indiana_record', $rs);
		}
		
	}
	
	/*
		下单后减人次	
	*/
	public static function decrease_indiana_product_quantity($i_uid, $quantity = 1) {
		do{
			$pi =  Dba::readRowAssoc('select uid, price_cnt, total_cnt from product_indiana where uid = '.$i_uid);
			if($pi['price_cnt'] < $pi['total_cnt'] + $quantity) {
				setLastError(ERROR_INVALID_REQUEST_PARAM);
				return false;
			}
			$sql = 'update product_indiana set total_cnt = total_cnt + '.$quantity.' where uid = '.$pi['uid'].
					' && price_cnt >= total_cnt + '.$quantity;
		} while(!Dba::write($sql));

		return true;
	}

	/*
		取消订单后加回人次	
	*/
	public static function increase_indiana_product_quantity($i_uid, $quantity) {
		do{
			$pi =  Dba::readRowAssoc('select uid, price_cnt, total_cnt from product_indiana where uid = '.$i_uid);
			if($pi['total_cnt'] < $quantity) {
				setLastError(ERROR_INVALID_REQUEST_PARAM);
				return false;
			}
			$sql = 'update product_indiana set total_cnt = total_cnt - '.$quantity.' where uid = '.$pi['uid'].
					' && total_cnt >= '.$quantity;
		} while(!Dba::write($sql));

		return true;
	}

	/*
		支付成功后分配幸运编号
		返回起始编号

		分配以后不支持退回
		全部分配完后触发一下开奖动作
	*/
	public static function increase_indiana_product_code($i_uid, $quantity) {
		do{
			$pi =  Dba::readRowAssoc('select uid, price_cnt, code_cnt from product_indiana where uid = '.$i_uid);
			if($pi['price_cnt'] < $quantity + $pi['code_cnt']) {
				setLastError(ERROR_INVALID_REQUEST_PARAM);
				return false;
			}
			$sql = 'update product_indiana set code_cnt = code_cnt + '.$quantity.' where uid = '.$pi['uid'].
					' && code_cnt = '.$pi['code_cnt'];
		} while(!Dba::write($sql));

		if($pi['price_cnt'] == $pi['code_cnt'] + $quantity) {
			Event::addHandler('AfterIndianaOrderPay', 'IndianaMod::onIndianaProductFull');
		}

		return IndianaMod::CODE_BASE + $pi['code_cnt'];
	}

	/*
		夺宝人次已满，准备开奖
		$order = array(
			'i_uid' => 
		)
	*/
	public static function onIndianaProductFull($order) {
		$update = array('full_time' => $_SERVER['REQUEST_TIME']);
		Dba::update('product_indiana', $update, 'uid = '.$order['i_uid']);

		//开奖，可以异步
		//IndianaMod::do_indiana($order['i_uid']);
		Queue::do_job_at($_SERVER['REQUEST_TIME'] + 15 * 60, 'shop_indiana_OpenJob', array($order['i_uid']));
		return true;
	}

	/*
		夺宝开奖

		@param $i 夺宝期号uid 或者 product_indiana
	*/
	public static function do_indiana($i) {
		if (is_numeric($i)) {
			$i = Dba::readRowAssoc('select uid, price_cnt, full_time, win_info from product_indiana where uid = '.$i);
		}

		//已经开过奖或者未满开奖人数
		if($i['win_info'] || !$i['full_time']) {
			return false;
		}

		$i_uid = $i['uid'];
		$price_cnt = $i['price_cnt'];

		$sql = 'select sum(ms) from (select create_time_ms as ms from product_indiana_record where i_uid = '.$i_uid
				.' order by create_time desc limit 50) as t';
		$calc_a = Dba::readOne($sql);

		//todo 取最新一期福彩中心老时时彩开奖结果
		if (($ret = @file_get_contents('http://f.apiplus.cn/cqssc.json')) && 
			($ret = @json_decode($ret, true)) &&
			!empty($ret['data'][0]['opencode'])) {
			$calc_b_info = $ret['data'][0];
			$calc_b = (int)str_replace(',', '', $calc_b_info['opencode']);
		}
		else {
			$calc_b_info = array();
			$calc_b = 0;
		}

		$win_code = ($calc_a + $calc_b) % $price_cnt + IndianaMod::CODE_BASE;

		$record = Dba::readRowAssoc('select uid, su_uid, user_ip from product_indiana_record where i_uid = '.$i_uid
									.' && code = '.$win_code);
		
		//中奖记录可以用个新表
		$win_info = array('win_user_id' => $record['su_uid'], 'win_user_ip' => $record['user_ip'], 'win_record_id' => $record['uid'],
							'win_code' => $win_code, 'win_time' => $_SERVER['REQUEST_TIME'], 'calc_a' => $calc_a, 'calc_b' => $calc_b,
							'calc_b_info' => $calc_b_info);
		$update = array('win_info' => $win_info);
		Dba::update('product_indiana', $update, 'uid = '.$i_uid);
		
		//标记record为已中奖, 没有标记order
		$sql = 'update product_indiana_record set sp_remark = 1 where i_uid = '.$i_uid.' && code = '.$win_code;
		Dba::write($sql);
		//todo 给win_user_id 发个恭喜短信之类的

		return $win_code;
	}

	/*
		
	*/
	public static function get_order_list($option) {
		$sql = 'select * from product_indiana_order';
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		if(!empty($option['user_id'])) {
			$where_arr[] = 'user_id = '.$option['user_id'];
		}
		if(!empty($option['i_uid'])) {
			$where_arr[] = 'i_uid = '.$option['i_uid'];
		}

		if(!empty($option['has_pay'])) {
			$where_arr[] = 'paid_time > 0';
		}

		//中奖幸运码
		if(!empty($option['win_code'])) {
			$where_arr[] = '(start_code <= '.$option['win_code'].' && start_code + quantity >= '.$option['win_code'].')';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		
		$sort = ' order by uid desc';
		$sql .= $sort;
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'IndianaMod::func_get_indiana_order');
	}

	/*
		
	*/
	public static function get_record_list($option) {
		$sql = 'select * from product_indiana_record';
		#if(!empty($option['shop_uid'])) {
		#	$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		#}
		if(!empty($option['i_uid'])) {
			$where_arr[] = 'i_uid = '.$option['i_uid'];
		}
		if(!empty($option['su_uid'])) {
			$where_arr[] = 'su_uid = '.$option['su_uid'];
		}
		if(!empty($option['code'])) {
			$where_arr[] = 'code = '.$option['code'];
		}

		if(!empty($option['has_win'])) {
			$where_arr[] = 'sp_remark > 0';
		}


		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		
		$sort = ' order by uid desc';
		$sql .= $sort;
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'IndianaMod::func_get_indiana_record');
	}

}

