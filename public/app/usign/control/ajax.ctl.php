<?php

class AjaxCtl {
	public function init_usign()
	{
		if (!($usign_set = UsignMod::get_usign_set_sp()))
		{
			if (getLastError() == ERROR_BAD_STATUS)
			{
				echo '该签到已经下线!';
			}
			else
			{
				echo '签到内部错误! ' . getErrorString();
			}
			exit();
		}

		return $usign_set;
	}

	public function sign()
	{
		$usign_set=$this->init_usign();
		if(!$su_uid = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		$sp_uid = AccountMod::require_sp_uid();
		outRight(UsignMod::just_sign($su_uid, $sp_uid));
	}

	/*
		获取用户积分明细列表
	*/
	public function sign_list() {
		if(!($option['su_uid'] = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		outRight(UsignMod::get_usign_record_list($option));
	}

}
