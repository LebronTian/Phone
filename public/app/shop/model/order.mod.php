<?php
/*
	购物车管理 
	订单管理
*/

class OrderMod
{
    const PAY_TYPE_NULL = 0; //未设置付款方式
    const PAY_TYPE_FREE = 1; //免费无需付款
    const PAY_TYPE_CACHE = 2; //货到付款
	const PAY_TYPE_BALANCEPAY = 8; //余额支付
	const PAY_TYPE_TESTPAY = 9; //测试支付
    const PAY_TYPE_ALIPAY = 10; //支付宝
    const PAY_TYPE_WEIXINPAY = 11; //微信支付


    const ORDER_WAIT_USER_PAY = 1; //待付款
    const ORDER_WAIT_FOR_DELIVERY = 2; //待发货
    const ORDER_WAIT_USER_RECEIPT = 3; //待收货
    const ORDER_DELIVERY_OK = 4; //已收货
    const ORDER_COMMENT_OK = 5; //已评价
    const ORDER_NEGOTATION_OK = 6; //协商完成
    const ORDER_UNDER_NEGOTATION = 8; //协商中(退货,换货)
    const ORDER_SHOP_CANCELED = 9; //店家已取消
    const ORDER_CANCELED = 10; //已取消
    const ORDER_WAIT_SHOP_ACCEPT = 11; //等待卖家确认
    const ORDER_WAIT_GROUP_DONE = 12; //待成团


    public static function func_get_shop_cart($item)
    {
        $item['product'] = ProductMod::get_shop_product_by_sku_uid($item['sku_uid']);

        return $item;
    }
    public static function func_get_record($item){
        $item = json_decode($item, true);
        return $item;
    }

    public static function func_get_order($item)
    {
        //顾客信息
        if (!empty($item['user_id'])) {
            $item['user'] = AccountMod::get_service_user_by_uid($item['user_id']);
        }
        //快递员订单信息
        if (!empty($item['uid'])) {
            $sql = 'select * from shop_order_delivery where order_uid = '.$item['uid'];
            if($item['del_order'] = Dba::readRowAssoc($sql)) {
            	$item['su_uid'] = $item['del_order']['su_uid'];
        		//快递员信息
		        if (!empty($item['su_uid'])) {
					$item['del_user'] = AccountMod::get_service_user_by_uid($item['su_uid']);
        		}
			}
        }
        if (!empty($item['pay_info'])) {
            $item['pay_info'] = json_decode($item['pay_info'], true);
        }
        if (!empty($item['address'])) {
            $item['address'] = json_decode($item['address'], true);
        }
        if (!empty($item['delivery_info'])) {
            $item['delivery_info'] = json_decode($item['delivery_info'], true);
        }
        if (!empty($item['info'])) {
            $item['info'] = json_decode($item['info'], true);
        }
        if (!empty($item['products'])) {
            $item['products'] = json_decode($item['products'], true);
        }
        if(!empty($item['a_uid']))
        {
            $item['agent'] =  AgentMod::get_agent_by_uid($item['a_uid']);
        }
        //退款信息
        if (in_array($item['status'], array(OrderMod::ORDER_UNDER_NEGOTATION, OrderMod::ORDER_NEGOTATION_OK))) {
            $item['refund'] = RefundMod::get_refund_by_order_uid($item['uid']);
        }

		//获取团购信息, 仅团长有
        if(!empty($item['go_uid'])){
            if($item['go_uid'] == $item['uid']) {
                $item['groups'] = Dba::readAllAssoc('select uid, user_id, go_uid, paid_time from shop_order where go_uid = '.$item['go_uid'].
                    ' && paid_time > 0 order by paid_time desc', function($it){
                    $it['user'] = AccountMod::get_service_user_by_uid($it['user_id']);
                    return $it;
                });
            }
        }

        return $item;
    }

    /*
     * 获取购物车
     */
    public static function get_shop_cart_by_uids($cart_uids, $shop_uid)
    {
        if (is_numeric($cart_uids)) {
            $cart_uids = array($cart_uids);
        }
        $sql = 'select * from shop_cart where uid in (' . implode(',', $cart_uids) . ') and shop_uid = ' . $shop_uid;
        return Dba::readAllAssoc($sql,'OrderMod::func_get_shop_cart');
    }

    /*
        添加到购物车

        $item = array('shop_uid' =>  店铺uid
                      'user_id' => 用户uid
                      'sku_uid' => 商品sku uid
                      'quantity' => 购买数目
        )

        返回uid
    */
    public static function add_to_shop_cart($item)
    {
        $sql = 'select uid from shop_cart where shop_uid = ' . $item['shop_uid'] . ' && user_id = ' . $item['user_id']
            . ' && sku_uid = "' . $item['sku_uid'] . '"';
        $item['create_time'] = $_SERVER['REQUEST_TIME'];
        if ($uid = Dba::readOne($sql)) {
            Dba::update('shop_cart', $item, 'uid = ' . $uid);

            return $uid;
        } else {

            Dba::insert('shop_cart', $item);

            return Dba::insertID();
        }
    }

    /*
        删除购物车
        返回删除的条数
    */
    public static function delete_shop_cart($iids, $shop_uid, $user_id)
    {
        if (!is_array($iids)) {
            $iids = array($iids);
        }
        $sql = 'delete from shop_cart where uid in (' . implode(',', $iids) . ') and shop_uid = ' . $shop_uid . ' and user_id = ' . $user_id;
        $ret = Dba::write($sql);

        return $ret;
    }

    /*
        获取购物车列表
        不需要分页
    */
    public static function get_shop_cart($shop_uid, $user_id)
    {
        $sql = 'select * from shop_cart where shop_uid = ' . $shop_uid . ' && user_id = ' . $user_id;

        return Dba::readAllAssoc($sql, 'OrderMod::func_get_shop_cart');
    }

    /*
        把购物车内商品移到收藏
        成功返回收藏uid
    */
    public static function move_cart_to_fav($iid, $user_id)
    {
        if (!($sku_uid = Dba::readOne('select sku_uid from shop_cart where uid = ' . $iid . ' && user_id = ' . $user_id))) {
            setLastError(ERROR_OBJ_NOT_EXIST);

            return false;
        }

        //Dba::beginTransaction(); {
        Dba::write('delete from shop_cart where uid = ' . $iid);
        $fav = array('user_id' => $user_id, 'product_uid' => current(explode(';', $sku_uid)));
        $ret = FavMod::add_or_edit_fav($fav);

        //} Dba::commit();

        return $ret;
    }


