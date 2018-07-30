<?php

/*
	一级代理
*/
class AgentMod {
	public static function require_agent()
	{
		if($cache = requestInt('s_a_uid')) {
			if(($agent = AgentMod::get_agent_by_uid($cache)) && !empty($agent) && empty($agent['status']))
			{
				setcookie('__s_a_uid', $cache, 0, '/');
				return $cache;
			}
			else
			{
				return 0;
			}
		}
		if(isset($_COOKIE['__s_a_uid']) && ($cache = checkInt($_COOKIE['__s_a_uid']))) {
			return $cache;
		}
//		if($exit) {
//			echo ('fatal error! require s_a_uid failed!'); exit(1);
//		}
		return 0;
	}



	/*
	 * 增加一个可被代理的商品
	 */
	public static function add_or_edit_agent_product($agent_product)
	{
		$agent_product['modify_time'] = $_SERVER['REQUEST_TIME'];
		if (Dba::readOne('select * from shop_agent_product where uid = ' . $agent_product['uid']))
		{
			$ret = Dba::update('shop_agent_product', $agent_product, 'uid =' . $agent_product['uid']);
		}
		else
		{
			$ret = Dba::insert('shop_agent_product', $agent_product);
		}

		return $ret;
	}

	/*
	 * 获取一个可被代理设置的商品
	 */
	public static function get_agent_product_by_uid($uid)
	{
		return Dba::readRowAssoc('select * from shop_agent_product where uid=' . $uid, 'AgentMod::func_get_agent_product');
	}


	public static function func_get_agent_product($item)
	{
//		if (!empty($item['uid']) && !($product = ProductMod::get_shop_product_by_uid($item['uid'])))
//		{
//			$item['product'] = $product;
//		}
		if (!empty($item['uid']) && ($price = Dba::readOne('select price from product where uid ='.$item['uid'])))
		{
			$item['price'] = $price;
		}

		if (!empty($item['rule_data']))
		{
			$item['rule_data'] = json_decode($item['rule_data'], true);
		}
		if(!empty($item['cat_uid'])) $item['cat'] = ProductMod::get_product_cat_by_uid($item['cat_uid']);
		return $item;
	}

	/*
	 * 获取一个可被代理设置的商品列表
	 */
	public static function get_agent_product_list($option)
	{
		$sql = 'select a.uid as a_uid,a.price_h,a.price_l,a.status as a_status,a.modify_time as a_modify_time,b.* from shop_agent_product as a ';
		$sql .= 'right join product as b on a.uid=b.uid ';
		$where_arr[] = ' b.sku_table =""' ;//暂时不支持带sku 的
		if (!empty($option['shop_uid']))
		{
			$where_arr[] = ' b.shop_uid =' . $option['shop_uid'];
		}
		if (!empty($option['cat_uid']))
		{
			$where_arr[] = ' b.cat_uid =' . $option['cat_uid'];
		}
		if (isset($option['status']))
		{
			$where_arr[] = ' a.status =' . $option['status'];
		}
		if (!empty($option['no_a_uid']))
		{
			$p_uids = Dba::readAllOne('select p_uid from shop_agent_to_user_product where a_uid = ' . $option['no_a_uid']);
			if (!empty($p_uids))
			{
				$where_arr[] = ' a.uid not in (' . implode(',', $p_uids) . ')';
			}
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}

		$sql .= ' order by a.modify_time desc';
//				var_dump(__file__.' line:'.__line__,$sql);exit;
		$option['page']  = isset($option['page']) ? $option['page'] : 0;
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'],'AgentMod::func_get_agent_product');
	}



	public static function  delete_agent_product($uids, $shop_uid)
	{
		if (!is_array($uids))
		{
			$uids = array($uids);
		}
		$sql = 'delete from shop_agent_product where uid in (' . implode(',', $uids) . ') and shop_uid = ' . $shop_uid;

		return Dba::write($sql);
	}

	public static function add_or_edit_agent_to_user_product($user_product)
	{
		$user_product['modify_time'] = $_SERVER['REQUEST_TIME'];
		if (!empty($user_product['uid']))
		{
			$ret = Dba::update('shop_agent_to_user_product', $user_product, 'uid =' . $user_product['uid']);
		}
		else
		{

			$ret = Dba::insert('shop_agent_to_user_product', $user_product);
		}

		return $ret;
	}

