<?php

/*
 * 分销
 */

class DistributionMod {
    /*
     * 设置分销规则
     */
    public static function add_or_edit_dtb_rule($dtb_rule)
    {
        if (!empty($dtb_rule['uid']))
        {
            Dba::update('shop_distribution', $dtb_rule, 'uid = ' . $dtb_rule['uid']);
        }
        else
        {
            $dtb_rule['create_time'] = $_SERVER['REQUEST_TIME'];
            $dtb_rule['uid']         = Dba::insert('shop_distribution', $dtb_rule);
        }

        return $dtb_rule['uid'];
    }
    /*
     * 设置商品分销规则
     */
    public static function add_or_edit_product_dtb_rule($dtb_rule)
    {
//        $dtb_rule['uid'] = Dba::readOne('select uid from shop_distribution_product where p_uid ='.$dtb_rule['p_uid'].' and shop_uid = '.$dtb_rule['shop_uid']);
        if (!empty($dtb_rule['uid']))
        {
            Dba::update('shop_distribution_product', $dtb_rule, 'uid = ' . $dtb_rule['uid']);
        }
        else
        {
            $dtb_rule['create_time'] = $_SERVER['REQUEST_TIME'];
            $dtb_rule['uid']         = Dba::insert('shop_distribution_product', $dtb_rule);
        }

        return $dtb_rule['uid'];
    }

    /*
     *
     */
    public static function get_dtb_rule_by_uid($uid)
    {
        return Dba::readRowAssoc('select * from shop_distribution where uid =' . $uid, 'DistributionMod::func_get_dtb_rule');
    }

    /*
     *
     */
    public static function get_product_dtb_rule_by_uid($uid)
    {
        return Dba::readRowAssoc('select * from shop_distribution_product where uid =' . $uid, 'DistributionMod::func_get_dtb_rule');
    }
    /*
     *
     */
    public static function get_dtb_rule_by_shop_product_uid($shop_uid,$sku_uid)
    {
        return Dba::readRowAssoc('select * from shop_distribution_product where shop_uid =' . $shop_uid.' and p_uid='.
				((int)$sku_uid), 'DistributionMod::func_get_dtb_rule');
    }

	/*
	 * 获取分销规则
	 */
	public static function get_dtb_rule_by_shop_uid($shop_uid)
	{
		return Dba::readRowAssoc('select * from shop_distribution where shop_uid =' . $shop_uid, 'DistributionMod::func_get_dtb_rule');
	}
    /*
     * 获取商品分销规则列表
     */
    public static function get_product_dtb_rule_by_shop_uid($option)
    {
        $sql = 'select * from shop_distribution_product ';
        if (!empty($option['shop_uid']))
        {
            $where_arr[] = ' shop_uid = ' . $option['shop_uid'];
        }
        if(!empty($option['status']))
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
        return Dba::readCountAndLimit($sql, $option['page'], $option['limit'],'DistributionMod::func_get_dtb_rule');
    }

    /*
    删除商品分销规则
    返回删除的条数
    */
    public static function delete_distribution_products($pids, $shop_uid) {
        if(!is_array($pids)) {
            $pids = array($pids);
        }
        $sql = 'delete from shop_distribution_product where uid in ('.implode(',',$pids).') and shop_uid = '.$shop_uid;
        $ret = Dba::write($sql);

        return $ret;
    }

	public static function func_get_dtb_rule($item)
	{
        if (!empty($item['p_uid']))
        {
            $item['product'] = ProductMod::get_shop_product_by_sku_uid($item['p_uid']);

        }
        if (!empty($item['rule_data']))
        {
            $item['rule_data'] = json_decode($item['rule_data'], true);
        }

		return $item;
	}

