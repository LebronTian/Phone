<?php

/*
	微信小程序消息默认处理方式
*/

class Templatexcx_Msg_WxPlugMod {


	/*
	 *  模板消息 事件回调
	 */
	public static function onWeixinEventMsg()
	{
		if (WeixinMod::get_weixin_xml_args('Event') === 'TEMPLATESENDJOBFINISH')
		{

			self::template_message_event_callback();
		}
	}

	public static function template_message_event_callback()
	{
		$callback = WeixinMod::get_weixin_xml_args();
		Weixin::weixin_log('weixin template_msg_message_event_callback ===== ' . json_encode($callback));
		$msg_id                 = $callback['MsgID'];
		$template_msg           = array('event_callback' => json_encode($callback));
		$status                 = array('success' => '3', 'failed:user block' => '1', 'failed: system failed' => '2');
		$template_msg['status'] = isset($status[$callback['Status']]) ? $status[$callback['Status']] : '';
		Dba::update('templatexcx_msg_record', $template_msg, 'msg_id="' . $msg_id . '"');
	}


	/*
	 * 设置行业
	 * $data =   {
          "industry_id1":"1",
          "industry_id2":"4"
       }
		参数 	     是否必须 	说明
		industry_id1 	是 	公众号模板消息所属行业编号
		industry_id2 	是 	公众号模板消息所属行业编号
	 */
	public static function wx_set_industry($public_uid, $data)
	{
		$ret = Weixin::weixin_set_industry($data, WeixinMod::get_weixin_access_token($public_uid));

		if (!$ret || !($ret = json_decode($ret, true)) || !empty($ret['errcode']))
		{
			setLastError(ERROR_IN_WEIXIN_API);
			outRight(empty($ret['errcode']) ? 'false' : $ret['errcode']);
		}

		return true;
	}

	public static function xcx_get_template_list($public_uid,$refresh_force = false)
	{
		if(($ret = $GLOBALS['arraydb_weixin_public']['xcx_template_list_'.$public_uid]) && $refresh_force==false)
		{
			return json_decode($ret,true);
		}

		$ret = Weixin::xiaochengxu_get_all_private_template(WeixinMod::get_weixin_access_token($public_uid));

		if($ret)
		{
			if(!isset($ret['list'])){
				$ret['list'] = '';
			}
			$GLOBALS['arraydb_weixin_public']['xcx_template_list_'.$public_uid] =array('value'=>$ret['list'],'expire'=>time()+60*60*24);
		}
		return $ret['list'];
	}

	public static function wx_send_template_msg($public_uid, $data)
	{
		$ret2 = $ret = Weixin::xiaochengxu_send_template_msg($data, WeixinMod::get_weixin_access_token($public_uid));
		if (!$ret || !($ret = json_decode($ret, true)) || !empty($ret['errcode']))
		{
			Weixin::weixin_log('['.$public_uid.']xcx_send_template fail!!: '.$ret2);
			$GLOBALS['_TMP']['WEIXIN_ERROR'] = empty($ret['errcode']) ? 'false' : $ret['errcode'];
			setLastError(ERROR_IN_WEIXIN_API);
			return false;
			//			outRight(empty($ret['errcode']) ? 'false' : $ret['errcode']);
		}

		return $ret['errmsg'];
	}

	/*
	 *  微信取模板id
	 * $data = {
           "template_id_short":"TM00015"
       }
	 */
	public static function wx_get_template($public_uid, $data)
	{
		$ret = Weixin::weixin_get_template_id($data, WeixinMod::get_weixin_access_token($public_uid));
		if (!$ret || !($ret = json_decode($ret, true)) || !empty($ret['errcode']))
		{
			setLastError(ERROR_IN_WEIXIN_API);

			//			outRight(empty($ret['errcode']) ? 'false' : $ret['errcode']);
			return false;
		}


		return $ret['template_id'];
	}

	/*
	 * 配置 模板消息
	 */
	public static function add_or_edit_user_template($user_template)
	{

		if (!empty($user_template['uid']))
		{
			Dba::update('templatexcx_msg_set', $user_template, 'uid =' . $user_template['uid']);
		}
		else
		{
			$user_template['create_time'] = $_SERVER['REQUEST_TIME'];
			$user_template['uid']         = Dba::insert('templatexcx_msg_set', $user_template);
		}

		return $user_template['uid'];
	}