    /*
        下订单
        $order = array(
            'shop_uid' =>
            'user_id' =>
            'products' => array(
                            array('sku_uid' => '123;颜色:红色;尺寸:L', 'quantity' => 1),
                            array('sku_uid' =>	'123;颜色:红色;尺寸:X', 'quantity' => 2),
                            array('sku_uid' =>	'124;内存:32G;颜色:土豪金', 'quantity' => 2),
                            ...
                        ),
            //收货地址
            'address' => array(
                            'province' => '广东省',
                            'city' => '深圳市',
                            'town' => '南山区',
                            'address' => '工业六路',

                            'name' => '猴子',
                            'phone' => '15822222222',

                            //运送方式, 可以为空,或 express ems mail
                            'delivery' => '',
                        ),
            //支付方式
            'pay_type' => 11,
            'info' => array(
                            'remark' => '',
                            'fapiao' => '',
                            ...
                        ),
            'coupon_uid' => 用户优惠劵id , 可选
        )

        返回一个订单uid
    */
    public static function make_a_order($order,$bu_uid = '') {
        if (!isset($order['pay_type']) || $order['pay_type'] == OrderMod::PAY_TYPE_FREE) {
            //禁止设为 免费
            $order['pay_type'] = OrderMod::PAY_TYPE_NULL;
        }

        //记录下单时的商品价格
        //减库存, [在取消订单的时候加库存]
        //计算运费
        //计算各种优惠, 满100减5元, 满100包邮 等

        $opaid_fee = 0; //最终应付总价
        $opoint_fee = 0; //应付积分数
        $oback_point = 0; //应返还积分数
        $op_cnt = 0; //商品总件数
        $ops = array(); //保存到order中
        $lps = array(); //检查购买限制, 更新库存
        $dps = array(); //计算运费

		
		//是否需要填地址
		$need_address = 0;
        foreach ($order['products'] as $p) {
            if (!($sp = ProductMod::get_shop_product_by_sku_uid($p['sku_uid'])) ||
                ($sp['shop_uid'] != $order['shop_uid'])
            ) {
                setLastError(ERROR_OBJ_NOT_EXIST);

                return false;
            }

            //砍价件数为1
            if(!empty($bu_uid)){
                $p['quantity'] = 1;
            }

            //检查库存是否足够
            if ($p['quantity'] > $sp['quantity']) {
                setLastError(ERROR_OUT_OF_LIMIT);

                return false;
            }

            /*
                同一个商品不同sku, 进行同样的限购处理
                todo 应该把历史购买过的数目也加上
            */
            if (isset($lps[$sp['uid']])) {
                $lps[$sp['uid']]['quantity'] += $p['quantity'];
            } else {
                $lps[$sp['uid']] = array('buy_limit' => $sp['buy_limit'],
                    'quantity' => $p['quantity'],
                    'sku_uid' => $p['sku_uid'],
                    'quantity_total' => $sp['quantity_total'],
					);
            }

            /*
                计算运费,相同运费模板的商品以件数算一次运费
            */
            if (isset($dps[$sp['delivery_uid']])) {
                $dps[$sp['delivery_uid']]['count'] += $p['quantity'];
            } else {
                $dps[$sp['delivery_uid']] = array('count' => $p['quantity']);
            }
            if(!isset($p['else_info'])){
                $p['else_info'] = null;
            }

			//团购使用团购价, 商品要先设置一个团购价
			if(isset($order['go_uid'])) {
				if(!($sp['price'] = $sp['group_price']) || !$sp['group_cnt']) {
					setLastError(ERROR_INVALID_REQUEST_PARAM);
					return false;
				}

				//参团
				if(!empty($order['go_uid'])) {
					if(!($go = OrderMod::get_order_by_uid($order['go_uid'])) || 
						$go['product_uid'] != $sp['uid']) {
						setLastError(ERROR_INVALID_REQUEST_PARAM);
						return false;
					}
					if($go['remain_cnt'] <= 0) {
						setLastError(ERROR_OUT_OF_LIMIT);
						return false;
					}
					//已经参过团了
					if(Dba::readOne('select uid from shop_order where shop_uid = '.$order['shop_uid'].
									' && user_id = '.$order['user_id'].' && go_uid = '.$order['go_uid'])) {
						setLastError(ERROR_OBJECT_ALREADY_EXIST);
						return false;
					}
					$order['product_uid'] = $sp['uid'];
					$order['remain_cnt'] = $go['remain_cnt'];
				} else {
					//开团
					$order['product_uid'] = $sp['uid'];
					$order['remain_cnt'] = $sp['group_cnt'];
				}
			}
            //砍价使用砍的价格
            if(!empty($bu_uid)){
                uct_use_app('bargain');
                $bargain_user = BargainMod::get_bargain_user_by_uid($bu_uid);
                if(!empty($bargain_user)&&$bargain_user['status']!=1){
//                    $opaid_fee = $bargain_user['current_price'];
                    $sp['price'] = $bargain_user['current_price'];
                }
            }

            $ops[] = array('sku_uid' => $p['sku_uid'],
                'biz_uid' => $sp['biz_uid'],
                'quantity' => $p['quantity'],
                'else_info' => $p['else_info'],
                'paid_price' => $sp['price'],
                'title' => $sp['title'],
                'main_img' => $sp['main_img'],
				'virtual_info' => $sp['virtual_info'],
				);
            $opaid_fee += $sp['price'] * $p['quantity'];
            $opoint_fee += $sp['point_price'] * $p['quantity'];
            $oback_point += $sp['back_point'] * $p['quantity'];
			$op_cnt += $p['quantity'];

			if(empty($sp['virtual_info'])) $need_address = 1;
        }

		if($need_address && !isset($order['address'])) {
			setLastErrorString('请填写收货地址！');
			return false;
		}

        //买的都是一个商家的，biz_uid一样，否则拆分订单
        $arr_biz  = array();
        $biz_uid = 0;
        $products = $ops;
        foreach ($products as $op){
            array_push($arr_biz, $op['biz_uid']);
            $biz_uid = $op['biz_uid'];
            $arr_biz = array_unique($arr_biz);
        }

		//todo 不支持跨店铺下单！ 由前端用户自己拆分下单
		$arr_biz = array_unique(array_column($products, 'biz_uid'));
        if(count($arr_biz) > 1){
			//setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			setLastErrorString('暂不支持跨店铺下单！请依次购买！');
			return false;
        }
		$order['biz_uid'] = $products[0]['biz_uid'];

//限购 todo
        foreach ($lps as $l) {
            if (($l['buy_limit'] > 0)) {
				if ($l['buy_limit'] < $l['quantity']) {
                	//setLastError(ERROR_OUT_OF_LIMIT);
					setLastErrorString('商品已超出限购数目！');
                	return false;
            	}
				$history_cnt = Dba::readOne('select sum(quantity) from product_sell where product_uid = '.
								current(explode(';',$l['sku_uid'])).' && user_id = '.$order['user_id']);
				if ($history_cnt && $l['buy_limit'] < ($l['quantity'] + $history_cnt)) {
                	setLastError(ERROR_OUT_OF_LIMIT);
                	return false;
            	}
			}
        }

        //根据$dps, $address计算运费
        $odelivery_fee = 0;
        if (!empty($order['address'])) {
            foreach ($dps as $k => $v) {
                $odelivery_fee += DeliveryMod::calc_delivery_fee($k, $order['address'], $v);
            }
        }

        //计算各种优惠信息
        $odiscount_fee = 0;
        //优惠券、满减 以会员折扣后价 计算
        $after_vip_fee = $opaid_fee;

		//如果是团购,  就不进行会员卡打折了
		if(0||empty($order['go_uid'])) {
		if(uct_class_exists('VipcardMod', 'vipcard')) {
        	//取会员卡折扣
        	$vip_discount = VipcardMod::get_rank_discount($order['user_id']);
	        $odiscount_fee += (1-$vip_discount) * $opaid_fee;
            $after_vip_fee = $after_vip_fee - $odiscount_fee;
		}
		}

        //取优惠券优惠信息,以会员折扣后价 计算
        if (!empty($order['coupon_uid'])) {
            $order_info = array('user_id' => $order['user_id'],
                'opaid_fee' => $after_vip_fee,
                'odelivery_fee' => $odiscount_fee,
                'products' => $order['products']);
            $odiscount_fee += CouponMod::calc_coupon_fee($order['coupon_uid'], $order_info);
            unset($order['coupon_uid']);
        }

        //如果>0认为是一个积分换购商品, 此时不收商品费而只收运费. 并且不再返还积分
		if(!isset($order['use_point'])) {
	        if ($opoint_fee > 0) {
				//暂不支持这种情况
				setLastError(ERROR_UNDEFINE);
				return false;
				$discount_fee = $opaid_fee;
				$oback_point = 0;
			}
	        $order['use_point'] = $opoint_fee;
		}

        $order['back_point'] = $oback_point;

        $point_fee = 0;
        if(!empty($order['use_point']) && isset($GLOBALS['arraydb_sys']['cfg_set_shop_discount'.$order['shop_uid']])){
            $point = json_decode($GLOBALS['arraydb_sys']['cfg_set_shop_discount'.$order['shop_uid']], true);
			if(!empty($point['discount'])) {
            	$point_fee = $order['use_point']*100/$point['discount'];
			}
        }
		$cash_fee = isset($order['cash_fee']) ? $order['cash_fee'] : 0;

		//店铺满减
		$free = isset($GLOBALS['arraydb_sys']['shop_discount_'.$order['shop_uid']]) ? 
					$GLOBALS['arraydb_sys']['shop_discount_'.$order['shop_uid']] : '';
		if($free = json_decode($free, true)) {
			//以最大满减为准,以会员折扣后价 计算
			usort($free, function($a, $b){
				return $a['man'] > $b['man'] ? -1 : ($a['man'] > $b['man'] ? 1 : 0);
			});
			foreach($free as $f) {
				if($after_vip_fee >= $f['man']) {
					$odiscount_fee += $f['jian'];
					break;
				}
			}
		}
		
		//满包邮
		if($odelivery_fee) {
			$rule = isset($GLOBALS['arraydb_sys']['delivery_discount_'.$order['shop_uid']]) ? 
				$GLOBALS['arraydb_sys']['delivery_discount_'.$order['shop_uid']]: '';
			$rule = $rule ? json_decode($rule, true) : array();
			if(!empty($rule['free_fee'])) {
				if($opaid_fee >= $rule['free_fee'])	{
					//$odiscount_fee += $odelivery_fee;
					$odelivery_fee = 0;
				}
			}	 
			if(!empty($rule['free_cnt'])) {
				if($op_cnt >= $rule['free_cnt']) {
					//$odiscount_fee += $odelivery_fee;
					$odelivery_fee = 0;
				}
			}
		}

        $opaid_fee = max(0, $opaid_fee + $odelivery_fee - $odiscount_fee - $point_fee - $cash_fee);
        //or ?
        //$opaid_fee = max(0, $opaid_fee - $odiscount_fee -$point_fee - $cash_fee) + $odelivery_fee;
        if ($opaid_fee == 0) {
            $order['pay_type'] = OrderMod::PAY_TYPE_FREE;
        }
        //免费或货到付款时把订单状态改为待发货
        if (($order['pay_type'] == OrderMod::PAY_TYPE_FREE) ||
            ($order['pay_type'] == OrderMod::PAY_TYPE_CACHE)
        ) {

            //某些订单(如外卖订单)需要等待买家确认
            $order['status'] = !empty($GLOBALS['_TMP']['on_free_status']) ? $GLOBALS['_TMP']['on_free_status']
                : OrderMod::ORDER_WAIT_FOR_DELIVERY;

			if($order['status'] == OrderMod::ORDER_WAIT_FOR_DELIVERY) {
                //免费订单报错607
				setLastError(ERROR_BAD_STATUS);
			}
        }

        $order['create_time'] = $_SERVER['REQUEST_TIME'];
        $order['paid_fee'] = $opaid_fee;
        $order['discount_fee'] = $odiscount_fee;
        $order['delivery_fee'] = $odelivery_fee;


		//仅用于预览运费
		if(!empty($GLOBALS['_TMP']['preview_order_fee'])) {
			unset($GLOBALS['_TMP']['preview_order_fee']);
			return array(
				'paid_fee' => $order['paid_fee'],
				'discount_fee' => $order['discount_fee'],
				'delivery_fee' => $order['delivery_fee'],
				'cash_fee' => isset($order['cash_fee']) ? $order['cash_fee'] : 0,
				'use_point' => isset($order['use_point']) ? $order['use_point'] : 0,
			);
		}

        $order['products'] = json_encode($ops);

        if (!empty($order['address'])) {
            $order['address'] = json_encode($order['address']);
        }
        $order['info'] = json_encode($order['info']);
        Dba::beginTransaction();
        {
            //根据$lps减库存
			if(0) { //todo 等付款后再改库存
            foreach ($lps as $l) {
                if (!ProductMod::decrease_product_quantity($l['sku_uid'], $l['quantity'])) {
                    Dba::rollBack();

                    return false;
                }
            }
			}

            Dba::insert('shop_order', $order);
            $order['uid'] = Dba::insertID();


            if ($order['use_point'] > 0) {
                uct_use_app('su');
                if (!SuPointMod::decrease_user_point(array('su_uid' => $order['user_id'],
                    'point' => $order['use_point'],
                    'info' => '积分换购 -订单号- ' . $order['uid']))
                ) {
                    Dba::rollBack();

                    return false;
                }
            }

            if (!empty($order['cash_fee'])) {
                uct_use_app('su');
                if (!SuPointMod::decrease_user_cash(array('su_uid' => $order['user_id'],
                    'cash' => $order['cash_fee'],
                    'info' => '余额抵扣 -订单号- ' . $order['uid']))
                ) {
                    Dba::rollBack();
                    return false;
                }
            }

			//开团,更新一下自己的go_uid
			if(isset($order['go_uid']) && ($order['go_uid'] == 0)) {
				Dba::write('update shop_order set go_uid = '.$order['uid'].' where uid = '.$order['uid']);
			}

            //下单以后事件
            Event::handle('AfterMakeOrder', array($order));

			//无需支付的，调用一下onpay
			if(!empty($order['status']) && ($order['status'] == OrderMod::ORDER_WAIT_FOR_DELIVERY)) {
				OrderMod::onAfterOrderPay(OrderMod::get_order_by_uid($order['uid']));	
			}
			else {
				//15分钟自动取消订单
        		Queue::do_job_at($_SERVER['REQUEST_TIME'] + 15*60, 'shop_auto_cancelJob', array($order));
			}
        }
        Dba::commit();

        return $order['uid'];
    }