	/*
			2018-05-29
			新的分销算法
			返利总额: 以最终订单paid_fee 为准, 如果使用积分抵扣,优惠券或者订单改价等，以最终实际支付多少现金进行返利计算
					(如果订单不包邮的话，这里把邮费也算进去了)
			返利比例优先级:
			1. 如果有用户规则，以用户规则为准, (1.1 如果有用户分组规则，以分组规则为准)
			2. 如果有特定商品规则，以特定商品规则为准, (如果订单内含多种商品，且分销比例不一致，无法计算， 那就无视这条规则)
			3. 以默认规则为准

			如果不存在23，那么认为不开通分销功能，也没有1 (有的客户只想对某一个产品进行分销返利)
	*/
	public static function do_dtb_new($order) {
		if($order['paid_fee'] <= 0) return;
		if (!($dtb = self::get_dtb_rule_by_shop_uid($order['shop_uid']))
			|| empty($dtb['rule_data']) || $dtb['status']) {
			return;
		}
		uct_use_app('su');
		uct_use_app('vipcard');
		Event::addHandler('AfterDoDtb', array('DistributionMod', 'onAfterDoDtb'));
		
		$p_dtbs = array();
		foreach($order['products'] as $p) {
			if(($p_dtb = self::get_dtb_rule_by_shop_product_uid($order['shop_uid'], $p['sku_uid'])) &&
				(!$p_dtb['status']) && ($p_dtb = $p_dtb['rule_data']) && !in_array($p_dtb, $p_dtbs)) {
				$p_dtbs[] = $p_dtb;
			}	
		}
		if(count($p_dtbs) == 1) {
			$dtb['rule_data'] = $p_dtbs[0];		
		}
		
		$next_su_uid = $order['user_id'];
		foreach($dtb['rule_data'] as $level => $dv) {
			if(!$next_su_uid || !($su = AccountMod::get_service_user_by_uid($next_su_uid))) {
				break; //该用户不存在 退出
			}
			$su_uid = $next_su_uid;
			$next_su_uid = $su['from_su_uid'];

			if(0&& (!$dv[0] && !$dv[1])) { //
				continue;
			}

			if($dtb['need_vip']) {
        		if(!($vip = VipcardMod::get_vip_card_by_su_uid($su_uid)) || $vip['status']) {
					continue;
				}
			}	

			if(!$user_dtb = self::get_user_dtb_by_su_uid($su_uid)) {
				$user_dtb = array(
					'su_uid' => $su_uid,
					'status' => $dtb['need_check'] ? 0 : 1,
					'parent_su_uid' => $su['from_su_uid'],
				);
				self::add_or_edit_user_dtb($user_dtb);
				$user_dtb = self::get_user_dtb_by_su_uid($su_uid);
			}
			
			if(($dtb['need_check'] && $user_dtb['status'] != 1) || $user_dtb['status'] == 2) {
				continue;
			}
				
			//取一下特定用户的设置
			$rule_user = $user_dtb['rule_data'];
			if(!$rule_user) {
				if(($gid = SuGroupMod::get_user_group($su_uid)) && ($rule_user_group = self::get_su_group_dtb($gid))) {
					$rule_user = $rule_user_group;
				}
			}
			
			//用户规则不为空
			if(isset($rule_user[$level]) && ($rule_user[$level][0] || $rule_user[$level][1])) $dv = $rule_user[$level];
            $cash   = floor($order['paid_fee'] * $dv[0]/10000) + $dv[1];
			if ($cash <= 0) {
				continue;
			}

			$record = array(
				'su_uid' => $user_dtb['su_uid'],
				'cash'   => $cash,
				'info'   => '分销返利 #'.$order['uid'],
			);
			SuPointMod::increase_user_cash($record);
			$dtb_record = array(
				'su_uid'        => $user_dtb['su_uid'],
				'order_uid'     => $order['uid'],
				'cash'          => $cash,
				'level'         => $level,
				'parent_su_uid' => $su_uid,
				'weight'        => $dv[0],
				'fix'           => $dv[1],
				'paid_fee'      => $order['paid_fee'],
			);
			self::add_dtb_record($dtb_record);
			$user_dtbs = array(
				'su_uid'               => $user_dtb['su_uid'],
				'cash_sum'             => $user_dtb['cash_sum'] + $cash,
				'own_order_fee_sum'    => $user_dtb['own_order_fee_sum'] + (($level==0)?$order['paid_fee']:0),
				'family_order_fee_sum' => $user_dtb['family_order_fee_sum'] + (($level!=0)?$order['paid_fee']:0),
				'own_order_count'      => $user_dtb['own_order_count'] + (($level==0)?1:0),
				'family_order_count'   => $user_dtb['family_order_count'] + (($level!=0)?1:0),
			);
			self::add_or_edit_user_dtb($user_dtbs);

			Event::handle('AfterDoDtb', array($dtb_record));
		}

		
	}