	/*
	 * 根据模板消息配置 uid 取 模板消息配置信息
	 */
	public static function get_user_template_by_uid($uid)
	{
		return Dba::readRowAssoc('select * from templatexcx_msg_set where uid =' . $uid, 'Templatexcx_Msg_WxPlugMod::func_get_user_template');
	}

	public static function func_get_user_template($item)
	{
		if (!empty($item['template_data']))
		{
			$item['template_data'] = json_decode($item['template_data'], true);
		}
		if (!empty($item['public_uid']))
		{
			$item['public'] = WeixinMod::get_weixin_public_by_uid($item['public_uid']);
			if ($item['public'])
			{
				unset($item['public']['aes_key']);
				unset($item['public']['app_id']);
				unset($item['public']['app_secret']);
				unset($item['public']['origin_id']);
				unset($item['public']['uct_token']);
			}

		}
		if (!empty($item['su_uid']))
		{
			$item['user'] = AccountMod::get_service_user_by_uid($item['su_uid']);
		}

		return $item;
	}

	/*
	 * 根据uid删除模板消息配置
	 */
	public static function delete_user_template($uids, $sp_uid)
	{
		if (!is_array($uids))
		{
			$uids = array(
				$uids,
			);
		}

		return Dba::write('delete from templatexcx_msg_set where uid in (' . implode(',', $uids) . ') and sp_uid =' . $sp_uid);

	}


	public static function get_templatexcx_msg_set_list($option)
	{

		$sql = 'select * from templatexcx_msg_set';
		if (isset($option['sp_uid']))
		{
			$where_arr[] = ' sp_uid =' . $option['sp_uid'];
		}
		if (!empty($option['public_uid']))
		{
			$where_arr[] = ' public_uid =' . $option['public_uid'];
		}
		if (!empty($option['status']))
		{
			$where_arr[] = ' status =' . $option['status'];
		}
		if (!empty($option['even']))
		{
			$where_arr[] = ' even ="' . $option['even'] . '"';
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by create_time desc';
		$option['page']  = isset($option['page']) ? $option['page'] : 0;
		$option['limit'] = isset($option['limit']) ? $option['limit'] : -1;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'Templatexcx_Msg_WxPlugMod::func_get_user_template');

	}

	/*
	 * 增加模板消息发送记录
	 */
	public static function add_templatexcx_msg_record($remplate_msg_record)
	{
		if (!empty($remplate_msg_record['uid']))
		{
			Dba::update('templatexcx_msg_record', $remplate_msg_record, 'uid =' . $remplate_msg_record['uid']);
		}
		else
		{
			$remplate_msg_record['create_time'] = $_SERVER['REQUEST_TIME'];
			$remplate_msg_record['uid']         = Dba::insert('templatexcx_msg_record', $remplate_msg_record);
		}

		return $remplate_msg_record['uid'];
	}

	/*
	 * 取模板消息发送记录列表
	 */
	public static function get_templatexcx_msg_record_list($option)
	{
		$sql = 'select * from templatexcx_msg_record';
		if (!empty($option['sp_uid']))
		{
			$where_arr[] = ' sp_uid =' . $option['sp_uid'];
		}
		if (!empty($option['public_uid']))
		{
			$where_arr[] = ' public_uid =' . $option['public_uid'];
		}
		if (!empty($option['status']))
		{
			$where_arr[] = ' status =' . $option['status'];
		}
		if (!empty($option['su_uid']))
		{
			$where_arr[] = ' su_uid =' . $option['su_uid'];
		}
		if (!empty($option['even']))
		{
			$where_arr[] = ' even  like "%%' . $option['even'] . '%%"';
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by uid desc';
		$option['page']  = isset($option['page']) ? $option['page'] : 0;
		$option['limit'] = isset($option['limit']) ? $option['limit'] : 10;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'Templatexcx_Msg_WxPlugMod::func_get_template_smg_record');
	}