	public static function get_agent_to_user_prodct_by_a_uid_and_p_uid($p_uid, $a_uid)
	{
		return Dba::readRowAssoc('select * from shop_agent_to_user_product where p_uid=' . $p_uid.' and a_uid='.$a_uid, 'AgentMod::func_get_agent_to_user_product');

	}
	public static function get_agent_to_user_product_by_uid($uid)
	{
		return Dba::readRowAssoc('select * from shop_agent_to_user_product where uid=' . $uid, 'AgentMod::func_get_agent_to_user_product');
	}

	public static function func_get_agent_to_user_product($item)
	{
		$item['title'] = htmlspecialchars($item['title']);
		if (!empty($item['content']))
		{
			$item['content'] = XssHtml::clean_xss($item['content']);
		}
		if ($product = ProductMod::get_shop_product_by_uid($item['p_uid'],0))
		{
			$item['product'] = $product;
		}
		if (!empty($item['images']))
		{
			$item['images'] = explode(';', $item['images']);
		}
        $item['bonus'] = AgentMod::get_agent_bonus_by_product($item['p_uid'],$item['a_uid']);
		$item['agent_product'] = self::get_agent_product_by_uid($item['p_uid']);
		return $item;
	}


	public static function get_agent_to_user_product_list($option)
	{
		$sql = 'select * from shop_agent_to_user_product';
		if (!empty($option['p_uid']))
		{
			$where_arr[] = ' p_uid =' . $option['p_uid'];
		}
		if (!empty($option['a_uid']))
		{
			if(!is_array($option['a_uid']))
			{
				$option['a_uid'] = array($option['a_uid']);
			}
			$where_arr[] = 'a_uid in (' . implode(',',$option['a_uid']).')';
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by modify_time desc';
		$option['page']  = isset($option['page']) ? $option['page'] : 0;
		$option['limit'] = isset($option['limit']) ? $option['limit'] : 10;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'AgentMod::func_get_agent_to_user_product');
	}


	public static function delete_agent_to_user_product_($uids, $a_uid)
	{
		if (!is_array($uids))
		{
			$uids = array($uids);
		}
		$sql = 'delete from shop_agent_to_user_product where uid in (' . implode(',', $uids) . ') and a_uid = ' . $a_uid;

		return Dba::write($sql);
	}

	public static function func_get_agent_user($item)
	{
		if(!(empty($item['su_uid'])))
		{
			$item['user'] = AccountMod::get_service_user_by_uid($item['su_uid']);

		}
		if(!(empty($item['uid'])))
		{
			$item['agent'] = self::get_agent_by_uid($item['uid']);
		}
		return $item;
	}

	//纯标记订单和代理的所属关系
	public static function add_agent_order($agent_order)
	{
		$ret = Dba::insert('shop_agent_order', $agent_order);
		return $ret;
	}

	public static function get_agent_order_by_order_uid($order_uid)
	{
		return Dba::readRowAssoc('select * from shop_agent_order where order_uid=' . $order_uid);

	}


	public static function delete_agent_order($uids, $a_uid)
	{
		if (!is_array($uids))
		{
			$uids = array($uids);
		}
		$sql = 'delete from shop_agent_order where order_uid in (' . implode(',', $uids) . ') and uid = ' . $a_uid;

		return Dba::write($sql);
	}

	/*
	 * 标记 用户来着哪个代理商
	 */
	public static function add_agent_user($agent_user)
	{
		$agent_user['create_time'] = $_SERVER['REQUEST_TIME'];
		$ret = Dba::insert('shop_agent_user', $agent_user);
		return $ret;
	}

	public static function get_agent_user_by_su_uid($su_uid)
	{
		return Dba::readRowAssoc('select * from shop_agent_user where su_uid=' . $su_uid);

	}

