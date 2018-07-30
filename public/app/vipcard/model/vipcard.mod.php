<?php


class  VipcardMod {

	const STATUS_VIPCARD_SU_PASS = 0;//通过审核
	const STATUS_VIPCARD_SU_WAIT = 1;//等待审核
	const STATUS_VIPCARD_SU_FAIL = 2;//不通过审核

	public static function add_or_edit_vip_card_sp_set($vip_card_sp_set)
	{
		if (!empty($vip_card_sp_set['uid']))
		{
			Dba::update('vip_card_sp_set', $vip_card_sp_set, 'uid = ' . $vip_card_sp_set['uid'] . ' and sp_uid = ' . $vip_card_sp_set['sp_uid']);
		}
		else
		{
			//设置默认 ui_set content_set rank_rule
			$vip_card_sp_set['ui_set']    = '{"back_ground":{"path":"","size":[520,330]},' .
				'"image":{"logo":{"path":"","size":[88,88],"point":[407,32]},"0":{"l":"44","path":"","size":[88,88],"point":[32,121]}},' .
				'"string":[{"content":"","size":"28","color":["241","241","241"],"point":[166,122],"bold":"0"},' .
				'{"content":"","size":"28","color":["241","241","241"],"point":[166,182],"bold":"0"},' .
				'{"content":"","size":"28","color":["241","241","241"],"point":[80,278],"bold":"0"}]}';
			$vip_card_sp_set['rank_rule'] = '{"1":{"rank_name":"普通会员","rank_discount":"100"},"2":{"rank_name":"白银会员","rank_discount":"100"},"3":{"rank_name":"黄金会员","rank_discount":"100"}}';
			$vip_card_sp_set['connent']   = '{"name":{"need":"0","title":"姓名","value":"","group":"user","show":"1","show_title":"1"},' .
				'"birthday":{"need":"0","title":"生日","value":"","group":"user","show":"2","show_title":"1"},' .
				'"email":{"need":"0","title":"邮箱","value":"","group":"user_profile"},' .
				'"other_0":{"need":"0","title":"行业","value":"","group":"vip_card_su"},' .
				'"other_1":{"need":"0","title":"爱好","value":"","group":"vip_card_su"},' .
				'"avatar":{"need":"0","title":"头像","value":"","group":"user"},' .
				'"card_id":{"need":"0","title":"会员卡","value":"","group":"vip_card_su","show":"3","protect":"1"}}';

			$vip_card_sp_set['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('vip_card_sp_set', $vip_card_sp_set);
			$vip_card_sp_set['uid'] = Dba::insertID();
		}

		return $vip_card_sp_set['uid'];
	}

	public static function get_vip_card_sp_set_list()
	{
		$sql = 'select * from vip_card_su';
		if (!empty($option['public_uid']))
		{
			$where_arr[] = 'public_uid=' . $option['public_uid'];
		}
		if (!empty($option['status']))
		{
			$where_arr[] = 'status=' . $option['status'];
		}
		if (!empty($option['sp_uid']))
		{
			$where_arr[] = 'sp_uid=' . $option['sp_uid'];
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by uid desc';
		$option['page']  = isset($option['page']) ? $option['page'] : 0;
		$option['limit'] = isset($option['limit']) ? $option['limit'] : 10;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'VipcardMod::func_get_vip_card_sp_set');

	}

	public static function get_vip_card_sp_set_by_uid($uid)
	{
		return Dba::readRowAssoc('select * from vip_card_sp_set where uid =' . $uid, 'VipcardMod::func_get_vip_card_sp_set');

	}


	public static function get_vip_card_sp_set_by_sp_uid($sp_uid=0)
	{
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}
		$sql = 'select * from vip_card_sp_set where sp_uid ='.$sp_uid;
		if(!($vip_card_sp_set = Dba::readRowAssoc($sql, 'VipcardMod::func_get_vip_card_sp_set')))
		{
			$vip_card_sp_set['sp_uid'] = $sp_uid;
			//设置默认 ui_set content_set rank_rule
			$vip_card_sp_set['ui_set']    = '{"back_ground":{"path":"","size":[520,330]},' .
				'"image":{"logo":{"path":"","size":[88,88],"point":[407,32]},"0":{"l":"44","path":"","size":[88,88],"point":[32,121]}},' .
				'"string":[{"content":"","size":"28","color":["241","241","241"],"point":[166,122],"bold":"0"},' .
				'{"content":"","size":"28","color":["241","241","241"],"point":[166,182],"bold":"0"},' .
				'{"content":"","size":"28","color":["241","241","241"],"point":[80,278],"bold":"0"}]}';
			$vip_card_sp_set['rank_rule'] = '{"1":{"rank_name":"普通会员","rank_discount":"100"},"2":{"rank_name":"白银会员","rank_discount":"100"},"3":{"rank_name":"黄金会员","rank_discount":"100"}}';
			$vip_card_sp_set['connent']   = '{"name":{"need":"0","title":"姓名","value":"","group":"user","show":"1","show_title":"1"},' .
				'"birthday":{"need":"0","title":"生日","value":"","group":"user","show":"2","show_title":"1"},' .
				'"email":{"need":"0","title":"邮箱","value":"","group":"user_profile"},' .
				'"other_0":{"need":"0","title":"行业","value":"","group":"vip_card_su"},' .
				'"other_1":{"need":"0","title":"爱好","value":"","group":"vip_card_su"},' .
				'"avatar":{"need":"0","title":"头像","value":"","group":"user"},' .
				'"card_id":{"need":"0","title":"会员卡","value":"","group":"vip_card_su","show":"3","protect":"1"}}';

			$vip_card_sp_set['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('vip_card_sp_set', $vip_card_sp_set);
			$vip_card_sp_set['uid'] = Dba::insertID();
			$vip_card_sp_set = Dba::readRowAssoc($sql, 'VipcardMod::func_get_vip_card_sp_set');
		}
//		var_dump(__file__.' line:'.__line__,$sql);exit;
		return $vip_card_sp_set;

	}

	public static function func_get_vip_card_sp_set($item)
	{
		if (!empty($item['rank_rule']))
		{
			$item['rank_rule'] = json_decode($item['rank_rule'], true);
		}
		if (!empty($item['rank_name']))
		{
			$item['rank_name'] = json_decode($item['rank_name'], true);
		}
		if (!empty($item['ui_set']))
		{
			$item['ui_set'] = json_decode($item['ui_set'], true);
		}
		if (!empty($item['connent']))
		{
			$item['connent'] = json_decode($item['connent'], true);
		}

		return $item;
	}

	public static function delete_vip_card($uids)
	{
		if (!is_array($uids))
		{
			$uids = array($uids);
		}

		return Dba::write('delete from vip_card_su where uid in (' . implode(',', $uids) . ') ' );

	}

	public static function add_or_edit_vip_card($vip_card)
	{
		Dba::beginTransaction();
		{
			if (!empty($vip_card['uid']))
			{
				Dba::update('vip_card_su', $vip_card, 'uid = ' . $vip_card['uid']);
			}
			else
			{
				$vip_card['create_time'] = $_SERVER['REQUEST_TIME'];
				Dba::insert('vip_card_su', $vip_card);
				$vip_card['uid'] = Dba::insertID();
			}
		}
		Dba::commit();
		Event::handle('AfterEditVipcard', array($vip_card));

		return $vip_card['uid'];
	}

	public static function get_vip_card_list($option)
	{
		$sql = 'select v.su_uid from vip_card_su as v ' .
			'left join service_user as s on s.uid=v.su_uid ' .
			'left join service_user_profile as p on v.su_uid=p.uid';
		if (!empty($option['sp_uid']))
		{
			$where_arr[] = 's.sp_uid=' . $option['sp_uid'];
		}
		if (!empty($option['public_uid']))
		{
			$where_arr[] = 'p.uid=' . $option['public_uid'];
		}
		if (!empty($option['rank']))
		{
			$where_arr[] = 'v.rank=' . $option['rank'];
		}
		if (!empty($option['status']))
		{
			$where_arr[] = 'v.status=' . $option['status'];
		}
		if (!empty($option['key']))
		{
			$where_arr[] = '( v.su_uid like "%' . $option['key'].'%" or '.
							'v.other_info like "%' . $option['key'].'%" or '.
							's.name  like "%' . $option['key'].'%" or '.
							'p.realname  like "%' . $option['key'].'%" '.
							')';
		}
		if (!empty($option['card_ids']))
		{
			$where_arr[] = ' v.uid = '. $option['card_ids'];
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by v.uid desc';
		$option['page']  = isset($option['page']) ? $option['page'] : 0;
		$option['limit'] = isset($option['limit']) ? $option['limit'] : 10;

		#echo $sql;
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'VipcardMod::func_get_vip_card_info');
	}

	public static function func_get_vip_card_info($item)
	{
		$sp_uid          = AccountMod::get_current_service_provider('uid');
		if(empty($GLOBALS['_TMP']['VIP_CARD_SET_'.$sp_uid]))
		{
			$GLOBALS['_TMP']['VIP_CARD_SET_'.$sp_uid] = self::get_vip_card_sp_set_by_sp_uid($sp_uid);
		}
		$vip_card_sp_set = $GLOBALS['_TMP']['VIP_CARD_SET_'.$sp_uid];
//		$vip_card_sp_set =self::get_vip_card_sp_set_by_sp_uid($sp_uid);
		$vip_card_su     = self::get_vip_card_info($item['su_uid'], $sp_uid, $vip_card_sp_set);
		!empty($vip_card_su['vip_card_su']) && $item = $vip_card_su['vip_card_su'];

		return $item;
	}


	public static function get_vip_card_by_uid($uid)
	{
		return Dba::readRowAssoc('select * from vip_card_su where uid =' . $uid, 'VipcardMod::func_get_vip_card');
	}

	public static function get_vip_card_by_su_uid_new($su_uid) {
		$sql = 'select v.su_uid,s.*,p.* from vip_card_su as v ' .
			'left join service_user as s on s.uid=v.su_uid ' .
			'left join service_user_profile as p on v.su_uid=p.uid where v.su_uid = '.$su_uid;
		return Dba::readRowAssoc($sql, 'VipcardMod::func_get_vip_card_info');
	}

	public static function get_vip_card_by_su_uid($su_uid)
	{

		return Dba::readRowAssoc('select * from vip_card_su where su_uid =' . $su_uid, 'VipcardMod::func_get_vip_card');
	}

	public static function func_get_vip_card($item)
	{

		if (!empty($item['other_info']))
		{
			$item['other_info'] = json_decode($item['other_info'], true);
		}

		return $item;
	}


	public static function get_vip_card_sp()
	{
		if ($vip_card_uid = requestInt('vip_card_uid'))
		{
			$vip_card_sp_set = Dba::readRowAssoc('select * from vip_card_sp_set where uid =' . $vip_card_uid, 'VipcardMod::func_get_vip_card_sp_set');
		}
		else
		{
			if ($sp_uid = AccountMod::require_sp_uid())
			{
				$vip_card_sp_set = self::get_vip_card_sp_set_by_sp_uid($sp_uid);
			}
			else
			{
				setLastError(ERROR_INVALID_REQUEST_PARAM);

				return false;
			}
		}
		if ($vip_card_sp_set['status'])
		{
			setLastError(ERROR_BAD_STATUS);

			return false;
		}

		return $vip_card_sp_set;
	}


	/*
	 *  取会员卡信息
	 *  保留字段 列表 可给予用户选择的字段 可定义 前台
	 *  user 对应存储的表名 name 为表中字段
	 *  array('user'=>array('name'=>'微信名', 'avatar'=>'微信头像','gender'=>'性别','birthday'=>'生日'),
		      'user_profile'=>array('realname'=>'真实姓名','email'=>'邮箱','phone'=>'手机','address'=>'地址', 'qq'=>'qq'),
		      'user_point'=>array('point_remain'=>'积分'),
		      'vip_card_su  '=>array('rank'=>'等级','rank_point'=>'等级点数')
		vip_card_su.other_info 存储  自定义字段
	 */
	public static function get_vip_card_info($su_uid, $sp_uid, $vip_card_sp_set = array())
	{
		if(empty($su_uid))
		{
			return false;
		}
		$items['vip_card_su'] = self::get_vip_card_by_su_uid($su_uid);

		if(empty($items['vip_card_su'])){
			return false;//无此会员
		}

		$sql = 'select s.*,p.*,up.point_remain,up.point_max,s.status as su_status,s.uid as su_uid, p.uid as su_uid ,s.create_time as su_create_time' .
			' from service_user as s ' .
			'left join service_user_profile as p on p.uid=s.uid ' .
			'left join user_points as up on up.su_uid=s.uid';
		$sql .= ' where s.uid=' . $su_uid;
		$ret = Dba::readRowAssoc($sql);
		if (isset($ret['passwd']))
		{
			unset($ret['passwd']);
		}
		if ((count($vip_card_sp_set) == 0) && !isset($ret['sp_uid']) || !($vip_card_sp_set = self::get_vip_card_sp_set_by_sp_uid($ret['sp_uid'])))
		{
			return false;
		}
		//取会员等级名称
		if (!empty($vip_card_sp_set['rank_rule']))
		{
			$items['vip_card_su']['rank'] = '';
			$items['vip_card_su']['rank_discount'] = 100;
			$items['vip_card_su']['rank_level'] = 0;
			$rank_level=0;
			foreach ($vip_card_sp_set['rank_rule'] as $rule_point => $rule_data)
			{
//				if(empty($ret['point_max']))
//				{
//					$items['vip_card_su']['rank'] = $rule_data['rank_name'];
//					$items['vip_card_su']['rank_discount'] = 100;
//
//					break;
//				}
				if ($ret['point_max'] >=$rule_point)
				{
					$items['vip_card_su']['rank'] = $rule_data['rank_name'];
					$items['vip_card_su']['rank_discount'] = $rule_data['rank_discount'];

					$items['vip_card_su']['rank_level'] =$rank_level;
					$rank_level++;
				}
			}
		}
		$contect = $vip_card_sp_set['connent'];
		if(empty($contect)) return;
		foreach ($contect as $ck => $cc)
		{
			if ($cc['group'] == 'user_profile')
			{
				if ($ck != 'avatar')
				{
					empty($cc['value']) && $cc['value'] = $ret[$ck];
					$items['vip_card_su']['connent'][] = $cc;
				}
			}
			if ($cc['group'] == 'user')
			{
				empty($cc['value']) && $cc['value'] = $ret[$ck];
				$items['vip_card_su']['connent'][] = $cc;

			}
			if ($cc['group'] == 'user_points')
			{
				empty($cc['value']) && $cc['value'] = $ret[$ck];
				$items['vip_card_su']['connent'][] = $cc;
			}
			if ($cc['group'] == 'vip_card_su')
			{
				if (substr($ck, 0, 6) == 'other_')
				{
					empty($cc['value']) && $cc['value'] = empty($items['vip_card_su']['other_info'][$ck]) ? '' : $items['vip_card_su']['other_info'][$ck];
					$items['vip_card_su']['connent'][] = $cc;
				}
				else
				{
					if ($ck == 'card_id' xor $ck == 'short_card_id')
					{
						empty($cc['value']) && ($ck == 'card_id') &&$cc['value'] = ps_int(array($sp_uid,
						                                                   $su_uid,
						                                                   (empty($items['vip_card_su']['uid']) ? 1 : $items['vip_card_su']['uid']),
						));
						empty($cc['value']) && ($ck == 'short_card_id') &&$cc['value'] = ps_int((empty($items['vip_card_su']['uid']) ? 1 : $items['vip_card_su']['uid']));

					}
					else
					{
						empty($cc['value']) && $cc['value'] = empty($items['vip_card_su'][$ck]) ? '' : $items['vip_card_su'][$ck];
					}
					$items['vip_card_su']['connent'][] = $cc;
				}
			}

		}

		$items['info'] = $ret;

		return $items;
	}


	/*
	 *  编辑会员卡用户信息
	 *  $vip_card_info = array('vip_card_su'=>array(),
	 *                         'user_profile'=>array(),
	 *                         'user'=>array())
	 */
	public static function add_or_edit_vip_card_info($su_uid, $vip_card_info)
	{

		if (!empty($vip_card_info['vip_card_su']))
		{
			foreach ($vip_card_info['vip_card_su'] as $ck => $c)
			{
				if (substr($ck, 0, 6) == 'other_')
				{
					$vip_card_su['other_info'][$ck] = $c;
				}
				else
				{
					$vip_card_su[$ck] = $c;
				}
			}
			$uid = Dba::readOne('select uid from vip_card_su where su_uid =' . $su_uid);
			if (!empty($uid))
			{
				$vip_card_su['uid'] = $uid;
			}
			else
			{
				unset($vip_card_su['uid']);
				$vip_card_su['su_uid'] = $su_uid;
			}

			if (isset($vip_card_su['card_id']))
			{
				unset($vip_card_su['card_id']);
			}
			$ret = self::add_or_edit_vip_card($vip_card_su);
			if (!$ret)
			{
				setLastError(ERROR_DBG_STEP_1);

				return false;
			}

		}
		if (!empty($vip_card_info['user_profile']))
		{
			uct_use_app('su');
			$ret = SuMod::update_su_profile($su_uid, $vip_card_info['user_profile']);
			if (!$ret)
			{
				setLastError(ERROR_DBG_STEP_2);

				return false;
			}
		}
		if (!empty($vip_card_info['user']))
		{
			$vip_card_info['user']['uid'] = $su_uid;
			$ret                          = AccountMod::add_or_edit_service_user($vip_card_info['user']);
			if (!$ret)
			{
				setLastError(ERROR_DBG_STEP_3);

				return false;
			}
		}

		return true;
	}

	// 审核会员卡后
	public static function onAfterCheckSuVipCard($vip_card)
	{
		$vip_card_su = self::get_vip_card_by_uid($vip_card['uid']);
		uct_use_app('su');
		switch ($vip_card_su['status'])
		{
			case 0:
				$title   = '[会员卡]审核通过';
				$connent = '你的会员卡已经通过审核';
				break;
			case 2:
				$title   = '[会员卡]审核不通过';
				$connent = '你的会员卡审核不通过，请重新领取 或联系客服';
				break;
		}
		$msg = array(
			'su_uid'  => $vip_card_su['su_uid'],
			'title'   => $title,
			'content' => $connent,
		);
		SuMsgMod::add_su_msg($msg);

	}



	public static function get_create_vip_card_array($su_uid, $sp_uid)
	{
		$vip_card_set  = self::get_vip_card_sp_set_by_sp_uid($sp_uid);
		$vip_card_info =(empty($su_uid)?array():(self::get_vip_card_info($su_uid, $sp_uid))) ;
		$image         = array();
		$string        = array();
		$i             = 0;
//		var_dump(__file__.' line:'.__line__,$vip_card_info);exit;
		foreach ($vip_card_set['connent'] as $infok => $info)
		{

			if (!empty($info['show']))
			{
				if ($infok == 'avatar')
				{
					$image[$info['show']] = $i;
				}
				else
				{

					$string[$info['show']] = $i;
				}
			}

			$i++;
		}

		uct_use_app('upload');
		$vip_car = $vip_card_set['ui_set'];

//				var_export($vip_car);exit;
		foreach ($vip_car as $vk => $v)
		{
			if ($vk == 'back_ground')
			{
				$vip_car['back_ground']['path'] = UploadMod::get_file_dst_by_url($vip_car['back_ground']['path']);
			}

			if ($vk == 'image')
			{
				$i = 1;
				foreach ($v as $ik => $im)
				{
//					var_dump(__file__.' line:'.__line__,$vip_card_info['vip_card_su']['rank_level']);exit;
					//vipcard 不同等级图片
					if(!empty($vip_car['rank_image_list'])
						&& ($ik=='rank_image')
						&& !empty($vip_card_info['vip_card_su']['rank_level'])
						&& !empty($vip_car['rank_image_list'][$vip_card_info['vip_card_su']['rank_level']]))
					{

						$vip_car[$vk][$ik]['path'] = UploadMod::get_file_dst_by_url($vip_car['rank_image_list'][$vip_card_info['vip_card_su']['rank_level']]);
						$i++;
						continue;
					}
					if (!empty($im['path']))
					{

						$vip_car[$vk][$ik]['path'] = UploadMod::get_file_dst_by_url($im['path']);
					}
					else
					{

						//自定义图片
						if (is_numeric($ik) && isset($image[$i]) && isset($vip_card_info['vip_card_su']['connent'][$image[$i]]['value']))
						{
							$vip_car[$vk][$ik]['path'] = UploadMod::get_file_dst_by_url($vip_card_info['vip_card_su']['connent'][$image[$i]]['value']);
							$i++;
						}
						else
						{
							//背景图片为空时 删除
							unset($vip_car[$vk][$ik]);

						}
					}
				}

			}
			if ($vk == 'string')
			{
				$i = 1;
				foreach ($v as $stk => $st)
				{
					if (empty($st['content']))
					{
						if (is_numeric($stk) && isset($string[$i]) && isset($vip_card_info['vip_card_su']['connent'][$string[$i]]['value']))
						{
							if (!empty($vip_card_info['vip_card_su']['connent'][$string[$i]]['show_title']))
							{
								$vip_car[$vk][$stk]['content'] .= $vip_card_info['vip_card_su']['connent'][$string[$i]]['title'] . ':';
							}
							$vip_car[$vk][$stk]['content'] .= $vip_card_info['vip_card_su']['connent'][$string[$i]]['value'];
							$i++;
						}
						else
						{
							unset($vip_car[$vk][$stk]);
						}

					}

				}

			}
		}
//		var_dump(__file__.' line:'.__line__,$vip_car);exit;
		return $vip_car;
	}


	/*
	 * 检查ui_set 数组结构
	 */
	public static function check_ui_set_array($ui_set)
	{
		foreach ($ui_set as $vk => $v)
		{

			switch ($vk)
			{
				case 'back_ground':
					if (!isset($v['size']) || !is_array($v['size']) || !isset($v['path']) || empty($v['path']))
					{
						return false;
					}

					break;
				case 'image':
					if (!empty($v))
					{
						foreach ($v as $i)
						{
							if (!isset($i['path']) ||
								empty($i['path']) ||
								!(is_array($i['size'])) ||
								!(is_array($i['point']) ||
									!isset($i['l'])
								)
							)
							{
								return false;
							}
						}

					}

					break;
				case 'string':
					if (!empty($v))
					{
						foreach ($v as $s)
						{
							if (!isset($s['content']) ||
								!isset($s['size']) ||
								!(is_array($s['color'])) ||
								!(is_array($s['point'])) ||
								!isset($s['bold'])
							)
							{
								return false;
							}
						}

					}
					break;
			}
		}

		return true;
	}


	//生成会员卡
	/**
	 * @param $vip_card  array()
	 *
	 * @return bool|string  失败返回 false 成功返回图片文件流数据
	 */
	public static function create_vip_card_img($vip_card)
	{

		if (!is_array($vip_card) || !self::check_ui_set_array($vip_card))
		{
			return false;
		}

		include_once UCT_PATH . 'vendor/images/image.php';
		$image = getImageineInstance();
		$ret   = $image->create_vip_card($vip_card);

		return $ret;
	}

	public static function update_vip_card_image($image, $su_uid)
	{
		if(!$image) return "";
		uct_use_app('upload');

		$file_url = Dba::readOne('select card_url from vip_card_su where su_uid=' . $su_uid);
		if (!empty($file_url))
		{
			$muid    = strtr($file_url, array('?_a=upload&_u=index.out&uidm=' => ''));
			$file_id = substr($muid, 0, -4);
			$dst     = UploadMod::get_file_dst_by_url($file_url);
			//保证要删除的文件没有和别人共用
			$same_file_id_count = Dba::readone('select count(*) from files_user_upload_stat where file_id ='.$file_id.' and user_id!='.$su_uid);
			if (file_exists($dst) && $same_file_id_count==0)
			{
				unlink($dst);
				file_put_contents($dst, $image);
				$file['file_size'] = strlen($image);
				$file['md5']       = md5($image);
				$file['uid']       = $file_id;
				$ret               = Dba::update('files', $file, 'uid = ' . $file_id);
				$file              = UploadMod::fill_file_url($file);
				return $file['url'];
			}
		}
		Event::addHandler('AfterUploadOne', array('UploadMod', 'onAfterUploadOne'));
		$ret = UploadMod::upload_vip_imge($image);

		return $ret['url'];


	}

	/*
	 * 补全  content_set 数据结构
	 */
	public static function check_content_set($content_set)
	{
		$connent      = array();
		$need_key_arr = array('need',    //是否必填
		                      'title',  //标题内容
		                      'group',  //
		                      'show_title', //vip卡上是否打印标题 true or false
		                      'show',     //vip卡上是否显示  true or false
		                      'protect',    //填表时不显示 true or false
		                      'placeholder',
		);

		$i = 0;
		foreach ($content_set as $ck => $c)
		{
			if (!isset($c['group']))
			{
				outError(ERROR_INVALID_REQUEST_PARAM);
			}

			if ((substr($ck, 0, 6) == 'other_'))
			{
				$ck = 'other_' . $i;
				$i++;
			}
			else
			{
				$ck = $ck;
			}

			//定义数据结构
			foreach ($need_key_arr as $k)
			{
				$connent[$ck][$k] = empty($c[$k]) ? '' : $c[$k];
			}


		}

		return $connent;
	}


	/*
	 *  通过模板数组数据结构 配置ui_set
	 */
	public static function check_ui_set($tpl_arr, $ui_set)
	{
		//和打印有关的数据 由数据结构过滤
		foreach ($tpl_arr as $tplk => $tpl)
		{
			if (empty($ui_set[$tplk]))
			{
				continue;
			}
			foreach ($tpl as $tpk => $tp)
			{
				if (empty($ui_set[$tplk][$tpk]) )
				{
					continue;
				}
				if ($tplk == 'back_ground')
				{
					$tpl_arr[$tplk][$tpk] = $ui_set[$tplk][$tpk];
				}
				else
				{
					foreach ($tp as $tk => $t)
					{
						if (!empty($ui_set[$tplk][$tpk][$tk]))
						{
							$tpl_arr[$tplk][$tpk][$tk] = $ui_set[$tplk][$tpk][$tk];
						}

					}
				}
			}

		}
		//个性化配置 不同会员卡等级不同图片
		if(!empty($ui_set['rank_image_list']))
		{
			$tpl_arr['rank_image_list'] =$ui_set['rank_image_list'];
		}
		return $tpl_arr;
	}

	/*
	 * 编辑会员卡 模板
	 */
	public static function add_or_edit_vip_card_tpl($vip_card_tpl)
	{
		if (!empty($vip_card_tpl['uid']))
		{
			Dba::update('vip_card_tpl', $vip_card_tpl, 'uid = ' . $vip_card_tpl['uid'] . ' and sp_uid = ' . $vip_card_tpl['sp_uid']);

		}
		else
		{
			$vip_card_sp_set['create_time'] = $_SERVER['REQUEST_TIME'];
			 Dba::insert('vip_card_tpl', $vip_card_tpl);
			$vip_card_tpl['uid']            = Dba::insertID();
		}

		return $vip_card_tpl['uid'];
	}

	public static function get_vip_card_tpl_list($option)
	{
		$sql = 'select * from vip_card_tpl';
		if (!empty($option['status']))
		{
			$where_arr[] = 'status=' . $option['status'];
		}
		if (isset($option['sp_uid']))
		{
			$where_arr[] = ' (sp_uid=' . $option['sp_uid'] . ' or sp_uid =0) ';
		}
		if (!empty($option['original_uid']))
		{
			$where_arr[] = 'original_uid=' . $option['original_uid'];
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by uid desc';
		$option['page']  = isset($option['page']) ? $option['page'] : 0;
		$option['limit'] = isset($option['limit']) ? $option['limit'] : 10;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'VipcardMod::func_get_vip_card_tpl');

	}

	public static function get_vip_card_tpl_by_uid($uid)
	{
		return Dba::readRowAssoc('select * from vip_card_tpl where uid =' . $uid, 'VipcardMod::func_get_vip_card_tpl');
	}

	public static function func_get_vip_card_tpl($item)
	{

		if ($item['data'])
		{
			$item['data'] = json_decode($item['data'], true);
		}

		return $item;
	}


	public static function delete_vip_card_tpl($uids, $sp_uid)
	{
		if (!is_array($uids))
		{
			$uids = array($uids);
		}

		return Dba::write('delete from vip_card_tpl where uid in (' . implode(',', $uids) . ') and sp_uid =' . $sp_uid);

	}


	//设置模板时 检查data 数据结构
	public static function check_vip_card_tpl_data($data)
	{
		foreach ($data as $vk => $v)
		{
			switch ($vk)
			{
				case 'back_ground':
					if (!is_array($v['size']) ||
						!is_numeric($v['size']['0']) ||
						!is_numeric($v['size']['1']) ||
						!isset($v['path'])
					)
					{
						outError(ERROR_INVALID_REQUEST_PARAM);

						return false;
					}
					break;
				case 'image':
					if (!empty($v))
					{
						foreach ($v as $i)
						{
							if (!isset($i['path']) ||
								!(is_array($i['size'])) ||
								!isset($i['size']['0']) ||
								!is_numeric($i['size']['0']) ||
								!isset($i['size']['1']) ||
								!is_numeric($i['size']['1']) ||
								!(is_array($i['point'])) ||
								!isset($i['point']['0']) ||
								!is_numeric($i['point']['0']) ||
								!isset($i['point']['1']) ||
								!is_numeric($i['point']['1']) ||
								!isset($i['l'])
							)
							{
								outError(ERROR_INVALID_REQUEST_PARAM);

								return false;
							}
						}

					}
					break;
				case 'string':
					if (!empty($v))
					{
						foreach ($v as $s)
						{
							if (!isset($s['content']) ||
								!isset($s['size']) ||
								!isset($s['size']['0']) ||
								!is_numeric($s['size']['0']) ||
								!isset($s['size']['1']) ||
								!is_numeric($s['size']['1']) ||
								!(is_array($s['color'])) ||
								!isset($s['color']['0']) ||
								!is_numeric($s['color']['0']) ||
								!isset($s['color']['1']) ||
								!is_numeric($s['color']['1']) ||
								!isset($s['color']['3']) ||
								!is_numeric($s['color']['3']) ||
								!(is_array($s['point'])) ||
								!isset($s['point']['0']) ||
								!is_numeric($s['point']['0']) ||
								!isset($s['point']['1']) ||
								!is_numeric($s['point']['1']) ||
								!isset($s['bold'])
							)
							{
								outError(ERROR_INVALID_REQUEST_PARAM);

								return false;
							}
						}
					}
					break;
			}
		}

	}
	//保留字段
	public static function get_retain_field_arr()
	{
		return array('user'         => array('name'     => '微信名称',
		                                     'avatar'   => '微信头像',
		                                     'gender'   => '性别',
		                                     'birthday' => '生日'),
		             'user_profile' => array('realname' => '真实姓名',
		                                     'email'    => '邮箱',
		                                     'phone'    => '手机',
		                                     'address'  => '地址',
		                                     'qq'       => 'qq'),
		             'user_points'   => array('point_remain' => '积分'),
		             'vip_card_su'  => array('card_id' => '会员卡号',
		                                     'short_card_id'=>'短会员卡号',
		                                     'rank'=>'会员头衔',
		             ),
		);
	}

	//取会员的折扣
	public static function get_rank_discount($su_uid)
	{
		$su = AccountMod::get_service_user_by_uid($su_uid);
		$vip_card_sp_set = self::get_vip_card_sp_set_by_sp_uid($su['sp_uid']);
		if(empty($vip_card_sp_set) || !empty($vip_card_sp_set['status']) || empty($vip_card_sp_set['rank_rule']))
		{
			return 1;//商户木设置会员卡 或 木开启 或 木设置折扣规则
		}
//		var_dump(__file__.' line:'.__line__,$vip_card_sp_set['status']);exit;


		$vip_card_su = self::get_vip_card_by_su_uid($su_uid);
		if(empty($vip_card_su) || !empty($vip_card_su['status']))
		{
			return 1;//用户没领卡 或没过审核
		}
		uct_use_app('su');

		$user_point =   SuPointMod::get_user_points_by_su_uid($su_uid);

		if(empty($user_point) ||empty($user_point['point_max']))
		{
			return 1;//用户没存过积分
		}
		$ret=100;
		foreach ($vip_card_sp_set['rank_rule'] as $rule_point => $rule_data)
		{
			if ($user_point['point_max'] >= $rule_point)
			{
				$ret = $rule_data['rank_discount'];
			}
		}
		return $ret/100;

	}

	//商城确认收货后 增加积分时触发 判断是否更新等级
	public static function onAfterIncrease_User_Point($su_uid)
	{
		$su  = AccountMod::get_service_user_by_uid($su_uid);
		$sp_uid = $su['sp_uid'];
		$vip_card_sp_set = self::get_vip_card_sp_set_by_sp_uid($sp_uid);
		//没配置 或者 关闭 直接返回
		if(empty($vip_card_sp_set)
			|| !(empty($vip_card_sp_set['status']))
			|| (empty($vip_card_sp_set['rank_rule']))
		)
		{
			return ;
		}

		$vip_card_su = self::get_vip_card_by_su_uid($su_uid);
		//无会员卡信息 或者 没通过审核 返回
		if(empty($vip_card_su)
			|| !empty($vip_card_su['status'])
		)
		{
			return ;
		}
		//判断等级变化情况
		$ini_point_max = $GLOBALS['_TMP']['point_max'][0];
		$end_point_max = $GLOBALS['_TMP']['point_max'][1];
		$rank_update = 0;
		foreach ($vip_card_sp_set['rank_rule'] as $rule_point => $rule_data)
		{
			//升级了
			if ($end_point_max>=$rule_point && $ini_point_max <$rule_point)
			{
				$rank_update = 1;
			}
			if( $ini_point_max>=$rule_point)
			{
				$ini_rank_name = $rule_data['rank_name'];
			}
			if( $end_point_max>=$rule_point)
			{
				$end_rank_name = $rule_data['rank_name'];
			}

		}
		//没升级 直接返回
		if(empty($rank_update))
		{
			return ;
		}
		//刷新会员卡
		$args =array($sp_uid,$su_uid);
		Queue::add_job('Vipcard_Refresh_VipcardJob', $args, 'vipcard');
		//站内消息
		uct_use_app('su');
		$msg = array(
			'su_uid'  => $vip_card_su['su_uid'],
			'title'   => '恭喜，你的会员等级提升了',
			'content' => '恭喜你'.(empty($ini_rank_name)?'':'从【'.$ini_rank_name.'】'). '升级到【'.$end_rank_name.'】',
		);
		SuMsgMod::add_su_msg($msg);
		//模板消息 todo

	}
}