	/*
	 * 根据模板消息记录uid 取模板消息记录信息
	 */
	public static function get_template_smg_record_by_uid($uid)
	{

		return Dba::readAllAssoc('select * from templatexcx_msg_record where uid = ' . $uid, 'Templatexcx_Msg_WxPlugMod::func_get_template_smg_record');
	}

	public static function func_get_template_smg_record($item)
	{
		if (!empty($item['data']))
		{
			$item['data'] = json_decode($item['data'], true);
		}
		if (!(empty($item['event_callback'])))
		{
			$item['event_callback'] = json_decode($item['event_callback'], true);
		}
		if (!empty($item['su_uid']))
		{
			$item['user'] = AccountMod::get_service_user_by_uid($item['su_uid']);
		}
		if (!empty($item['public_uid']))
		{
			$item['public_name'] = Dba::readone('select public_name from weixin_public where uid=' . $item['public_uid']);
		}

		return $item;
	}

	//编辑模板消息模板库内模板
	public static function add_or_edit_templatexcx_library($templatexcx_library)
	{
		$templatexcx_library['uid'] = Dba::readOne('select uid from templatexcx_library where ts_id="' . $templatexcx_library['ts_id'] . '"');
		if (!empty($templatexcx_library['uid']))
		{
			Dba::update('templatexcx_library', $templatexcx_library, 'uid =' . $templatexcx_library['uid']);
		}
		else
		{
			unset($templatexcx_library['uid']);
			$templatexcx_library['create_time'] = $_SERVER['REQUEST_TIME'];
			$templatexcx_library['uid']         = Dba::insert('templatexcx_library', $templatexcx_library);
		}

		return $templatexcx_library['uid'];
	}

	//根据模板编号获取模板消息的模板信息
	public static function get_templatexcx_library_by_ts_id($ts_id)
	{
		return Dba::readRowAssoc('select * from templatexcx_library where ts_id="' . $ts_id . '"', 'Templatexcx_Msg_WxPlugMod::func_get_templatexcx_library');
	}

	public static function get_templatexcx_library_by_uid($uid)
	{
		return Dba::readRowAssoc('select * from templatexcx_library where uid=' . $uid . '', 'Templatexcx_Msg_WxPlugMod::func_get_templatexcx_library');
	}

	//获取模板消息模板库模板列表
	public static function get_templatexcx_library_list($option)
	{

	}

	public static function func_get_templatexcx_library($item)
	{
		if (!empty($item['template_data']))
		{
			$item['template_data'] = json_decode($item['template_data'], true);
		}
		if (!empty($item['details']))
		{
			$item['details'] = htmlspecialchars($item['details']);
		}

		return $item;
	}

	public static function delete_templatexcx_library($uids)
	{
		if (!is_array($uids))
		{
			$uids = array(
				$uids,
			);
		}

		return Dba::write('delete from templatexcx_library where uid in (' . implode(',', $uids) . ')');

	}


