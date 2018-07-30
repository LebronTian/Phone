<?php

class ApiCtl {
	/*
		添加或编辑回复规则
	*/
	public function addkeyword() {
		if(isset($_REQUEST['keyword']) && !($k['keyword'] = requestString('keyword', PATTERN_SEARCH_KEY))) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}
		if(($media_uid = requestInt('media_uid')) && (
			!($k['data'] =  WeixinMediaMod::get_weixin_media_by_uid($media_uid)) || 
			($k['data']['sp_uid'] != AccountMod::get_current_service_provider('uid')))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
		}
		if(empty($k)) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}

		isset($_REQUEST['uid']) && $k['uid'] = requestInt('uid');

		outRight(Keywords_WxPlugMod::add_or_edit_public_keywords($k));
	}

	/*
		删除关键词回复
	*/
	public function delkeyword() {
		if(!($uids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(Keywords_WxPlugMod::delete_keywords($uids));
	}

}