    /*
    下单成功 todo 发短信,发微信模板消息
    */
    public static function onAfterMakeOrder($order)
    {

        //如果是代理
        if(($a_uid = AgentMod::require_agent()))
        {
            //标记订单所属代理
            $agent_order = array('order_uid'=>$order['uid'],'a_uid'=>$a_uid);
            AgentMod::add_agent_order($agent_order);
        }


        //删除购物车
        if ((!empty($GLOBALS['_TMP']['cart_uid']))) {
            $cart_uids = $GLOBALS['_TMP']['cart_uid'];
            is_numeric($cart_uids) && $cart_uids = array($cart_uids);
            self::delete_shop_cart($cart_uids, $order['shop_uid'], $order['user_id']);
        }
        //发站内消息
        $sp_uid = Dba::readOne('select sp_uid from shop where uid = ' . $order['shop_uid']);
		$order = OrderMod::get_order_by_uid($order['uid']);
        $msg = array(
            'title' => '微商城 下单提醒 - ['.$order['user']['name'].']',
            'content' => '收到新订单, ￥'.($order['paid_fee']/100).' <a href="?_a=shop&_u=sp.orderlist&key='.
						 $order['uid'] . '">['.implode('-', array_column($order['products'], 'title')).']</a>',
            'sp_uid' => $sp_uid,
        );
        uct_use_app('sp');
        SpMsgMod::add_sp_msg($msg);


        // 发送模板消息
        uct_use_app('templatemsg');
        $su_uid = $order['user_id'];
        $args = Template_Msg_WxPlugMod::get_shop_args_by_order($order);
        Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__ . '.' . __FUNCTION__, $sp_uid, $su_uid, $args);