	/*
	 * 事件触发发送模板消息
	 *
	 * ERROR_DBG_STEP_1 取用户openid失败
	 * ERROR_DBG_STEP_2 取模板消失配置失败
	 * ERROR_IN_WEIXIN_API 发送失败
	 * $args 参数说明   固定参数 url     模板消息跳转链接 可以为空
	 *                 动态参数 根据具体的even
	 */
	public static function after_even_send_template_msg($even, $sp_uid, $user_id, $args)
	{
		//sp_uid =0 为
		$sql = 'select * from templatexcx_msg_set where even = "' . $even .
				 '" and (sp_uid = ' . $sp_uid . ' or sp_uid =0 ) and status =0';
		$templatexcx_msg_sets = Dba::readAllAssoc($sql);
		if (empty($templatexcx_msg_sets)) {
			return false;
		}
		foreach ($templatexcx_msg_sets as $templatexcx_msg_set) {
			if (empty($templatexcx_msg_set) ||
				empty($templatexcx_msg_set['template_id']) ||
				empty($templatexcx_msg_set['public_uid']) ||
				empty($templatexcx_msg_set['template_data'])
			)
			{
				//setLastError(ERROR_DBG_STEP_2);
				continue;
			}
			//拼装 template_data
			$templatexcx_msg_set['template_data'] = json_decode($templatexcx_msg_set['template_data'], true);
			foreach ($templatexcx_msg_set['template_data'] as $kk => $key)
			{
				if (preg_match_all('/EVEN\.([\w\.]+?)\.EVEN/', $key['value'], $ret))
				{
					$i = 0;
					foreach ($ret['0'] as $r)
					{
						$strtr_arr[$r] = (isset($args[$ret['1'][$i]]) ? $args[$ret['1'][$i]] : '');
						$i++;
					}
					$templatexcx_msg_set['template_data'][$kk]['value'] = strtr($key['value'], $strtr_arr);
				}
				else
				{
					$templatexcx_msg_set['template_data'][$kk]['value'] = $key['value'];
				}
			}

			if (empty($templatexcx_msg_set['su_uid']))
			{
			    if(empty($user_id))
                {
                    continue;
                }
				$xiaochengxu_fans = Dba::readRowAssoc('select * from weixin_fans_xiaochengxu where su_uid=' . $user_id.' && public_uid = '.$templatexcx_msg_set['public_uid']);
			}
			else
			{
				$xiaochengxu_fans = Dba::readRowAssoc('select * from weixin_fans_xiaochengxu where su_uid=' . $templatexcx_msg_set['su_uid'].' && public_uid = '.$templatexcx_msg_set['public_uid']);
			}

			if (empty($xiaochengxu_fans['open_id']))
			{
				continue;
			}
			//设定 官方微信的粉丝 即发给 商户绑定的微信号
			if ($xiaochengxu_fans['public_uid'] != $templatexcx_msg_set['public_uid'])
			{
				$templatexcx_msg_set['public_uid'] = $xiaochengxu_fans['public_uid'];
				$user_id                        = $xiaochengxu_fans['su_uid'];
			}
			$data = array('touser'      => $xiaochengxu_fans['open_id'],
			              'template_id' => $templatexcx_msg_set['template_id'],
						  'page'		=> isset($templatexcx_msg_set['page']) ? $templatexcx_msg_set['page'] : '',
						  'form_id'     => $args['formId'],
			              'data'        => $templatexcx_msg_set['template_data']);
            Queue::add_job('templatexcxmsg_sendJob',array($data,$templatexcx_msg_set,$user_id));
		}
		return true;
	}


	/*
	 *     通过 模板详情 取得 模板数组
	 *     $details = '{{first.DATA}}

			支付金额：{{orderMoneySum.DATA}}
			商品信息：{{orderProductName.DATA}}
			{{Remark.DATA}}';
	 */
	public static function get_template_array_from_details($details)
	{
		preg_match_all('/\{\{\w+\.DATA\}\}/', $details, $ret);
		if (empty($ret))
		{
			setLastError(ERROR_DBG_STEP_1);

			return false;
		}
		else
		{
			foreach ($ret['0'] as $key)
			{
				$keys[] = strtr($key, array('{{' => '', '}}' => '', '.DATA' => ''));
			}
			foreach ($keys as $key)
			{
				$template_array[$key] = array('value' => '', 'color' => '#173177');

			}
		}

		return $template_array;
	}

	//根据模板消息接口 格式化 提交数据 将 前端格式装换成后端数据格式  EVEN.0.EVEN 装换成 EVEN.create_teim.EVEN
	public static function get_template_data_from_template_arr($template_arr, $template_data, $mod)
	{

		$even_args_arr = self::get_even_args_arr($mod, 'key');
		foreach ($even_args_arr as $ek => $e)
		{
			$news_even_args_arr['EVEN.' . $ek . '.EVEN'] = 'EVEN.' . $e . '.EVEN';
		}
		$news_even_args_arr["\t"] = '';

		foreach ($template_arr as $temk => $tem)
		{
			if (isset($template_data[$temk]))
			{
				foreach ($template_arr[$temk] as $tek => $te)
				{

					if (isset($template_data[$temk][$tek]))
					{
						$template_arr[$temk][$tek] = strip_tags(strtr($template_data[$temk][$tek], $news_even_args_arr));
						//						$template_arr[$temk][$tek] =strtr($template_data[$temk][$tek], $news_even_args_arr);
					}
				}
			}

		}

		return $template_arr;
	}

