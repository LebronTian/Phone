<?php

class ApiCtl {

	/*
	 * 设置会员卡设置
	 * 参数               必要                  说明
	 * status            否                    是否开启 0 开启 1 关闭
	 * uid               否                    存在时编辑   不存在时添加
	 * rank_rule         否                    等级规则
	 * rank_name         否                    等级名字
	 * connent           否                    会员卡内容 {"name":{"need":1,"value":"","group":"user"},"other_0":{"need":1,"value":"","group":"vip_card_su"}}
	 *                                                   保护字段   必须      默认值     必须有的         自定义字段
	 * ui_set            否                    会员卡ui设置{"back_ground_url":"","logo_url":"","title":"","QC_code_url":""}
	 */

	public function add_or_edit_vip_card_sp_set()
	{
		//		$_REQUEST['connent'] ='{"name":{"need":"0","title":"姓名","value":"","group":"user","show":"1","show_title":"1"},"birthday":{"need":"0","title":"生日","value":"","group":"user","show":"2","show_title":"1"},"email":{"need":"0","title":"邮箱","value":"","group":"user_profile"},"other_0":{"need":"0","title":"行业","value":"","group":"vip_card_su"},"other_1":{"need":"0","title":"爱好","value":"","group":"vip_card_su"},"avatar":{"need":"0","title":"头像","value":"","group":"user"},"card_id":{"need":"0","title":"会员卡","value":"","group":"vip_card_su","show":"3","protect":"1"}}';
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if( !($vip_card_sp_set['uid'] = requestInt('uid'))  ||
			(!($vip_card_sp_sets = VipcardMod::get_vip_card_sp_set_by_uid($vip_card_sp_set['uid'])) ||
				!($vip_card_sp_sets['sp_uid']==$sp_uid)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (isset($_REQUEST['title']) && !($vip_card_sp_set['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['status']) && $vip_card_sp_set['status'] = requestInt('status');
		isset($_REQUEST['tpl']) && $vip_card_sp_set['tpl'] = requestString('tpl');
		isset($_REQUEST['need_check']) && $vip_card_sp_set['need_check'] = requestInt('need_check');
		if (
			(isset($_REQUEST['rank_rule']) && !($vip_card_sp_set['rank_rule'] = requestKvJson('rank_rule'))) ||
			(isset($_REQUEST['ui_set']) && !($vip_card_sp_set['ui_set'] = requestKvJson('ui_set'))) ||
			(isset($_REQUEST['connent']) && !($vip_card_sp_set['connent'] = requestKvJson('connent'))) ||
			(isset($_REQUEST['vip_card_tpl_uid']) && !($vip_card_sp_set['vip_card_tpl_uid'] = requestInt('vip_card_tpl_uid'))) ||
			empty($vip_card_sp_set)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!empty($vip_card_sp_set['rank_rule']))
		{
			foreach ($vip_card_sp_set['rank_rule'] as $rule_point => $rule_data)
			{
				if(empty($rule_data['rank_name'])
					|| empty($rule_data['rank_discount'])
					|| $rule_data['rank_discount']>100
					||$rule_data['rank_discount']<=0
				)
				{
					outError(ERROR_INVALID_REQUEST_PARAM);
				}
			}
		}

		//判断ui_set 数组
		if ((!empty($vip_card_sp_set['ui_set'])) )
		{
			//背景路径是必须的
			if (empty($vip_card_sp_set['ui_set']['back_ground']['path']))
			{
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			else
			{
				$tpl_arr = VipcardMod::get_vip_card_tpl_by_uid($vip_card_sp_sets['vip_card_tpl_uid']);
//				$tpl_arr = json_decode($tpl_arr, true);

				//通过模板数组定义ui_set 结构
				$vip_card_sp_set['ui_set'] = VipcardMod::check_ui_set($tpl_arr['data'], $vip_card_sp_set['ui_set']);
			}
		}
		if(!(empty($vip_card_sp_set['vip_card_tpl_uid'])))
		{
			$tpl_arr = VipcardMod::get_vip_card_tpl_by_uid($vip_card_sp_set['vip_card_tpl_uid']);
			//				$tpl_arr = json_decode($tpl_arr, true);
			//通过模板数组定义ui_set 结构
			$vip_card_sp_set['ui_set'] =$tpl_arr['data'];
		}

		//判断 $vip_card_sp_set['connent'] 结构
		if (!empty($vip_card_sp_set['connent']))
		{
			$content = VipcardMod::check_content_set($vip_card_sp_set['connent']);
			unset($vip_card_sp_set['connent']);
			$vip_card_sp_set['connent'] = $content;
		}
		$vip_card_sp_set['sp_uid']     = $sp_uid;
		$vip_card_sp_set['public_uid'] = WeixinMod::get_current_weixin_public('uid');
//		var_dump(__file__.' line:'.__line__,$vip_card_sp_set);exit;
		outRight(VipcardMod::add_or_edit_vip_card_sp_set($vip_card_sp_set));
	}

	/*
		spv3 修改会员卡设置
	*/
	public function save_card_spv3() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if (!$vip_card_set = VipcardMod::get_vip_card_sp_set_by_sp_uid($sp_uid)) {
			outError(ERROR_DBG_STEP_1);
		}
		unset($vip_card_set['rank_rule']);
		unset($vip_card_set['ui_set']);
		$update = requestKvJson('data');
		$vip_card_set = array_merge_recursive($vip_card_set, $update);
		#var_export($vip_card_set);
		
		outRight(VipcardMod::add_or_edit_vip_card_sp_set($vip_card_set));
	}


	/*
	 * 设置  会员卡 信息
	 * 参数               必须              说明
	 * uid               是                会员卡uid
	 * status            否                审核状态 0 表示通过
	 * rank_point        否                等级点数
	 * rank              否                等级
	 *
	 */

	public function add_or_edit_vip_card_su()
	{
		if (!($sp_uid = AccountMod::get_current_service_provider('uid')) ||
			!($uid = requestInt('uid')) ||
			!($vip_card_su = VipcardMod::get_vip_card_by_uid($uid)) ||
			!($su = AccountMod::get_service_user_by_uid($vip_card_su['su_uid'])) ||
			!($su['sp_uid'] == $sp_uid)
		)
		{
			outError(ERROR_OBJ_NOT_EXIST);
		}
		if (!(isset($_REQUEST['status']))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$vip_card_su['status'] = requestInt('status');
		$vip_card_su['uid'] = $uid;
		outRight(VipcardMod::add_or_edit_vip_card($vip_card_su));

	}


	/*
	 *   审核操作
	 */
	public function do_check_vip_card()
	{
		if (!($sp_uid = AccountMod::get_current_service_provider('uid')) ||
			!($uid = requestInt('uid')) ||
			!($vip_card_su = VipcardMod::get_vip_card_by_uid($uid)) ||
			!($su = AccountMod::get_service_user_by_uid($vip_card_su['su_uid'])) ||
			!($su['sp_uid'] == $sp_uid)

		)
		{
			outError(ERROR_OBJ_NOT_EXIST);
		}

//		if ($vip_card_su['status'] == VipcardMod::STATUS_VIPCARD_SU_PASS)
//		{
//			outError(ERROR_BAD_STATUS);//只有等待 审核的 会员卡才可以操作
//		}

//		$vip_card_su['status'] = (requestInt('status') ? VipcardMod::STATUS_VIPCARD_SU_FAIL : VipcardMod::STATUS_VIPCARD_SU_PASS);
		//只有待审核的才会触发 审核事件
		($vip_card_su['status']==1) && Event::addHandler('AfterEditVipcard', array('VipcardMod', 'onAfterCheckSuVipCard'));

		$vip_card_su['status'] = requestInt('status') ;
		$vip_card_su['uid']    = $uid;
		outRight(VipcardMod::add_or_edit_vip_card($vip_card_su));
	}



	//编辑会员卡等级头衔规则  "0":"普通会员","1000":"白银会员"  0~1000 积分为普通 1000~ 白银
	public function edit_vip_card_rule()
	{
//		$rank_rule = '{"0":"普通会员","1000":"白银会员","10000":"白金会员"}';
		if (!($sp_uid = AccountMod::get_current_service_provider('uid')) ||
			!($public_uid = WeixinMod::get_current_weixin_public('uid')) ||
			!($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
			!($public['sp_uid'] == $sp_uid)
		)
		{
			outError(ERROR_OBJ_NOT_EXIST);
		}
		if (!($rank_rule = requestKvJson('rank_rule')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);

		}
		$count = count($rank_rule);

		for ($i = 0; $i < $count; $i++)
		{
			if (!is_numeric($rank_rule[$i]['0']) || !is_string($rank_rule[$i]['1']))
			{
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			if($i<($count -1) || $rank_rule[$i]['0'] >= $rank_rule[$i + 1]['0'])
			{
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
		}
		if(!($vip_card_sp_set['uid'] = requestInt('uid'))||
			!($vip_card_set = VipcardMod::get_vip_card_sp_set_by_uid($vip_card_sp_set['uid'])) ||
			!($vip_card_set['sp_uid']==$sp_uid))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$vip_card_sp_set['rank_rule'] = $rank_rule;
		outRight(VipcardMod::add_or_edit_vip_card_sp_set($vip_card_sp_set));
	}


	public function get_vip_card_image()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$su_uid = Dba::readOne('select uid from service_user where sp_uid='.$sp_uid.' order by uid');
//		var_dump(__file__.' line:'.__line__,$su_uid);exit;
		$vip_card = VipcardMod::get_create_vip_card_array($su_uid,$sp_uid);

		if(!empty($vip_card['image']))
		{
			foreach($vip_card['image'] as $k=>$v)
			{
				if(isset($v['path']))
				{
					$vip_card['image'][$k]['path'] =  (!empty($v['path']) && !is_numeric($k))?$v['path']:(UCT_PATH.'/app/vipcard/static/images/heard.png');
				}

			}
		}
//		var_dump(__file__.' line:'.__line__,$vip_card);exit;
		$vip_card_data_md5 = md5(json_encode($vip_card));
		if(isset($_SERVER['HTTP_IF_MODIFIED_SINCE']) && $_SERVER['HTTP_IF_MODIFIED_SINCE']==$vip_card_data_md5)
		{
			header('Cache-Control: public');
			header('Last-Modified:' . $vip_card_data_md5, true, 304);
		}

		$vip_card_imge = VipcardMod::create_vip_card_img($vip_card);
		header('Cache-Control: public');
		header('Last-Modified: ' . $vip_card_data_md5);
		header('Content-Type:image/png');
		echo $vip_card_imge;
		//		echo VipcardMod::update_vip_card_image($vip_card_imge,$su_uid);
	}

	public function get_vip_card_tpl_image()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($uid = requestInt('uid'))
			|| !($vip_card_tpls = VipcardMod::get_vip_card_tpl_by_uid($uid))
			|| !($vip_card = $vip_card_tpls['data']
			)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$vip_card_data_md5 = md5(json_encode($vip_card));
//		var_dump(__file__.' line:'.__line__,$_SERVER['HTTP_IF_MODIFIED_SINCE']);exit;
		if(isset($_SERVER['HTTP_IF_MODIFIED_SINCE']) && $_SERVER['HTTP_IF_MODIFIED_SINCE']==$vip_card_data_md5)
		{
			header('Cache-Control: public');
			header('Last-Modified:' . $vip_card_data_md5, true, 304);
		}
		$vip_card['back_ground']['path'] =  UCT_PATH.'/app/vipcard/static/images/back_group.png';
		if(!empty($vip_card['image']))
		{
			foreach($vip_card['image'] as $k=>$v)
			{
				if(isset($v['path']))
				{
					$vip_card['image'][$k]['path'] =  UCT_PATH.'/app/vipcard/static/images/heard.png';
				}

			}
		}
		if(!empty($vip_card['string']))
		{
			foreach($vip_card['string'] as $k=>$v)
			{
				if(isset($v['content']))
				{
					$vip_card['string'][$k]['content'] = '示例字段'.($k+1) ;
				}

			}
		}
//		var_dump(__file__.' line:'.__line__,$vip_card);
		$vip_card_imge = VipcardMod::create_vip_card_img($vip_card);
		header('Cache-Control: public');
		header('Last-Modified: ' . $vip_card_data_md5);
		header('Content-Type:image/png');
		echo $vip_card_imge;
	}

	public function delete_vip_card()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($uids = requestStringArray('uids',PATTERN_WORKER_ID)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!is_array($uids))
		{
			$uids = array($uids);
		}
		$sql = 'select uid from vip_card_su where su_uid in (select uid from service_user where sp_uid ='.$sp_uid.') and uid in ('. implode(',', $uids) .')';
		$uids = Dba::readallone($sql);
		outRight(VipcardMod::delete_vip_card($uids));
	}


	public function edittpl()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($uid = requestInt('uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$vip_card_tpls = VipcardMod::get_vip_card_tpl_by_uid($uid);
		$tpl_data = requestKvJson('data');
		if($vip_card_tpls['sp_uid']== 0 ){
			$vip_card_tpl['original_uid'] = $uid;
		}
		else
		{
			$vip_card_tpl['uid'] = $uid;
		}
		$vip_card_tpl['status'] = 1;
		$vip_card_tpl['sp_uid'] = $sp_uid;
		$vip_card_tpl['data'] =$tpl_data;
//		var_dump(__file__.' line:'.__line__,$vip_card_tpl);exit;
		outRight(VipcardMod::add_or_edit_vip_card_tpl($vip_card_tpl));
	}

	public function delete_vipcard_tpl()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($uid = requestInt('uid'))
			|| !($vip_card_tpls = VipcardMod::get_vip_card_tpl_by_uid($uid))
			|| !($sp_uid == $vip_card_tpls['sp_uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		;
		outRight(VipcardMod::delete_vip_card_tpl($uid,$sp_uid));

	}


	public function refresh_vip_card_image()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($uids = requestStringArray('uids',PATTERN_WORKER_ID))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
//		$vip_card = VipcardMod::get_create_vip_card_array($su_uid,$sp_uid);
//		$vip_card_imge = VipcardMod::create_vip_card_img($vip_card);
//		$vip_card_su['card_url'] = VipcardMod::update_vip_card_image($vip_card_imge,$su_uid);
//		outRight(VipcardMod::add_or_edit_vip_card( $vip_card_su));
		$sql = 'select uid from service_user where sp_uid = '.$sp_uid.' and uid in  ('. implode(',', $uids) .')';
		$su_uids = Dba::readAllOne($sql);
		if(empty($su_uids))
		{
			outError(ERROR_INVALID_REQUEST_PARAM,'数据错误');
		}
		is_array($su_uids) || $su_uids = array($su_uids);
		foreach($su_uids as $su_uid)
		{
			$args =array($sp_uid,$su_uid);
			Queue::add_job('Vipcard_Refresh_VipcardJob', $args, 'vipcard');
		}
		outRight(1);
	}


	public function get_tpls() {
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['type'] = requestString('type');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		outRight(SptplMod::get_tpls_list($option));
	}

	//直接申请会员
	public function add_vip_card()
	{
		if (!($vip_card['su_uid'] = requestInt('su_uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$check = VipcardMod::get_vip_card_by_su_uid($vip_card['su_uid']);
		$point_max = requestInt('point_max');

		Dba::write( 'update user_points set point_max = 0  where su_uid =' .$vip_card['su_uid']);

		uct_use_app('su');
		$record = array(
			'su_uid' =>$vip_card['su_uid'],
			'point_max' =>$point_max
		);
		$po = SuPointMod::increase_user_point_max($record);

		if(!empty($check)){
			outRight($po);//已申请过
		}

		//还没成为会员
		$vip_card['status'] = 0;
		$ret = VipcardMod::add_or_edit_vip_card($vip_card);

		outRight($ret);
	}


//升级 vipcard rank_rule数据结果 2015年12月17日17:38:25
//	public function test()
//	{
//		$vip_card_sp_sets  = Dba::readAllAssoc('select uid,rank_rule from vip_card_sp_set');
//		foreach($vip_card_sp_sets as $r)
//		{
//			if(!empty($r['rank_rule'])
//				&&($r['rank_rule'] = json_decode($r['rank_rule'],true))
//			)
//			{
//				$ret = array();
//
//				foreach($r['rank_rule'] as $rk=>$rs)
//				{
////					var_dump(__file__.' line:'.__line__,$rs);
//					$ret[$rk] =(!is_array($rs)?(array('rank_name'=>$rs,'rank_discount'=>100)):($rs));
//				}
//
//				var_dump(Dba::update('vip_card_sp_set',array('rank_rule'=>$ret),'uid='.$r['uid'])) ;
//			}
//			else
//			{
//				$ret = '{"0":"普通会员","1000":"白银会员","10000":"白金会员"}';
////				$ret = '{"1":{"rank_name":"普通会员","rank_discount":"100"},"2":{"rank_name":"白银会员","rank_discount":"90"},"3":{"rank_name":"黄金会员","rank_discount":"80"}}';
//				$ret = json_decode($ret,true);
//				var_dump(Dba::update('vip_card_sp_set',array('rank_rule'=>$ret),'uid='.$r['uid'])) ;
//
//			}
//		}
//
//
//	}
}

