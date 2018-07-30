<?php

class IndexCtl {
	protected function render($params = array()) {
		$GLOBALS['_UCT']['TPL'] = 'v1';	
		render_fg('', $params);
	}

	public function index() {
		$sp_uid = AccountMod::require_sp_uid();
		
		$all_type = BookItemMod::get_book_item_type($sp_uid);
		$option = array();
		$option['type'] = requestString('type', PATTERN_SEARCH_KEY);
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		
		$slides = SlidesMod::get_slides(array('sp_uid' => $sp_uid, 'pos' => 'book1'));
		$slides2 = SlidesMod::get_slides(array('sp_uid' => $sp_uid, 'pos' => 'book2'));
		$this->render(array('all_type' => $all_type, 'option' => $option, 'slides' => $slides, 'slides2' => $slides2));	
	}

	/*
		预约订单
	*/
	public function point_orders() {
		uct_use_app('su');
		$su_uid = SuMod::require_su_uid();

		$option['status'] = requestInt('status');
	
		$this->render(array('option' => $option));	
	}

	/*
		活动记录
	*/
	public function activity_list() {
		#uct_use_app('su');
		#$su_uid = SuMod::require_su_uid();

		$option['status'] = requestInt('status');
	
		$this->render(array('option' => $option));	
	}

	/*
		门店列表
	*/
	public function store_list() {
		#uct_use_app('su');
		#$su_uid = SuMod::require_su_uid();

		$option['status'] = requestInt('status');
	
		$this->render(array('option' => $option));	
	}

	/*
		个人中心
	*/
	public function user() {
		uct_use_app('su');
		$su_uid = SuMod::require_su_uid();

		$su = AccountMod::get_current_service_user();
		$point = SuPointMod::get_user_points_by_su_uid($su_uid);

		$this->render(array('su' => $su, 'point' => $point));	
	}

}