	// 将后台template_data数据格式 转换成前台格式
	public static function get_template_data_back($template_data, $mod)
	{
		$even_args_arr = self::get_even_args_arr($mod, 'key');
		foreach ($even_args_arr as $ek => $e)
		{
			$news_even_args_arr['EVEN.' . $e . '.EVEN'] = 'EVEN.' . $ek . '.EVEN';
		}
		foreach ($template_data as $temk => $tem)
		{
			foreach ($tem as $tek => $te)
			{
				$template_data[$temk][$tek] = strtr($te, $news_even_args_arr);
			}
		}

		return $template_data;
	}


	// 取各板块 可被配置为模板消息数组
	public static function get_even_args_arr($type = 0, $key = '')
	{
		(!empty($key) && ($key != 'key' && $key != 'title')) && $key = '';
		/*
		 *   1 商城的参数
		 *   2 养老的参数
		 *   3 分销的参数
		 */
		$get_even_args_arr = array(
			'1'   => array(
				'0'  => array('key' => 'create_time', 'title' => '下单时间'),
				'1'  => array('key' => 'send_time', 'title' => '发货时间'),
				'2'  => array('key' => 'recv_time', 'title' => '收货时间'),
				'3'  => array('key' => 'paid_fee', 'title' => '支付金额'),
				'4'  => array('key' => 'paid_time', 'title' => '支付时间'),
				'5'  => array('key' => 'discount_fee', 'title' => '已优惠价格'),
				'6'  => array('key' => 'delivery_fee', 'title' => '邮费'),
				'7'  => array('key' => 'use_point', 'title' => '使用积分'),
				'8'  => array('key' => 'back_point', 'title' => '返回积分'),
				'9'  => array('key' => 'uid', 'title' => '订单号'),
				'10' => array('key' => 'adress', 'title' => '地址信息'),
				'11' => array('key' => 'delivery_info', 'title' => '快递信息'),
				'12' => array('key' => 'products', 'title' => '订单商品详情'),
				'13' => array('key' => 'cancel_time', 'title' => '取消订单时间'),
				'14' => array('key' => 'refund.create_time', 'title' => '申请退款时间'),
				'15' => array('key' => 'refund_fee', 'title' => '退款金额'),
				'16' => array('key' => 'accept_time', 'title' => '商家退款确认时间'),
				'17' => array('key' => 'refund_time', 'title' => '退款时间'),
				'18' => array('key' => 'refund.refund_info.reason', 'title' => '退款理由'),
				'19' => array('key' => 'refund.refund_info.sp_reason', 'title' => '拒绝退款理由'),
				'20' => array('key' => 'pay_type', 'title' => '付款方式'),
			),
			'2'   => array(
				'0'  => array('key' => 'user_name', 'title' => '用户名'),
				'1'  => array('key' => 'vip_name', 'title' => 'vip等级'),
				'2'  => array('key' => 'set_time', 'title' => '设置时间'),
			),
			'3'   => array(
				'0'  => array('key' => 'user_name', 'title' => '用户名'),
				'1'  => array('key' => 'set_time', 'title' => '设置时间'),
			),
		);
		(!empty($type) && !empty($key)) && $get_even_args_arr = array_column($get_even_args_arr[$type], $key);
		(!empty($type) && empty($key)) && $get_even_args_arr = $get_even_args_arr[$type];

		return $get_even_args_arr;
	}

	// 取触发模板消息时间数组  与 sp内的保持一致
	public static function get_even_arr($type = 0, $key = '')
	{
		(!empty($key) && ($key != 'key' && $key != 'title')) && $key = '';
		$even_arr = array(
			'1'   => array(
//				'0' => array('key' => 'OrderMod.onAfterMakeOrder', 'title' => '新增订单'),
//				'1' => array('key' => 'OrderMod.onAfterOrderPay', 'title' => '支付成功'),
				'2' => array('key' => 'OrderMod.onAfterSendGoods', 'title' => '卖家发货'),
//				'3' => array('key' => 'OrderMod.onAfterRecvGoods', 'title' => '用户收货'),
//				'4' => array('key' => 'OrderMod.onAfterCancelOrder', 'title' => '取消订单'),
//				'5' => array('key' => 'RefundMod.onAfterAddRefund', 'title' => '退款申请'),
//				'6' => array('key' => 'RefundMod.onAfterCancelRefund', 'title' => '取消退款'),
//				'7' => array('key' => 'RefundMod.onAfterAcceptRefund', 'title' => '卖家拒绝退款'),
//				'8' => array('key' => 'RefundMod.onAfterPayRefund', 'title' => '退款成功'),
			),
			'2'   => array(
				'0' => array('key' => 'SuPointMod.onAfterSetVip', 'title' => '设置会员'),
			),
			'3'   => array(
				'0' => array('key' => 'DistributionMod.onAfterSetDistribution', 'title' => '设置分销商'),
			),

		);
		(!empty($type) && !empty($key)) && $even_arr = array_column($even_arr[$type], $key);

		return $even_arr;
	}

