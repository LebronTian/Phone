<?php

class ApiCtl {
	//编辑签到设置
	public function edit_usign_set()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($usign_set['uid'] = requestInt('uid'))
			|| !($usign_set = UsignMod::get_usign_set_by_uid($usign_set['uid']))
			|| !($usign_set['sp_uid'] == $sp_uid)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM,'参数错误');
		}
		isset($_REQUEST['status']) && 	$usign_set['status'] = requestInt('status');
		isset($_REQUEST['rule_data']) && 	$usign_set['rule_data'] = requestKvJson('rule_data');
		isset($_REQUEST['tpl']) && 	$usign_set['tpl'] = requestKvJson('tpl');
		outRight(UsignMod::edit_usign_set($usign_set));
	}
	public function get_tpls() {
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['type'] = requestString('type');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		outRight(SptplMod::get_tpls_list($option));
	}
}
