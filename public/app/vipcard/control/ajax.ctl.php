<?php

/*
	前端页面接口

	没有自动检查登陆权限, 需要自己检查
	AccountMod::has_su_login()
*/


class AjaxCtl {
	public function init_vip_card()
	{
		if (!($vip_card_sp_set = VipcardMod::get_vip_card_sp()))
		{
			if (getLastError() == ERROR_BAD_STATUS)
			{
				echo '该会员卡已经下线!';
			}
			else
			{
				echo '会员卡内部错误! ' . getErrorString();
			}
			exit();
		}

		return $vip_card_sp_set;
	}

	//编辑会员卡信息  领卡操作或编辑操作
	public function edit_vip_card()
	{
		$vip_card_sp_set = $this->init_vip_card();
		$sp_uid = $vip_card_sp_set['sp_uid'];

		if (!($vip_card_info = requestKvJson('vip_card_info')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($su_uid = AccountMod::has_su_login())
			&& !( (defined('DEBUG_WXPAY') && DEBUG_WXPAY && $su_uid =1))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!empty($vip_card_sp_set['connent']))
		{
			foreach ($vip_card_sp_set['connent'] as $ck => $v)
			{

				if ((empty($vip_card_info[$v['group']][$ck]) && $v['need'])
//					!checkString($vip_card_info[$v['group']][$ck],)
				)
				{
					outError(ERROR_INVALID_REQUEST_PARAM);
				}
				if(isset($v['protect']) &&$v['protect'] )
				{
					unset($vip_card_info[$v['group']][$ck]);
				}

			}
		}
		//更新 审核状态
		$vip_card_info['vip_card_su']['status'] = ($vip_card_sp_set['need_check']?(VipcardMod::STATUS_VIPCARD_SU_WAIT):(VipcardMod::STATUS_VIPCARD_SU_PASS));
		$ret = VipcardMod::add_or_edit_vip_card_info($su_uid, $vip_card_info);
		if(!$ret)
		{
			outRight($ret);
		}
		$vip_card = VipcardMod::get_create_vip_card_array($su_uid,$sp_uid);
		$vip_card_imge = VipcardMod::create_vip_card_img($vip_card);
		$vip_card_su =array('su_uid'=>$su_uid,'card_url'=>VipcardMod::update_vip_card_image($vip_card_imge,$su_uid));
		#var_export($vip_card_su);
		if(!$vip_card_su['card_url']) unset($vip_card_su['card_url']);
		$ret = Dba::update('vip_card_su', $vip_card_su, 'su_uid = ' . $vip_card_su['su_uid']);
		outRight(true);
	}

	//请用这个，不用check_vip
	public function is_vip() {
		if (!($su_uid = AccountMod::has_su_login())) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		$su = VipcardMod::get_vip_card_by_su_uid_new($su_uid);
		$set = $this->init_vip_card();
		$ret['su'] = $su;
		$ret['set'] = $set;
		if(empty($su['card_url']) && !empty($set['ui_set']['back_ground']['path'])) {
			$ret['su']['card_url'] = $set['ui_set']['back_ground']['path'];
		}

		outRight($ret);
	}

	//检查是否会员 status 0 通过 1审核中
	public function check_vip()
	{
		$set = $this->init_vip_card();
//		$sp_uid = $vip_card_sp_set['sp_uid'];

		if (!($su_uid = AccountMod::has_su_login())) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$ret = VipcardMod::get_vip_card_by_su_uid($su_uid);

		$ret['set'] = $set;

		outRight($ret);
	}

	//直接申请会员
	public function add_vip_card()
	{
		$vip_card_sp_set = $this->init_vip_card();

		if (!($vip_card['su_uid'] = AccountMod::has_su_login())) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$check = VipcardMod::get_vip_card_by_su_uid($vip_card['su_uid']);

		if(!empty($check['uid'])){
			//outRight($check['uid']);//已申请过
			$vip_card['uid'] = $check['uid'];
		}else{
			$vip_card['status'] = $vip_card_sp_set['need_check']?$vip_card_sp_set['need_check']:0;
		}

		$ret = VipcardMod::add_or_edit_vip_card($vip_card);

		outRight($ret);
	}




	}

