<?php

class AjaxCtl {
	public function book_item_list() {
		$option['sp_uid'] = AccountMod::require_sp_uid();
		$option['key']       = requestString('key', PATTERN_SEARCH_KEY);
		$option['type']      = requestString('type', PATTERN_SEARCH_KEY);
		$option['page']      = requestInt('page');
		$option['limit']     = requestInt('limit', 10);
		$option['status']    = 0;

		outRight(BookItemMod::get_book_item_list($option));
	}

	public function add_book_item_record() {
		if(!$r['su_uid'] = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if(!$r['b_uid'] = requestInt('b_uid')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['data']) && $r['data'] = requestKvJson('data');
		$r['user_ip'] = requestClientIP();
		
		//$r['sp_uid'] = AccountMod::require_sp_uid();
        //Event::addHandler('AfterMakePointProductOrder',array('PointmallMod', 'onAfterMakePointProductOrder'));
		outRight(BookRecordMod::add_or_edit_book_record($r));
	}
	
	//预约列表
	public function book_record_list() {
		if(!$option['su_uid'] = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		$option['sp_uid'] = AccountMod::require_sp_uid();
		$option['key']       = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']      = requestInt('page');
		$option['limit']     = requestInt('limit', 10);
		$option['status']    = requestInt('status', -1);

		outRight(BookRecordMod::get_book_record_list($option));
	}

	public function store_list() {
		$option['sp_uid'] = AccountMod::require_sp_uid();
		$option['key']       = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']      = requestInt('page');
		$option['limit']     = requestInt('limit', 10);
		$option['status']    = 0;

		uct_use_app('store');
		outRight(StoreMod::get_store_list($option));
	}

	/*
		活动列表
	*/
	public function activity_list() {
		$option = array('sp_uid' => AccountMod::get_current_service_provider('uid'), 'pos' => 'activity1');
		$slides = SlidesMod::get_slides($option);
		if(!$slides) $slides = array();

		//简单一点不分页
		if(requestInt('page')) $slides = array();

		$ret = array('count' => count($slides), 'list' => $slides);
		outRight($ret);
	}

	/*
		删除记录
	*/
	public function delete_record() {
		if(!$su_uid = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		
		if(!($uid = requestInt('uid')) ||
		   !($r = BookrecordMod::get_book_record_by_uid($uid)) ||
		   $r['su_uid'] != $su_uid) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$b_uid = $r['b_uid'];

		outRight(BookRecordMod::delete_book_record($uid, $b_uid));
	}

}

