<?php

class SpCtl {

	public function get_menu_array()
	{
		$app = $GLOBALS['_UCT']['APP'];
		return array(
			array('name'      => '首页',
			      'icon'      => 'am-icon-home',
			      'link'      => '?_a=' . $app . '&_u=sp',
			      'activeurl' => 'sp.index'),
			array('name'      => '签到设置',
			      'icon'      => 'am-icon-gear',
			      'link'      => '?_a=' . $app . '&_u=sp.usign_set',
			      'activeurl' => 'sp.usign_set'),
			array('name'      => '签到设置',
			      'icon'      => 'am-icon-gear',
			      'link'      => '?_a=' . $app . '&_u=sp.usign_record',
			      'activeurl' => 'sp.usign_record'),
		);
	}

	protected function sp_render($params = array())
	{
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index()
	{
		$params =array();
		$this->sp_render($params);
	}

	public function usign_set()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$usign_set = UsignMod::get_usign_set_by_sp_uid($sp_uid);
		$params =array('usign_set'=>$usign_set);
		$this->sp_render($params);

	}

	public function usign_record()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$option['sp_uid'] = $sp_uid;
		$option['page'] = requestInt('page',0);
		$option['limit'] = requestInt('limit',0);
		$option['su_uid'] = requestInt('su_uid');
		$usign_record = UsignMod::get_usign_record_list($option);
		$params =array('usign_record'=>$usign_record);
		$this->sp_render($params);
	}
}