	public static function get_agent_user_list($option)
	{
		$sql = 'select * from shop_agent_user';
		if (!empty($option['a_uid']))
		{
			if(!is_array($option['a_uid']))
			{
				$option['a_uid'] = array($option['a_uid']);
			}
			$where_arr[] = 'uid in (' . implode(',',$option['a_uid']).')';
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by create_time desc';
		$option['page']  = isset($option['page']) ? $option['page'] : 0;
		$option['limit'] = isset($option['limit']) ? $option['limit'] : 10;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'],'AgentMod::func_get_agent_user');
	}

	//删除
	public static function delete_agent_user($uids, $a_uid)
	{
		if (!is_array($uids))
		{
			$uids = array($uids);
		}
		$sql = 'delete from shop_agent_user where uid in (' . implode(',', $uids) . ') and uid = ' . $a_uid;

		return Dba::write($sql);
	}

	/*
	 * 修改 增加 代理商
	 */
	public static function add_or_edit_agent($agent)
	{
		if (!empty($agent['uid']))
		{
			Dba::update('shop_agent', $agent, 'uid = ' . $agent['uid']);
		}
		else
		{
			$agent['create_time'] = $_SERVER['REQUEST_TIME'];
			$agent['uid'] = Dba::insert('shop_agent', $agent);
		}

		return $agent['uid'];
	}

	/*
	 * 获取代理商信息
	 */
	public static function get_agent_by_uid($uid)
	{

		return Dba::readRowAssoc('select * from shop_agent where uid = ' . $uid, 'AgentMod::func_get_agent');
	}

	public static function get_agent_by_su_uid($su_uid)
	{
		return Dba::readRowAssoc('select * from shop_agent where su_uid = ' . $su_uid, 'AgentMod::func_get_agent');

	}
	public static function  func_get_agent($item)
	{
		if(!empty($item['su_uid']))
		{
			$item['user'] = AccountMod::get_service_user_by_uid($item['su_uid']);
		}
		$item['notice'] = htmlspecialchars($item['notice']);
		return $item;
	}

	//获取代理商列表
	public static function get_agent_list($option)
	{
		$sql = 'select * from shop_agent ';
		if (!empty($option['shop_uid']))
		{
			$where_arr[] = ' shop_uid =' . $option['shop_uid'];
		}
		if (!empty($option['uid']))
		{
			$where_arr[] = ' uid =' . $option['uid'];
		}
		if (!empty($option['su_uid']))
		{
			$where_arr[] = ' su_uid =' . $option['su_uid'];
		}
		//根据用户名称搜索
		if (isset($option['key']))
		{
			if(!($su_uids = Dba::readAllOne('select uid from service_user where name like "%'.$option['key'].'%"')))
			{
				$where_arr[] = ' su_uid in "' . implode(' and ', $where_arr).'"';
			}
		}
		if (isset($option['status']))
		{
			$where_arr[] = ' status =' . $option['status'];
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by create_time desc';
		$option['page']  = isset($option['page']) ? $option['page'] : 0;
		$option['limit'] = isset($option['limit']) ? $option['limit'] : 10;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'],'AgentMod::func_get_agent');

	}

	//获取商户的代理设置信息
	public static function get_agent_set_by_shop_uid($shop_uid)
	{

		return Dba::readRowAssoc('select * from shop_agent_set where shop_uid ='.$shop_uid,'AgentMod::func_get_agent_set');
	}

	public static function func_get_agent_set($item)
	{
		if(!empty($item['rule_data']))
		{
			$item['rule_data'] = json_decode($item['rule_data'],true);
		}
		else
		{
			$agent_set =  AgentMod::get_agent_set_by_shop_uid($item['shop_uid']);
			$agent_set['rule_data'] = $agent_set['rule_data'];
		}
		return $item;
	}

	//编辑商户的代理设置
	public static function add_or_edit_agent_set($agent_set)
	{
		if(Dba::readOne('select * from shop_agent_set where shop_uid='.$agent_set['shop_uid']))
		{
			$ret = Dba::update('shop_agent_set',$agent_set,'shop_uid = '.$agent_set['shop_uid']);
		}
		else
		{
			$ret = Dba::insert('shop_agent_set',$agent_set);
		}
		return $ret;
	}

	/**
	 * 获取代理的每件商品的佣金
	 * @param $p_uid
	 *  商品uid
	 * @param $a_uid
	 *  代理商uid
	 * @return array
	 *
	 */
	public static function get_agent_bonus_by_product($p_uid,$a_uid)
	{
		$agent_product = self::get_agent_product_by_uid($p_uid);
		if(!empty($agent_product['rule_data']))
		{
			$rule_data =    $agent_product['rule_data'] ;
		}
		else
		{
			$agent_set = self::get_agent_set_by_shop_uid($agent_product['shop_uid']);
			$rule_data = $agent_set['rule_data'];
		}
		$agent_to_user_product =  Dba::readRowAssoc('select price from shop_agent_to_user_product where p_uid=' . $p_uid.' and a_uid='.$a_uid);
        $product    = Dba::readRowAssoc('select price from product where uid ='.$p_uid);

		//根据分红规则取回 红利
		$bonus = self::get_bonus($rule_data,$agent_to_user_product['price'],$product['price']);

		return $bonus['sum'];
	}


	public static function get_bonus($rule_data,$agent_price,$price)
	{
		$bonus = array();
		//出去成本价 为红利
		if(!empty($rule_data['cost']['status']))
		{
			$bonus['cost'] =$agent_price - $price;
		}
		//销售价格的一定比例
		if(!empty($rule_data['paid_fee']['status']))
		{
			$bonus['paid_fee'] = round($agent_price *$rule_data['paid_fee']['weight']/10000) ;
		}
		//固定佣金
		if(!empty($rule_data['bonus']['status']))
		{
			$bonus['bonus'] = $rule_data['bonus']['value'];
		}
		$bonus['sum']  = array_sum($bonus);
		return $bonus;
	}

	//订单完成 代理处理结算
	public static function do_agent($order)
	{
		//判断订单的所属代理 没有则退出
		if(!($agent_order = self::get_agent_order_by_order_uid($order['uid'])))
		{
			return ;
		}
		$a_uid = $agent_order['a_uid'];
		if(!empty($order['products']))
		{
			foreach($order['products'] as $product)
			{
				$cash = self::get_agent_bonus_by_product($product['sku_uid'],$a_uid);
			}
		}
		//取代理uid 增加佣金
		$agent = self::get_agent_by_uid($a_uid);
		$record = array(
			'su_uid' => $agent['su_uid'],
			'cash'   => $cash,
			'info'   => '代理分佣金',
		);
		uct_use_app('su');
		SuPointMod::increase_user_cash($record);
		$update['cash_sum'] =$agent['cash_sum']+$cash;
		$update['uid'] = $agent['uid'];
		self::add_or_edit_agent($update);

		//记录该订单的分的佣金、
		Dba::update('shop_agent_order',array('bonus'=>$cash),'order_uid = '.$agent_order['order_uid']);
	}

	/*
	 * 新分销用户注册成功 后更新后台统计数据
	 */
	public static function onAfterSuRegister($su)
	{
		//判断 邀请者uid 是否为空
		if (!empty($GLOBALS['_TMP']['SHOP_AGENT_UID']))
		{
			$agent_user['uid'] = $GLOBALS['_TMP']['SHOP_AGENT_UID'];
			$agent_user['su_uid'] = $su['uid'];
			self::add_agent_user($agent_user);
			Dba::write('update shop_agent set user_count= user_count+1 where uid ='.$agent_user['uid']);
		}

	}

	//接口判断用 判断rule_data 数据是否有问题
	public static function check_rule_data($rule_data)
	{
//		if(!empty($rule_data['cost']['status']))
//		{
//
//		}
		//销售价格的一定比例
		if(!empty($rule_data['paid_fee'])
			&& !empty($rule_data['paid_fee']['status'])
			&& (empty($rule_data['paid_fee']['weight']) || $rule_data['paid_fee']['weight']>10000)
			)
		{

			outError(ERROR_INVALID_REQUEST_PARAM);//为空 或者 超过100
		}
		//固定佣金
		if(!empty($rule_data['bonus'])
			&& !empty($rule_data['bonus']['status'])
			&& (empty($rule_data['bonus']['value'])))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);//为空
		}
	}

	//带代理分销的模板
	public static function get_agent_tpl_array()
	{
		return array('a_wap');
	}

}

