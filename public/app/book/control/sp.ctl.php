<?php

class SpCtl {
	/*
		获取左侧菜单项
	*/
	public function get_menu_array() {
		/*
			activeurl 确定是否为选中状态
		*/
		return array(
			array('name' => '首页', 'icon' => 'am-icon-home', 'link' => '?_a=book&_u=sp', 'activeurl' => 'sp.index'),
			array('name' => '项目列表', 'icon' => 'am-icon-cubes', 'link' => '?_a=book&_u=sp.itemlist', 'activeurl' => 'sp.itemlist'),
			array('name' => '预约记录', 'icon' => 'am-icon-history', 'link' => '?_a=book&_u=sp.recordlist', 'activeurl' => 'sp.recordlist'),
			array('name' => '门店列表', 'icon' => 'am-icon-home', 'link' => '?_a=store&_u=sp.storelist', 'activeurl' => 'sp.storelist'),
			array('name' => '系统设置', 'icon' => 'am-icon-gear', 'link' => '?_a=book&_u=sp.cfg', 'activeurl' => 'sp.cfg'),
		);
	}

	protected function sp_render($params = array()) {
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index() {
		$params = array();
		$this->sp_render($params);
	}

	public function itemlist() {
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['store_uid'] = requestInt('store_uid');

		$data = BookItemMod::get_book_item_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=book&_u=sp.itemlist&store_uid='.$option['store_uid'].'&key='.$option['key'].
						'&limit='.$option['limit'].'&page=');
		
		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	public function additem() {
		$b_uid = requestInt('uid');
		$item = array();
		if($b_uid) {
			$item = BookItemMod::get_book_item_by_uid($b_uid);
			if(!$item || ($item['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
				$item = array();
			}
		}

		$option2 = array('sp_uid' => AccountMod::get_current_service_provider('uid'), 'status' => 0, 'page' => 0, 'limit' => -1);
		uct_use_app('store');
		$stores = StoreMod::get_store_list($option2);
		$params = array('item' => $item, 'stores' => $stores);
		$this->sp_render($params);
	}

	public function recordlist() {
		$option['b_uid'] = requestInt('b_uid');
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		//todo b_uid
		$option['su_uid'] = requestInt('su_uid');
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['sp_remark'] = requestInt('sp_remark');

		$data = BookRecordMod::get_book_record_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=book&_u=sp.recordlist&b_uid='.$option['b_uid'].'&su_uid='.$option['su_uid'].
						'&key='.$option['key'].'&limit='.$option['limit'].'&page=');
		
		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	//系统设置
	public function cfg() {
		$cfg = Book_WxPlugMod::get_book_cfg();
		$params = array('cfg' => $cfg);
		$this->sp_render($params);
	}
}
