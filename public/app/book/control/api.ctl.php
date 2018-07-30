<?php

class ApiCtl {
	public function book_item_list() {
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['key']       = requestString('key', PATTERN_SEARCH_KEY);
		$option['type']      = requestString('type', PATTERN_SEARCH_KEY);
		$option['page']      = requestInt('page');
		$option['limit']     = requestInt('limit', 10);
		$option['status']    = 0;

		outRight(BookItemMod::get_book_item_list($option));
	}

	/*
		添加编辑项目
	*/
	public function additem() {
		if(isset($_REQUEST['title']) && !($item['title'] = requestStringLen('title', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);	}
		isset($_REQUEST['type']) && $item['type'] = requestStringLen('type', 64);

		isset($_REQUEST['main_img']) && $item['main_img'] = requestString('main_img', PATTERN_URL);
		isset($_REQUEST['images']) && $item['images'] = implode(';', requestStringArray('images', PATTERN_URL, ';'));
		isset($_REQUEST['brief']) && $item['brief'] = requestString('brief');
		isset($_REQUEST['sort']) && $item['sort'] = requestInt('sort');
		isset($_REQUEST['store_uid']) && $item['store_uid'] = requestInt('store_uid');
		isset($_REQUEST['price']) && $item['price'] = requestInt('price');
		isset($_REQUEST['status']) && $item['status'] = requestInt('status');

		if(empty($item)) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}
		isset($_REQUEST['uid']) && $item['uid'] = requestInt('uid');
		$item['sp_uid'] = AccountMod::get_current_service_provider('uid');

		outRight(BookItemMod::add_or_edit_book_item($item));
	}

	/*
		删除商品
	*/
	public function delitem() {
		if(!($uids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(BookItemMod::delete_book_item($uids, AccountMod::get_current_service_provider('uid')));
	}

	/*
		删除记录
	*/
	public function delrecord() {
		if(!($uids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$b_uid = requestInt('b_uid');

		outRight(BookRecordMod::delete_book_record($uids, $b_uid));
	}

	/*
		做颜色标记
	*/
	public function markrecord()
	{
		isset($_REQUEST['uids']) && $uids = requestStringArray('uids');
		isset($_REQUEST['sp_remark']) && $sp_remark= requestInt('sp_remark');
		isset($_REQUEST['b_uid']) && $b_uid = requestInt('b_uid');
		if(empty($uids)||empty($sp_remark)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(BookRecordMod::remark_book_record($uids, $sp_remark ,$b_uid));

	}

}