	public static function get_even_arr_all()
	{
		$even_arrs = self::get_even_arr();
		foreach ($even_arrs as $eak => $even_arr)
		{
			foreach ($even_arr as $k => $even)
			{
				$ret[$even['key']]['key']   = $eak * 1000 + $k;
				$ret[$even['key']]['title'] = $even['title'];
			}
		}

		return $ret;
	}

	//商城发模板消息前 处理参数
	public static function get_shop_args_by_order($order)
	{
		static $pay_type_arr = array('1' => '免费无需付款', '2' => '货到付款', 
									'8' => '余额支付', '9' => '测试支付', 
									'10' => '支付宝', '11' => '微信支付');

		$address = '';
		if (!empty($order['address']))
		{
			$address = (!is_array($order['address']) ? json_decode($order['address'], true) : $order['address']);
			$address = @($address['province'] . $address['city'] . $address['town'] . $address['address']);
		}
		if (!empty($order['delivery_info']))
		{
			$delivery_infos = (!is_array($order['delivery_info']) ? json_decode($order['delivery_info'], true) : $order['delivery_info']);
			$delivery_info  = '';
			foreach ($delivery_infos as $dk => $d)
			{
				$delivery_info .= $dk . ':' . $d . "\n";
			}
			$delivery_info = trim($delivery_info, "\n");

		}
		if (!empty($order['products']))
		{
			$products     = '';
			$products_arr = (!is_array($order['products']) ? json_decode($order['products'], true) : $order['products']);
			foreach ($products_arr as $product)
			{
				$products .= $product['title'] . ' ' . sprintf("%.2f", $product['paid_price'] / 100) . 'x' . $product['quantity'] . "\n";
			}
			$products = trim($products, "\n");
		}
		//获取能使用的form_id
		$form_id = XiaochengxuMod::get_a_form_id($order['user_id']);
		if(!isset($order['info']['formId'])){
			$order['info']['formId'] = '';
		}

		//与 get_even_args_arr 中数组1 对应
		$args =
			array(
				'create_time'                  => (empty($order['create_time']) ? '' : date('Y-m-d H:i:s', $order['create_time'])),
				'send_time'                    => (empty($order['send_time']) ? '' : date('Y-m-d H:i:s', $order['send_time'])),
				'recv_time'                    => (empty($order['recv_time']) ? '' : date('Y-m-d H:i:s', $order['recv_time'])),
				'paid_fee'                     => (empty($order['paid_fee']) ? '' : sprintf("%.2f", $order['paid_fee'] / 100)),
				'paid_time'                    => (empty($order['paid_time']) ? '' : date('Y-m-d H:i:s', $order['paid_time'])),
				'discount_fee'                 => (empty($order['discount_fee']) ? '' : sprintf("%.2f", $order['discount_fee'] / 100)),
				'delivery_fee'                 => (empty($order['delivery_fee']) ? '' : sprintf("%.2f", $order['delivery_fee'] / 100)),
				'use_point'                    => (empty($order['use_point']) ? '' : $order['use_point']),
				'back_point'                   => (empty($order['back_point']) ? '' : $order['back_point']),
				'uid'                          => (empty($order['uid']) ? '' : $order['uid']),
				'adress'                       => (empty($address) ? '' : $address),
				'delivery_info'                => (empty($delivery_info) ? '' : $delivery_info),
				'products'                     => (empty($products) ? '' : $products),
				'cancel_time'                  => date('Y-m-d H:i:s', $_SERVER['REQUEST_TIME']),
				'refund.create_time'           => (empty($order['refund']['create_time']) ? '' : date('Y-m-d H:i:s', $order['refund']['create_time'])),
				'refund_fee'                   => (empty($order['refund']['refund_fee']) ? '' : sprintf("%.2f", $order['refund']['refund_fee'] / 100)),
				'accept_time'                  => (empty($order['refund']['accept_time']) ? '' : date('Y-m-d H:i:s', $order['refund']['accept_time'])),
				'refund_time'                  => (empty($order['refund']['refund_time']) ? '' : date('Y-m-d H:i:s', $order['refund']['refund_time'])),
				'refund.refund_info.reason'    => (empty($order['refund']['refund_info']['reason']) ? '' : $order['refund']['refund_info']['reason']),
				'refund.refund_info.sp_reason' => (empty($order['refund']['refund_info']['sp_reason']) ? '' : $order['refund']['refund_info']['sp_reason']),
				'pay_type'                     => (empty($order['pay_type']) ? '未设置' : $pay_type_arr[$order['pay_type']]),
				'formId'                    => (empty($formID)?$order['info']['formId']:$formID),
			);
		return $args;
	}

