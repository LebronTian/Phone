<?php

class ApiCtl {
	public function adddomain()
	{
		isset($_REQUEST['bind']) && $db['bind'] = requestString('bind', PATTERN_NORMAL_STRING);
		if (isset($_REQUEST['domain']) && !($db['domain'] = requestString('domain', PATTERN_DOMAIN_NAME)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (empty($db))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		if (isset($_REQUEST['uid']) && !($db['uid'] = requestInt('uid')))
		{
			unset($db['uid']);
		}
		$db['sp_uid'] = AccountMod::get_current_service_provider('uid');
		
		outRight(DomainMod::add_or_edit_domain($db));
	}
	
	
	public function deletedomain()
	{

		$sp_uid = AccountMod::get_current_service_provider('uid');
		
		if (!($rids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		outRight(DomainMod::delete_domain($rids, $sp_uid));
	}
}