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
			array('name' => '子账号列表', 'icon' => 'am-icon-user', 'link' => '?_a=subsp&_u=sp.index', 'activeurl' => 'sp.index'),
		);
	}

	protected function sp_render($params = array()) {
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index() {
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$data = SubspMod::get_subsp_list($option);
		$cnt = $data ? count($data) : 0;
		
		$params = array('option' => $option, 'cnt' => $cnt, 'data' => $data);
		$this->sp_render($params);
	}

	public function addsubsp() {
		$params = array();
		if(($uid = requestInt('uid')) && ($subsp = SubspMod::get_subsp_by_uid($uid)) &&
			$subsp['sp_uid'] == AccountMod::get_current_service_provider('uid')) {
		} else if(($copy_uid = requestInt('copy_uid')) && ($subsp = SubspMod::get_subsp_by_uid($copy_uid)) &&
			$subsp['sp_uid'] == AccountMod::get_current_service_provider('uid')) {
			unset($subsp['uid']);
			unset($subsp['account']);
			unset($subsp['passwd']);
			unset($subsp['name']);
		} else {
			$subsp = array();
		}
		
		if(($params['tpl_uid'] = requestInt('tpl_uid')) && ($tpl = SubspTplMod::get_system_tpl($params['tpl_uid']))) {
			$subsp['access_rule'] = json_decode($tpl['access_rule'], true);	
			$subsp['name'] = $tpl['name'];
		}

		$params['subsp'] = $subsp;

		//菜单
		$params['menus'] = SubspMod::get_all_sp_menu_array_of_sp_uid();
		
		//门店
		uct_use_app('store');
		$option = array('sp_uid' => AccountMod::get_current_service_provider('uid'), 'page' => 0, 'limit' => -1);
		$stores = StoreMod::get_store_list($option);
		$stores = $stores['list'];

		$params['stores'] = $stores;
		$this->sp_render($params);
	}

}
