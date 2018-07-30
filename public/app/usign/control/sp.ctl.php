<?php

class SpCtl {

	public function get_menu_array()
	{
		return array(
			array('name'      => '每日签到',
			      'icon'      => 'am-icon-home',
			      'link'      => '?_a=usign&_u=sp.usign_set',
			      'activeurl' => 'sp.usign_set'),
			array('name'      => '签到记录',
			      'icon'      => 'am-icon-gear',
			      'link'      => '?_a=usign&_u=sp.usign_record',
			      'activeurl' => 'sp.usign_record'),
		);
	}

	protected function sp_render($params = array())
	{
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	protected function init_sp_usign()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$usign_set = UsignMod::get_usign_set_by_sp_uid($sp_uid);
		return $usign_set;
	}

	public function index()
	{
		redirectTo('?_a=usign&_u=sp.usign_set');
		$usign_set = $this->init_sp_usign();
		$params =array('usign_set'=>$usign_set);
		$this->sp_render($params);
	}

	public function usign_set()
	{
		$usign_set = $this->init_sp_usign();
		$params =array('usign_set'=>$usign_set);
		$this->sp_render($params);

	}

	public function usign_record()
	{
		$usign_set = $this->init_sp_usign();
		$sp_uid = $usign_set['sp_uid'];
		$option['sp_uid'] = $sp_uid;
		$option['page'] = requestInt('page',0);
		$option['limit'] = requestInt('limit',10);
		$option['su_uid'] = requestInt('su_uid');
		$option['key'] = requestString('key');
		$usign_record = UsignMod::get_usign_record_list($option);
		$pagination    = uct_pagination($option['page'], ceil($usign_record['count'] / $option['limit']),
			'?_a=' . $GLOBALS['_UCT']['APP'] .
			'&_u=' . $GLOBALS['_UCT']['CTL'] . '.' . $GLOBALS['_UCT']['ACT'] .
			'&limit=' . $option['limit'] .
			'&key=' . $option['key'] .
			'&page=');
		$params =array(
			'usign_set'=>$usign_set,
			'usign_record'=>$usign_record,
			'option'        => $option,
			'pagination'    => $pagination
		);
		$this->sp_render($params);
	}
}