	//设置会员发模板消息前 处理参数
	public static function get_vip_args_by_su_uid($vip)
	{
		if(empty($vip)){
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		$su = AccountMod::get_service_user_by_uid($vip['su_uid']);
		//获取能使用的form_id
		$form_id = XiaochengxuMod::get_a_form_id($order['user_id']);

		//与 get_even_args_arr 中数组1 对应
		$args =
			array(
				'user_name'                  => (empty($su['name']) ? '' : $su['name']),
				'vip_name'                    => (empty($vip['rank']) ? '' : $vip['rank']),
				'set_time'                    => $time,
				'formId'                    => (empty($formID)?'':$formID),
			);
		return $args;
	}

	//设置分销商发模板消息前 处理参数
	public static function get_distribution_args_by_su_uid($distribution)
	{
		if(empty($distribution)){
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		//获取能使用的form_id
		$form_id = XiaochengxuMod::get_a_form_id($order['user_id']);

		//与 get_even_args_arr 中数组1 对应
		$args =
			array(
				'user_name'                  => (empty($distribution['user']['name']) ? '' : $distribution['user']['name']),
				'set_time'                    => $time,
				'formId'                    => (empty($formID)?'':$formID),
			);
		return $args;
	}

	/*
	 * 处理 分销增加新成员 参数
	 */
	public static function get_dtb_reg_args_by_user_dtb($dtb)
	{
		uct_use_app('shop');
		$ret = DistributionMod::get_user_dtb_by_su_uid($dtb['parent_su_uid']);
		$args = array(
			'register.create_time'             => (empty($dtb['create_time']) ? '' : date('Y-m-d H:i:s', $dtb['create_time'])),
			'register.parent_name'                => ((empty($dtb['parent_user']['name']) ? '' : $dtb['parent_user']['name'])),
			'register.user_name'               => (empty($dtb['user']['name']) ? '' : $dtb['user']['name']),
			'register.parent_l1_cnt'            => (empty($ret['L1_cnt']) ? '' : $ret['L1_cnt']),
			'dtb.create_time'             => '',
			'dtb.user_name'                => '',
			'dtb.cash'               => '',
					);
		return $args;
	}

	/*
	 * 处理 分销分红 参数
	 */
	public static function get_do_dtb_args_by_user_dtb($dtb_record)
	{
		$args = array(
			'register.create_time'             => '',
			'register.parent_name'                => '',
			'register.user_name'               => '',
			'register.parent_l1_cnt'            => '',
			'dtb.create_time'             => (!empty($dtb_record['create_time']) ? '' : date('Y-m-d H:i:s', $_SERVER['REQUEST_TIME'])),
			'dtb.user_name'                => ((empty($dtb_record['user']['name']) ? '' : $dtb_record['user']['name'])),
			'dtb.cash'               => (empty($dtb_record['cash']) ? '0' : sprintf("%.2f", $dtb_record['cash'] / 100)),
		);
		return $args;
	}
}