	/*
	 * 进行分销 计算三级返利
	 */
	public static function do_dtb($order)
	{
		return self::do_dtb_new($order);

		if (!($dtb = self::get_dtb_rule_by_shop_uid($order['shop_uid']))
			|| empty($dtb['rule_data']) || $dtb['status']) {
			return;
		}
		uct_use_app('su');
        uct_use_app('vipcard');
		Event::addHandler('AfterDoDtb', array('DistributionMod', 'onAfterDoDtb'));

        //循环订单中的商品，计算分销
        foreach($order['products'] as $pv){
            $su_uid = $order['user_id'];

            ////找到各个商品的分销率-paid_price不同
            $pv['sku_uid'] = (int)$pv['sku_uid'];
            if($distribution = DistributionMod::get_dtb_rule_by_shop_product_uid($order['shop_uid'],$pv['sku_uid'])){
                $dtb = $distribution;
            }

		foreach ($dtb['rule_data'] as $dk => $dv) {
			if(!$su_uid || !($su = AccountMod::get_service_user_by_uid($su_uid))) {
				break; //该用户不存在 退出
			}

			if(!($user_dtb = self::get_user_dtb_by_su_uid($su_uid))){
				//用户不是分销_创建
				$user_dtb['su_uid'] = $su_uid;
				if($dtb['need_check']==0){
					$user_dtb['status'] = 1;
				}
				$user_dtb['parent_su_uid'] = $su['from_su_uid'];
				self::add_or_edit_user_dtb($user_dtb);
				$user_dtb = self::get_user_dtb_by_su_uid($su_uid);
			}

			//取上级信息
			$su_uid = $su['from_su_uid'];

//			$cash   = floor($order['paid_fee'] * $dv[0]/10000) + $dv[1];
            $cash   = (floor($pv['paid_price'] * $dv[0]/10000) + $dv[1])*$pv['quantity'];
			if ($cash <= 0) {
				continue;
			}

			$record = array(
				'su_uid' => $user_dtb['su_uid'],
				'cash'   => $cash,
				'info'   => '分销返利 #'.$order['uid'],
			);
			SuPointMod::increase_user_cash($record);
			$dtb_record = array(
				'su_uid'        => $user_dtb['su_uid'],
				'order_uid'     => $order['uid'],
				'cash'          => $cash,
				'level'         => $dk,
				'parent_su_uid' => $su_uid,
				'weight'        => $dv[0],
				'fix'           => $dv[1],
				'paid_fee'      => $order['paid_fee'],
			);
			self::add_dtb_record($dtb_record);
			$user_dtbs = array(
				'su_uid'               => $user_dtb['su_uid'],
				'cash_sum'             => $user_dtb['cash_sum'] + $cash,
//				'cash_sum'             => $user_dtb['cash_sum'] + $cash,
				'own_order_fee_sum'    => $user_dtb['own_order_fee_sum'] + (($dk==0)?$order['paid_fee']:0),
				'family_order_fee_sum' => $user_dtb['family_order_fee_sum'] + (($dk!=0)?$order['paid_fee']:0),
				'own_order_count'      => $user_dtb['own_order_count'] + (($dk==0)?1:0),
				'family_order_count'   => $user_dtb['family_order_count'] + (($dk!=0)?1:0),
			);
			self::add_or_edit_user_dtb($user_dtbs);

			//todo  短信 什么的
			Event::handle('AfterDoDtb', array($dtb_record));
		}
        }
	}

