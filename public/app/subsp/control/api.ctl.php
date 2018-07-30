<?php

class ApiCtl {
	public function add_subsp() {
		$subsp = array();
		isset($_REQUEST['name']) && $subsp['name'] = requestString('name', PATTERN_USER_NAME);
		isset($_REQUEST['account']) && $subsp['account'] = requestString('account', PATTERN_ACCOUNT);
		isset($_REQUEST['passwd']) && $subsp['passwd'] = requestString('passwd', PATTERN_PASSWD);
		isset($_REQUEST['uct_tokens']) && $subsp['uct_tokens'] = requestStringArray('uct_tokens', PATTERN_TOKEN);
		isset($_REQUEST['access_rule']) && $subsp['access_rule'] = requestKvJson('access_rule');
		isset($_REQUEST['store_uids']) && $subsp['store_uids'] = requestIntArray('store_uids');
		if (!count($subsp)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		isset($_REQUEST['uid']) && $subsp['uid'] = requestInt('uid');
		if(empty($subsp['uid'])) {
			if(empty($subsp['account']) || empty($subsp['passwd'])) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
		}

		$subsp['sp_uid'] = AccountMod::get_current_service_provider('uid');	
		outRight(SubspMod::add_or_edit_subsp($subsp));
	}

	public function del_subsp() {
		if(!$uid = requestInt('uid')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$sp_uid = AccountMod::get_current_service_provider('uid');

		outRight(SubspMod::delete_subsp($uid, $sp_uid));
	}

	/*
		后台菜单列表, 用于选择子账号权限
	*/
	public function sp_menus() {
		outRight(SubspMod::get_all_sp_menu_array_of_sp_uid());
	}

	/*
		取所有公众号列表, 用于选择子账号可管理的公众号
	*/
	public function all_publics() {
		outRight(WeixinMod::get_all_weixin_public_by_sp_uid(0, false));
	}

}