        uct_use_app('templatexcxmsg');
        $xcxargs = Templatexcx_Msg_WxPlugMod::get_shop_args_by_order($order);
        Templatexcx_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__ . '.' . __FUNCTION__, $sp_uid, $su_uid, $xcxargs);


    }


    /*
        订单列表 不包含 address, delivery_info, info
    */
    public static function get_order_list($option)
    {
        $sql = 'select s.uid,s.shop_uid,s.product_uid,s.go_uid,s.remain_cnt,s.date_time,s.user_id,s.create_time,s.paid_time,s.send_time,s.recv_time,s.paid_fee,s.discount_fee,s.delivery_fee,
				s.use_point,s.back_point,s.status,s.pay_type,s.pay_info,s.products,s.address,s.info';
        if(!empty($option['a_uid']))
        {
            $sql .= ',a.a_uid,a.bonus ';
        }
        $sql .= ' from shop_order as s ';
        if(!empty($option['a_uid']))
        {
            $sql .= ' right join shop_agent_order as a on a.order_uid = s.uid ';
            if(!is_array($option['a_uid']))
            {
                $option['a_uid'] = array($option['a_uid']);
            }
            $where_arr[] = 'a_uid in (' . implode(',',$option['a_uid']).')';
        }
        if(!empty($option['biz_uid'])) {
            $where_arr[] = ' biz_uid = '.$option['biz_uid'];
        }
        if (!empty($option['shop_uid'])) {
            $where_arr[] = 'shop_uid = ' . $option['shop_uid'];
        }
        if (!empty($option['user_id'])) {
            $where_arr[] = 'user_id = ' . $option['user_id'];
        }
        if (!empty($option['status'])) {
            $where_arr[] = 'status = ' . $option['status'];
        }
        if (!empty($option['statuss'])) {
            $where_arr[] = 'status in(' . implode(',', $option['statuss']) . ')';
        }

        if(isset($option['start_time'])&&isset($option['end_time'])){
            $where_arr[] .= 'create_time >=' . $option['start_time'] .
                (' and create_time <=' . $option['end_time']);
        }

        if (!empty($option['create_time'])) { //最近一段时间的订单
            $where_arr[] = 'create_time >= ' . $option['create_time'];
        }
        if (!empty($option['uids'])) {
            $where_arr[] = 'uid in(' . implode(',', $option['uids']) . ')';
        }
		if(!empty($option['isnormal'])) {
			$where_arr[] = '(biz_uid=0&&go_uid=0)';
		}
		if(!empty($option['isjiaoyi'])) {
			$where_arr[] = 'paid_fee>0';
		}

		//商品的团购订单
		if(!empty($option['product_uid'])) {
			$where_arr[] = 's.product_uid = '.$option['product_uid'];
		}
		if(!empty($option['go_uid'])) {
			$where_arr[] = 's.go_uid = '.$option['go_uid'];
		}
		//是否为团购订单
		if(isset($option['is_group'])) {
			$where_arr[] = $option['is_group'] ? 's.go_uid > 0' : 's.go_uid = 0';
		}
		//正在开团中, 只取了团长的
		if(!empty($option['is_under_group'])) {
			$where_arr[] = 's.go_uid = s.uid && s.remain_cnt > 0';
		}

        if (!empty($option['key'])) { //搜索订单号  和 商品名称
            $where_arr[] = '(uid = "' . addslashes($option['key']) . '"  || products like "%' .
                addslashes(trim(str_replace(array('\\u'), array('\\\\u'), json_encode($option['key'])), '"')) . '%")';
        }

        if (!empty($option['key_uid'])) { //搜索订单号  
            $where_arr[] = 'uid = "' . addslashes($option['key_uid']) . '"';
        }
        if (!empty($option['key_productname'])) { //搜索订单号  
            $where_arr[] = 'products like "%' . addslashes(trim(str_replace('\\u', '\\\\u', json_encode($option['key_productname'])), '"')) . '%"';
        }
        if (!empty($option['key_suname'])) { //搜索订单号  
            $where_arr[] = 'address like "%' . addslashes(trim(str_replace('\\u', '\\\\u', json_encode($option['key_suname'])), '"')) . '%"';
        }
        if (!empty($option['key_suphone'])) { //搜索订单号  
            $where_arr[] = 'address like "%' . addslashes($option['key_suphone']) . '%"';
        }


        if (!empty($where_arr)) {
            $sql .= ' where ' . implode(' and ', $where_arr);
        }

        if (!empty($option['uids'])) {
            $sort = 'find_in_set(uid, "' . implode(',', $option['uids']) . '")';
        } else {
            empty($option['sort']) && $option['sort'] = SORT_CREATE_TIME;
            switch ($option['sort']) {
                default:
                    $sort = 'create_time desc';
            }
        }
        $sql .= ' order by ' . $sort;

        return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'OrderMod::func_get_order');
    }

    /*
        订单详情
    */
    public static function get_order_by_uid($uid)
    {
        $sql = 'select * from shop_order where uid = ' . $uid;
//        $sql = 'select so.*,sod.su_uid from shop_order as so left join shop_order_delivery as sod on so.uid = sod.order_uid where so.uid = '.$uid;

        return Dba::readRowAssoc($sql, 'OrderMod::func_get_order');
    }

    /*
        编辑订单
    */
    public static function edit_order($o)
    {
        return Dba::update('shop_order', $o, 'uid = ' . $o['uid']);
    }

    /*
    编辑订单
*/
    public static function edit_pay_order($o)
    {
        $max_uid = Dba::readOne('select max(uid) from shop_order');
        $uid = $o['uid'];
        $o['uid'] = $max_uid + 1;
        return Dba::update('shop_order', $o, 'uid = ' . $uid);
    }

	//开团，人数不够时也能开, 一般用于后台手动开团 
	public static function do_open_group($order) {
		if(empty($order['go_uid'])) {
			return false;
		}
		$os = Dba::readAllOne('select uid from shop_order where shop_uid = '.$order['shop_uid'].' && go_uid = '.$order['go_uid'].' && status = '.OrderMod::ORDER_WAIT_GROUP_DONE);
		if(!$os) {
			return 0;
		}
		Dba::beginTransaction(); {
		foreach ($os as $uid) {
			Dba::write('update shop_order set status = '.OrderMod::ORDER_WAIT_FOR_DELIVERY.' where uid = '.$uid);
			OrderMod::do_virtual_send(OrderMod::get_order_by_uid($uid));
		}
		}Dba::commit();
		
		return count($os);
	}

    /*
        支付成功 todo 发短信,发微信模板消息
    */
    public static function onAfterOrderPay($order)
    {
		//在这里减掉库存
		foreach($order['products'] as $l) {
			if (!ProductMod::decrease_product_quantity($l['sku_uid'], $l['quantity'])) {
				//库存不足。。。
			}
		}
        //增加购买记录  在支付成功后加
        CommentMod::onAfterRecvOrder($order);

        //分销 处理
        $dtb = DistributionMod::get_dtb_rule_by_shop_uid($order['shop_uid']);
        if(empty($dtb['model'])&&($dtb['fullprice']<=$order['paid_fee'])){
			DistributionMod::do_dtb($order);
        }

        //如果订单属于某个代理的
        if(($agent_order = AgentMod::get_agent_order_by_order_uid($order['uid'])))
        {
            $a_uid = $agent_order['a_uid'];
            //标记订单所属代理
            $agent_order = array('order_uid'=>$order['uid'],'a_uid'=>$a_uid);
            AgentMod::add_agent_order($agent_order);
            //订单数+1
            $sql = 'update shop_agent set order_count = order_count+1 where uid = '.$a_uid;
            Dba::write($sql);
            //订单总额++
            $sql = 'update shop_agent set order_fee_sum = order_fee_sum+'.$order['paid_fee'].' where uid ='.$a_uid;
            Dba::write($sql);
        }

        $sp_uid = Dba::readOne('select sp_uid from shop where uid = ' . $order['shop_uid']);
		
		//特定店铺处理
		$GLOBALS['_UCT']['IGNORE_NOT_EXIST_CLASS_ONCE'] = 1;
		$cls = 'Id'.$sp_uid.'ShopMod';
		if(class_exists($cls)) {
			$cls::on_pay($order);
		}

        //站内通知
        $msg = array(
            'title' => '微商城 付款提醒 - ['.$order['user']['name'].']',
            'content' => '收到新付款, ￥'.($order['paid_fee']/100).' <a href="?_a=shop&_u=sp.orderlist&key=' . $order['uid'] . '">['.implode('-', array_column($order['products'], 'title')).']</a> ',
            'sp_uid' => $sp_uid,
        );
        uct_use_app('sp');
        SpMsgMod::add_sp_msg($msg);

        // 发送模板消息
        uct_use_app('templatemsg');
        $su_uid = $order['user_id'];
        $args = Template_Msg_WxPlugMod::get_shop_args_by_order($order);
        Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__ . '.' . __FUNCTION__, $sp_uid, $su_uid, $args);

        uct_use_app('templatexcxmsg');
        $xcxargs = Templatexcx_Msg_WxPlugMod::get_shop_args_by_order($order);
        Templatexcx_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__ . '.' . __FUNCTION__, $sp_uid, $su_uid, $xcxargs);

		//拼团订单
		if(!empty($order['go_uid'])) {
			Dba::write('update shop_order set remain_cnt = '.($order['remain_cnt'] - 1).' where go_uid = '.$order['go_uid']);	

			//状态改为待成团
			Dba::write('update shop_order set status = '.OrderMod::ORDER_WAIT_GROUP_DONE.' where uid = '.$order['uid']);
			if($order['remain_cnt'] <= 1) {
				//拼团成功
				Dba::write('update shop_order set status = '.OrderMod::ORDER_WAIT_FOR_DELIVERY.' where go_uid = '.$order['go_uid']);
				foreach(Dba::readAllOne('select uid from shop_order where go_uid = '.$order['go_uid']) as $uid) {
					OrderMod::do_virtual_send(OrderMod::get_order_by_uid($uid));
				}	
			}
		} else {
            OrderMod::do_virtual_send($order);
		}

		//自动打印小票订单
		OrderMod::print_order($order);

        //支付成功后拆分订单、根据biz_uid
		/*
        $products = $order['products'];
		$arr_biz = array_unique(array_column($order['products'], 'biz_uid'));
        if(count($arr_biz) < 2){
           return;
        }
        foreach($arr_biz as $k => $ab){
            unset($order['user']);
            unset($order['del_order']);
            $order['biz_uid'] = $ab;
            $order['paid_fee'] = 0;
            $order['products'] = array();
            foreach ($products as $op){
                if($ab == $op['biz_uid']){
                    $order['paid_fee'] += $op['paid_price'];
                    array_push($order['products'],$op);
                }
            }

            if($k == 0) {
                Dba::update('shop_order', $order, 'uid = '.$order['uid'].' and shop_uid = '.$order['shop_uid']);
            }
            else {
                unset($order['uid']);
                Dba::insert('shop_order', $order);
                $order['uid'] = Dba::insertID();
            }
        }
		*/
    }

	/*
		订单自动发货
	*/
	public static function do_virtual_send($o) {
		uct_use_app('sp');
		$cnt = 0;
        foreach ($o['products'] as $product) {
            if(!empty($product['virtual_info'])) {
				$quantity = $product['quantity'];
				while($quantity--) 
                $ret = VirProdMod::send_to_user($product['virtual_info']['name'], 
								$product['virtual_info']['coupon_uid'], 
								$o['user_id'],
								'商城购买 #'.$o['uid']);

                //发货和确认收货
                if($ret)
                {
					$cnt++;
                }
            }
        }

		//Weixin::weixin_log('going to auto delivery ... '.$cnt . ' == '.count($order['products']));
		if($cnt == count($o['products'])) {
			Dba::disableTransaction();
			self::do_send_goods($o, ''); 
			$o = self::get_order_by_uid($o['uid']);
			self::do_recv_goods($o);
			Dba::disableTransaction(false);
		}
	}

    /*
        订单付款
    */
    public static function do_pay_order($o, $pay_type, $pay_info)
    {
        if ($o['status'] != OrderMod::ORDER_WAIT_USER_PAY) {
            setLastError(ERROR_BAD_STATUS);

            return false;
        }

        $update = array(
            'uid' => $o['uid'],
            'status' => OrderMod::ORDER_WAIT_FOR_DELIVERY,
            'paid_time' => $_SERVER['REQUEST_TIME'],
            'pay_type' => $pay_type,
            'pay_info' => $pay_info,
        );
        self::edit_order($update);

        //付款以后事件,可以发送短信通知商户等
        $order = self::get_order_by_uid($o['uid']);
        Event::handle('AfterPayOrder', array($order));

        return true;
    }

    /*
        卖家发货 todo 发短信, 模板消息
    */
    public static function onAfterSendGoods($order)
    {
        $msg = array(
            'title' => '发货提醒',
            'content' => '订单号 ' . $order['uid'] . ' 卖家已于 ' . date('Y-m-d H:i:s', $order['send_time']) . ' 发货, 请等待查收.',
            'su_uid' => $order['user_id'],
        );
        uct_use_app('su');
        SuMsgMod::add_su_msg($msg);

        uct_use_app('sp');
        $sp_uid = Dba::readOne('select sp_uid from shop where uid = ' . $order['shop_uid']);
        #SpMsgMod::sp_send_sms($order['user_id'], $msg['content'], $sp_uid);

        uct_use_app('templatemsg');


        $su_uid = $order['user_id'];
        //		$su_uid = 1;
        $args = Template_Msg_WxPlugMod::get_shop_args_by_order($order);
        Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__ . '.' . __FUNCTION__, $sp_uid, $su_uid, $args);

        uct_use_app('templatexcxmsg');
        $xcxargs = Templatexcx_Msg_WxPlugMod::get_shop_args_by_order($order);
        Templatexcx_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__ . '.' . __FUNCTION__, $sp_uid, $su_uid, $xcxargs);
    }

    /*
        发货
    */
    public static function do_send_goods($o, $deliver_info)
    {

        if ($o['status'] != OrderMod::ORDER_WAIT_FOR_DELIVERY) {
            setLastError(ERROR_BAD_STATUS);

            return false;
        }

        $update = array(
            'uid' => $o['uid'],
            'status' => OrderMod::ORDER_WAIT_USER_RECEIPT,
            'send_time' => $_SERVER['REQUEST_TIME'],
            'delivery_info' => $deliver_info,
        );
        Dba::beginTransaction();
        {
            self::edit_order($update);

            //发货以后事件,可以发送短信通知用户
            $order = self::get_order_by_uid($o['uid']);

//			OrderMod::onAfterSendGoods($order);
            Event::handle('AfterSendGoods', array($order));
        }
        Dba::commit();

        //15天自动收货
        Queue::do_job_at($_SERVER['REQUEST_TIME'] + 15*86400, 'shop_auto_receiptJob', array($order));

        return true;
    }

    /*
        收货成功
    */
    public static function onAfterRecvGoods($order)
    {
        //分销 处理
        $dtb = DistributionMod::get_dtb_rule_by_shop_uid($order['shop_uid']);
        if((!empty($dtb['model']))&&($dtb['fullprice']<=$order['paid_fee'])){
			DistributionMod::do_dtb($order);
        }

        $sp_uid = Dba::readOne('select sp_uid from shop where uid = ' . $order['shop_uid']);

        $msg = array(
            'title' => '微商城 用户收货提醒',
            'content' => '恭喜! 微商城订单交易成功, 用户已成功收货!. <a href="?_a=shop&_u=sp.orderlist&key=' . $order['uid'] . '">点击查看</a>',
            'sp_uid' => $sp_uid,
        );
        uct_use_app('sp');
        SpMsgMod::add_sp_msg($msg);

        //七天默认好评
        Queue::do_job_at($_SERVER['REQUEST_TIME'] + 7*86400, 'shop_default_GoodreplyJob', array($order));

        uct_use_app('templatemsg');

        $su_uid = $order['user_id'];
        //		$su_uid = 1;
        $args = Template_Msg_WxPlugMod::get_shop_args_by_order($order);
        Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__ . '.' . __FUNCTION__, $sp_uid, $su_uid, $args);

    }

    /*
        收货
    */
    public static function do_recv_goods($o)
    {
        if ($o['status'] != OrderMod::ORDER_WAIT_USER_RECEIPT) {
            setLastError(ERROR_BAD_STATUS);

            return false;
        }

        $update = array(
            'uid' => $o['uid'],
            'status' => OrderMod::ORDER_DELIVERY_OK,
            'recv_time' => $_SERVER['REQUEST_TIME'],
        );
        Dba::beginTransaction();
        {
            self::edit_order($update);

            //确认收货事件, 订单完成.可以在此更新商品成交记录, 用户购买记录, 赠送积分等
            $order = self::get_order_by_uid($o['uid']);
            if ($order['back_point'] > 0) {
                uct_use_app('su');
                SuPointMod::increase_user_point(array('su_uid' => $order['user_id'],
                    'point' => $order['back_point'],
                    'info' => '购物积分返还 -订单号- ' . $order['uid']));
            }

            //根据订单$order['biz_uid']找到su_uid, 增加用余额
            $biz = ShopBizMod::get_shop_biz_by_uid($order['biz_uid']);
            if((!empty($biz))&&($biz['su_uid']!=0)){
                uct_use_app('su');
                //支付金额+余额支付金额
                $record = array(
                    'su_uid' => $biz['su_uid'],
                    'cash'   => $order['paid_fee']+$order['cash_fee'],
                    'info'   => '商户'.$biz['uid'].'- 订单'.$order['uid'].'-完成',
                );
				if($record['cash'] > 0)	
                SuPointMod::increase_user_cash($record);//增加用户收入
            }

            //代理 处理
            AgentMod::do_agent($order);
            //增加购买记录  在支付成功后加
            //CommentMod::onAfterRecvOrder($order);
            uct_use_app('vipcard');
            Event::handle('AfterRecvGoods', array($order));
            Event::handle('AfterIncrease_User_Point', array($order['user_id']));
        }
        Dba::commit();

        return true;
    }

    /*
        取消订单

        只有在待付款,待发货,协商中的订单能取消
    */
    public static function do_cancel_order($o)
    {
        if (!in_array($o['status'], array(OrderMod::ORDER_WAIT_USER_PAY,
            //OrderMod::ORDER_WAIT_FOR_DELIVERY, 待发货时可以申请退款，不要取消
            OrderMod::ORDER_UNDER_NEGOTATION,
            OrderMod::ORDER_WAIT_SHOP_ACCEPT))
        ) {
            setLastError(ERROR_BAD_STATUS);

            return false;
        }

        $update = array(
            'uid' => $o['uid'],
            'status' => OrderMod::ORDER_CANCELED,
        );
        Dba::beginTransaction();
        {
            self::edit_order($update);
            //取消订单, 把商品库存加回去 在退款的时候加库存
            #foreach ($o['products'] as $p) {
            #    ProductMod::increase_product_quantity($p['sku_uid'], $p['quantity']);
            #}

			//把积分也退回去
			if(!empty($o['use_point'])) {
				uct_use_app('su');
                SuPointMod::increase_user_point(array('su_uid' => $o['user_id'],
                    'point' => $o['use_point'],
                    'info' => '积分退回 -取消订单- #' . $o['uid']));
			}

            $order = self::get_order_by_uid($o['uid']);
            Event::handle('AfterCancelOrder', array($order));
        }
        Dba::commit();

        return true;
    }

    /*
    收货成功
*/
    public static function onAfterCancelOrder($order)
    {
        //如果订单属于某个代理的
        if(($agent_order = AgentMod::get_agent_order_by_order_uid($order['uid'])))
        {
            $a_uid = $agent_order['a_uid'];
            //删除订单表标记关系
            AgentMod::delete_agent_order($order['uid'],$a_uid);
            //订单数+1
            $sql = 'update shop_agent set order_count = order_count-1 where uid = '.$a_uid;
            Dba::write($sql);
            //订单总额++
            $sql = 'update shop_agent set order_fee_sum = order_fee_sum-'.$order['paid_fee'].' where uid ='.$a_uid;
            Dba::write($sql);
        }

        $sp_uid = Dba::readOne('select sp_uid from shop where uid = ' . $order['shop_uid']);
        $msg = array(
            'title' => '微商城 用户取消订单提醒',
            'content' => '提醒! 微商城有订单已被取消!. <a href="?_a=shop&_u=sp.orderlist&key=' . $order['uid'] . '">点击查看</a>',
            'sp_uid' => $sp_uid,
        );
        uct_use_app('sp');
        SpMsgMod::add_sp_msg($msg);

        uct_use_app('templatemsg');

        $su_uid = $order['user_id'];
        //		$su_uid = 1;
        $args = Template_Msg_WxPlugMod::get_shop_args_by_order($order);
        Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__ . '.' . __FUNCTION__, $sp_uid, $su_uid, $args);

    }


    /*
        订单协商中 (退货换货申请)
        需要客服协商处理
    */
    public static function do_order_negotation($o, $info = array())
    {
        $update = array(
            'uid' => $o['uid'],
            'status' => OrderMod::ORDER_UNDER_NEGOTATION,
        );
        if ($info) {
            $update['info'] = $info;
        }

        self::edit_order($update);

        return true;
    }

    /*
        订单协商完成
    */
    public static function do_order_negotation_over($o)
    {
        if ($o['status'] != OrderMod::ORDER_UNDER_NEGOTATION) {
            setLastError(ERROR_BAD_STATUS);

            return false;
        }

        $update = array(
            'uid' => $o['uid'],
            'status' => OrderMod::ORDER_NEGOTATION_OK,
        );
        self::edit_order($update);

        return true;
    }

    /*
        删除订单

        只有已取消的和未付款的订单可以删除
    */
    public static function delete_order($o)
    {
        //先取消一下
        if ($o['status'] == OrderMod::ORDER_WAIT_USER_PAY) {
            OrderMod::do_cancel_order($o);
        }

        if (!in_array($o['status'], array(OrderMod::ORDER_CANCELED, OrderMod::ORDER_WAIT_USER_PAY))) {
            setLastError(ERROR_BAD_STATUS);

            return false;
        }

        $sql = 'delete from shop_order where uid = ' . $o['uid'];
        Dba::beginTransaction();
        {
            Dba::write($sql);
            Event::handle('AfterDeleteOrder', array($o));
        }
        Dba::commit();

        return true;
    }