	public static function onAfterDoDtb($dtb_record)
	{
		//todo :: 发送短信 或模板消息
		uct_use_app('templatemsg');
		$su = AccountMod::get_service_user_by_uid($dtb_record['su_uid']);
		$sp_uid = $su['sp_uid'];
		$su_uid = $dtb_record['su_uid'];
		$dtb_record['user'] = $su;
		if(!empty($su_uid) )
		{
			$args = Template_Msg_WxPlugMod::get_do_dtb_args_by_user_dtb($dtb_record);
			Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__ . '.' . __FUNCTION__, $sp_uid, $su_uid, $args);
		}
	}

	/*
	 * 增加分销记录
	 */
	public static function add_dtb_record($dtb_record)
	{
		$dtb_record['create_time'] = $_SERVER['REQUEST_TIME'];

		return Dba::insert('shop_distribution_record', $dtb_record);
	}

	/*
	 * 获取分销记录 根据uid
	 */
	public static function get_dtb_record_by_uid($uid)
	{
		return Dba::readRowAssoc('select * from shop_distribution_record where uid = ' . $uid, 'DistributionMod::func_get_dtb');
	}

	public static function func_get_dtb($item)
	{
		if(!empty($item['su_uid']))
		{
			$item['user'] = AccountMod::get_service_user_by_uid($item['su_uid']);
		}
		if(!empty($item['parent_su_uid']))
		{
			$item['parent_user'] = AccountMod::get_service_user_by_uid($item['parent_su_uid']);
		}
		if(!empty($item['order_uid']))
		{
			$item['order'] = OrderMod::get_order_by_uid($item['order_uid']);
		}
		return $item;

	}

	public static function get_dtb_record_list($option)
	{
		$sql = 'select * from shop_distribution_record ';
		if (!empty($option['su_uid']))
		{
			$where_arr[] = ' su_uid ="' . $option['su_uid'] . '"';
		}
		if(!empty($option['sp_uid']))
		{
			$where_arr[] = ' su_uid in ( select uid from service_user where sp_uid = '.$option['sp_uid'].')';
		}
		if (!empty($option['order_uid']))
		{
			$where_arr[] = ' order_uid ="' . $option['order_uid'] . '"';
		}
		//父的情况 应该很少
		if (!empty($option['parent_su_uid']))
		{
			$where_arr[] = ' parent_su_uid ="' . $option['parent_su_uid'] . '"';
		}
		if (!empty($option['level']))
		{
			$where_arr[] = ' level ="' . $option['level'] . '"';
		}
		if(!empty($option['key']))
		{
			$where_arr[] = ' order_uid =' . $option['key'];
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by create_time desc';
		$option['page']  = isset($option['page']) ? $option['page'] : 0;
		$option['limit'] = isset($option['limit']) ? $option['limit'] : 10;
//var_dump($option);
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'DistributionMod::func_get_dtb');
	}

	/*
	 * 获取我的分销树 信息 只有下级
	 *  $su_uid 用户uid
	 */
	public static function get_user_dtb_tree($su_uid, $level = 1, $not_list = 0)
	{
		$user_list = array($su_uid);
		$dtb_tree  = array(
						'count' => 0,
						'order_count' => 0,
						'cash_sum' => 0,
						'order_fee_sum' => 0,
					);

		$level = min($level, 3);
		for ($i = 1; $i <= $level; $i++) {
			if (empty($user_list))
			{
				break;
			}
			$user_list             = self::get_user_next_level_user_list($user_list);
			$dtb_tree[$i]['count'] = count($user_list);

			// 统计各级 的订单数量和 订单金额和 佣金和
			$dtb_tree[$i]['order_count']   = array_sum(array_column($user_list, 'order_count'));
			$dtb_tree[$i]['cash_sum']      = array_sum(array_column($user_list, 'cash_sum'));
			$dtb_tree[$i]['order_fee_sum'] = array_sum(array_column($user_list, 'order_fee'));

			$dtb_tree['count'] += $dtb_tree[$i]['count'];
			$dtb_tree['order_count'] += $dtb_tree[$i]['order_count'];
			$dtb_tree['cash_sum'] += $dtb_tree[$i]['cash_sum'];
			$dtb_tree['order_fee_sum'] += $dtb_tree[$i]['order_fee_sum'];

			empty($not_list) && $dtb_tree[$i]['list'] = $user_list;
			$user_list = array_column($user_list, 'uid');
		}

		return $dtb_tree;
	}

	/*
	 * 获取用户直接下级用户uid列表
	 */
	public static function get_user_next_level_user_list($su_uid)
	{
		if (is_numeric($su_uid))
		{
			$su_uid = array($su_uid);
		}
		$sql = 'select uid from service_user where from_su_uid in (' . implode(' , ', $su_uid) . ')';

		return Dba::readallone($sql, 'DistributionMod::get_user_dtb_info');
	}

	/*
	 * 获取用户分销信息 分销总金额,订单总数,订单总金额
	 */
	public static function get_user_dtb_info($su_uid)
	{
		$sql = 'select sum(a.cash) as cash_sum,count(b.uid) as order_count,sum(b.paid_fee) as order_fee from shop_distribution_record as a ' .
			'join shop_order as b on a.order_uid  = b.uid' .
			' where  b.status = 4 and a.su_uid =' . $su_uid . ' and b.user_id=' . $su_uid;
		$ret         = Dba::readRowAssoc($sql);
		$ret['uid']  = $su_uid;
		$ret['user'] = AccountMod::get_service_user_by_uid($su_uid);
		return $ret;
	}

	/*
	删除分销用户信息
	*/
	public static function delete_distribution_user($pids) {
		if(!is_array($pids)) {
			$pids = array($pids);
		}
		$sql = 'delete from user_distribution where su_uid in ('.implode(',',$pids).')';
		$ret = Dba::write($sql);

		return $ret;
	}

	/*
	 * 编辑或添加 用户分销统计信息
	 */
	public static function add_or_edit_user_dtb($user_dtb)
	{
		if (Dba::readRowAssoc('select 1 from user_distribution where su_uid = ' . $user_dtb['su_uid']))
		{
			Dba::update('user_distribution', $user_dtb, 'su_uid = ' . $user_dtb['su_uid']);
		}
		else
		{
			$user_dtb['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('user_distribution', $user_dtb);

			//小程序模板消息
			Event::handle('AfterSetDistribution', array($user_dtb['su_uid']));
		}

	}

	/*
	 设置小程序模板消息 todo 发提示, 模板消息
	 */
	public static function onAfterSetDistribution($su_uid)
	{
		uct_use_app('vipcard');
		$distribution = DistributionMod::get_user_dtb_by_su_uid($su_uid);

		uct_use_app('templatexcxmsg');
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$xcxargs = Templatexcx_Msg_WxPlugMod::get_distribution_args_by_su_uid($distribution);
		Templatexcx_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__ . '.' . __FUNCTION__, $sp_uid, $su_uid, $xcxargs);
	}

	/*
	 * 获取用户分销统计信息
	 */
	public static function get_user_dtb_by_su_uid($su_uid)
	{
		return Dba::readRowAssoc('select * from user_distribution where su_uid = ' . $su_uid,'DistributionMod::func_get_user_dtb');
	}


	/*
		指定分组的分销比例设置
	*/
	public static function get_su_group_dtb($g_uid) {
		$key = 'dtb_group_'.$g_uid;	
		if(empty($GLOBALS['arraydb_sys'][$key])) {
			return array();
		}	
		return json_decode($GLOBALS['arraydb_sys'][$key], true);
	}

	public static function set_su_group_dtb($g_uid, $rule) {
		$key = 'dtb_group_'.$g_uid;	
		return $GLOBALS['arraydb_sys'][$key] = json_encode($rule);
	}


	public static function func_get_user_dtb($item)
	{
		if (!empty($item['su_uid']))
		{
			$item['user'] = AccountMod::get_service_user_by_uid($item['su_uid']);
		}
		if(!empty($item['from_su_uid']))
		{
			$item['parent_user'] = AccountMod::get_service_user_by_uid($item['from_su_uid']);
		}
		$item['L_cnt'] = self::get_user_dtb_tree($item['su_uid'],3,0);

		if(isset($item['L_cnt'][1])) $item['L1_cnt'] = $item['L_cnt'][1]['count'];
		if(isset($item['L_cnt'][2])) $item['L2_cnt'] = $item['L_cnt'][2]['count'];
		if(isset($item['L_cnt'][3])) $item['L3_cnt'] = $item['L_cnt'][3]['count'];
        if (!empty($item['rule_data'])) $item['rule_data'] = json_decode($item['rule_data'], true);
            

		return $item;
	}

	/*
	 * 获取用户分销统计信息列表
	 */
	public static function get_user_dtb_list($option)
	{
		$sql = 'select ud.*,su.name,su.account,su.from_su_uid from user_distribution as ud join service_user as su on ud.su_uid = su.uid ';

		if(!empty($option['sp_uid']))
		{
			$where_arr[] = ' ud.su_uid in ( select uid from service_user where sp_uid = '.$option['sp_uid'].')';
		}

		if (!empty($option['su_uid']))
		{
			$where_arr[] = ' ud.su_uid ="' . $option['su_uid'] . '"';
		}
		if (!empty($option['parent_su_uid']))
		{
			$where_arr[] = ' su.from_su_uid ="' . $option['parent_su_uid'] . '"';
		}
		if(!empty($option['key']))
		{
			$where_arr[] = 'su.name like "%'.addslashes($option['key']).'%" || su.account like "%'.addslashes($option['key']).'%"';
		}
		if (!empty($option['status']))
		{
			$where_arr[] = ' ud.status ="' . $option['status'] . '"';
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by ud.create_time desc';
		$option['page']  = isset($option['page']) ? $option['page'] : 0;
		$option['limit'] = isset($option['limit']) ? $option['limit'] : 10;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'DistributionMod::func_get_user_dtb');
	}

	/*
	 *  新分销用户注册成功 , 初始化分销信息
		更新一下推荐人统计信息
	 *
	 */
	public static function onAfterSuRegister($su)
	{
		$parent_su_uid = empty($GLOBALS['_TMP']['PARENT_SU_UID']) ? 0 : $GLOBALS['_TMP']['PARENT_SU_UID'];

		//不能扫自己
		if(($parent_su_uid == $su['uid'])) {
			$parent_su_uid = 0;
		}

		$shop = ShopMod::get_shop_by_sp_uid($su['sp_uid']);
		$dtb_rule = self::get_dtb_rule_by_shop_uid($shop['uid']);
		if(!$dtb_rule || ($dtb_rule['status'] != 0)) {
			return 'not open';
		}

		//自己初始化
		if (!($user_dtb = self::get_user_dtb_by_su_uid($su['uid']))) {
			$user_dtb = array('su_uid'        => $su['uid'],
			                  'parent_su_uid' => $parent_su_uid,
			                  'status'        => (($dtb_rule['need_check'] == 0) ? 1 : 0),
			                  'create_time'   => $_SERVER['REQUEST_TIME'],
			);
			self::add_or_edit_user_dtb($user_dtb);

			//更新一下su 
			Dba::write('update service_user set from_su_uid = '.$parent_su_uid.' where uid = '
					.$su['uid'].' && from_su_uid = 0');
		}
		else {
			//重新扫进来的
			if(!$user_dtb['parent_su_uid']) {
				$user_dtb = array('su_uid'        => $su['uid'],
			                  'parent_su_uid' => $parent_su_uid,
				);
				self::add_or_edit_user_dtb($user_dtb);
				//更新一下su 
				Dba::write('update service_user set from_su_uid = '.$parent_su_uid.' where uid = '
						.$su['uid'].' && from_su_uid = 0');
			}
			else {
				$parent_su_uid = 0;
			}
		}

		//向邀请者父级增加统计数据
		for ($i = 1; $i <= 3; $i++)
		{
			if (!$parent_su_uid || !($user_dtb = self::get_user_dtb_by_su_uid($parent_su_uid))) {
				break;
			}
			$parent_su_uid = $user_dtb['parent_su_uid'];

			//获取成功 注册用户邀请者或邀请者上级 增加 下级数量
			$user_dtb = array('su_uid' => $user_dtb['su_uid'],
				              'L'.$i.'_cnt' => $user_dtb['L'.$i.'_cnt'] + 1,
			);
			self::add_or_edit_user_dtb($user_dtb);
		}
		
		return 'ok';
	}

	/*
	 * 初始化一个分销用户
	 */
	public static function init_distribution_user($su)
	{
		//取商店uid
		$shop = ShopMod::get_shop_by_sp_uid($su['sp_uid']);
		//取出 分销设置
		$dtb_rule = self::get_dtb_rule_by_shop_uid($shop['uid']);

		//初始化分销用户后触发的事件
		Event::handle('AfterSuRegister', array($su));
		return self::get_user_dtb_by_su_uid($su['uid']);
	}

	//带分销的模板
	public static function get_dtb_tpl_array()
	{
		return array('b_wap', 'bestyou');
	}
}