//    const ORDER_WAIT_USER_PAY = 1; //待付款
//    const ORDER_WAIT_FOR_DELIVERY = 2; //待发货
//    const ORDER_WAIT_USER_RECEIPT = 3; //待收货
//    const ORDER_DELIVERY_OK = 4; //已收货
//    const ORDER_COMMENT_OK = 5; //已评价
//    const ORDER_NEGOTATION_OK = 6; //协商完成
//    const ORDER_UNDER_NEGOTATION = 8; //协商中(退货,换货)
//    const ORDER_SHOP_CANCELED = 9; //店家已取消
//    const ORDER_CANCELED = 10; //已取消
//    const ORDER_WAIT_SHOP_ACCEPT = 11; //等待卖家确认
    public static function get_count_order_by_status($option)
    {
        $sql = 'select s.status,count(*) as count';
        $sql .= ' from shop_order as s ';
        if(!empty($option['a_uid']))
        {
            $sql .= ' right join shop_agent_order as a on a.order_uid = s.uid ';
            $where_arr[] = 'a.a_uid = ' . $option['a_uid'];
        }
        if (!empty($option['shop_uid'])) {
            $where_arr[] = 's.shop_uid = ' . $option['shop_uid'];
        }
        if (!empty($option['user_id'])) {
            $where_arr[] = 's.user_id = ' . $option['user_id'];
        }
        if (!empty($where_arr)) {
            $sql .= ' where ' . implode(' and ', $where_arr);
        }

        $sql .= ' group by s.status';

        return Dba::readAllAssoc($sql);
    }

    //获取配送员待配送，已配送信息
    public static function get_develop_order($su_uid,$status){
//        $sql = 'select order_uid from shop_order_delivery where su_uid ='.$uid;

        $sql = 'select * from shop_order_delivery as od';
        $sql .= ' left join shop_order as o on od.order_uid = o.uid ';
        if (!empty($su_uid)) {
            $where_arr[] = 'od.su_uid = ' . $su_uid;
        }
        if (isset($status)) {
            $where_arr[] = 'od.status = ' . $status;
        }
        if (!empty($where_arr)) {
            $sql .= ' where ' . implode(' and ', $where_arr);
        }

        $order = Dba::readAllAssoc($sql);
        return $order;
    }

    //配送员订单状态修改
    public static function set_order_by_uid($option){
        if(!empty($option)){
            Dba::update('shop_order_delivery', $option, 'order_uid = ' . $option['order_uid']);
        }
        return $option['order_uid'];
    }


    //订单货单统计
    public static function get_order_record($option){
        $sql = 'select products from shop_order';

        if (!empty($option['shop_uid'])) {
            $where_arr[] = 'shop_uid = ' . $option['shop_uid'];
        }
        if (isset($option['status'])) {
            $where_arr[] = 'status = ' . $option['status'];
        }
        if (!empty($where_arr)) {
            $sql .= ' where ' . implode(' and ', $where_arr);
        }

        if(isset($option['start_time'])&&$option['end_time']){
            $sql .= ' and create_time >=' . $option['start_time'] .
                (' and create_time <=' . $option['end_time']);
        }
//var_dump($sql);
        $order = Dba::readAllOne($sql,'OrderMod::func_get_record');
        return $order;
    }

    /*
    分拣单信息
    */
    public static function get_order_address($option)
    {
        #$sql = 'select uid,user_id,status,address,paid_fee,cash_fee,products,send_time,info from shop_order';
        $sql = 'select * from shop_order';

        if (!empty($option['shop_uid'])) {
            $where_arr[] = 'shop_uid = ' . $option['shop_uid'];
        }
        if(!empty($option['biz_uid'])) {
            $where_arr[] = ' biz_uid = '.$option['biz_uid'];
        }
        if (!empty($option['status'])) {
            $where_arr[] = 'status = ' . $option['status'];
        }
        if(isset($option['start_time'])&&$option['end_time']){
            $where_arr[] .= 'create_time >=' . $option['start_time'] .
                (' and create_time <=' . $option['end_time']);
        }
        if (!empty($where_arr)) {
            $sql .= ' where ' . implode(' and ', $where_arr);
        }
        $sql .= ' order by send_time asc';

        $order = Dba::readAllAssoc($sql,'OrderMod::func_get_order');
        return $order;
    }

	/*	
		付款后自动打印订单
	*/
	public static function print_order($order) {
        $sp_uid = Dba::readOne('select sp_uid from shop where uid = ' . $order['shop_uid']);
		$gs = Dba::readAllAssoc('select * from guguji where sp_uid = '.$sp_uid.
								' && status = 1 && count > 0', 'GugujiMod::func_get_guguji');
		#Weixin::weixin_log('find printer ...'.var_export($gs, true));
		if(!$gs) {
			return 0;
		}
		
        $content = '';
        foreach($order['products'] as $op){
            $content .= $op['title'].'x'.$op['quantity'];
            $content .= "\r\n";
        }
        $content .= "\r\n";
        $content .= "支付金额:￥".sprintf('%.2f',($order['paid_fee']+$order['cash_fee'])/100);
        $content .= "\r\n";
        $content .= "下单时间:".date('Y-m-d H:i:s',$order['create_time']);;
        $content .= "\r\n";
        if(!empty($order['address']['province'])) $content .= "地址:".$order['address']['province'].$order['address']['city'].$order['address']['town'].$order['address']['address'];
        $content .= "\r\n";
        if(!empty($order['address']['name'])) {
			 $content .= "用户:".$order['address']['name'];
		} else {
			if(!empty($order['user_id']) && 
				($su = AccountMod::get_service_user_by_uid($order['user_id'])))
			$content .= "用户:".(isset($su['name']) ? $su['name'] : $su['account']);
		}

        $content .= "\r\n";
        if(!empty($order['address']['phone'])) $content .= "电话:".$order['address']['phone'];
        $content .= "\r\n";
        if(!empty($order['info']['remark'])) $content .= "备注:".$order['info']['remark'];
        $content .= "\r\n"."------------------------------";
        //$content .= "\r\n          ".'快马加鞭科技'."          ";
		$cnt = 0;
		foreach($gs as $g) {
			while($g['count']--) {
				#Weixin::weixin_log('do print order ---> '.var_export($content, true));
				if(!GugujiMod::do_print($content, $g)) break;
				$cnt += 1;
			}	 
		}
		return $cnt;
	}
}

