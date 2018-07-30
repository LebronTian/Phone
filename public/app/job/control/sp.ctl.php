<?php

class SpCtl {
	/*
	获取左侧菜单项
*/
	public function get_menu_array()
	{
		/*
			activeurl 确定是否为选中状态
		*/


		return array(
			array('name' => '我的任务', 'icon' => 'am-icon-weixin', 'link' => '?_a=job&_u=sp', 'activeurl' => 'sp.index'),
			//			array('name' => '测评管理', 'icon' => 'am-icon-weixin', 'menus' => array(
			//				array('name' => '测评基础设置', 'icon' => 'am-icon-th-large', 'link' => '?_a=old&_u=sp.testset', 'activeurl' => 'sp.testset'),
			//				array('name' => '测评题目设置', 'icon' => 'am-icon-th-large', 'link' => '?_a=old&_u=sp.test', 'activeurl' => 'sp.test'),
			//				array('name' => '测评记录', 'icon' => 'am-icon-th-large', 'link' => '?_a=old&_u=sp.testresult', 'activeurl' => 'sp.testresult'),
			//			),
			//			),

		);

	}

	protected function sp_render($params = array())
	{
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}


	public function index()
	{
		$GLOBALS['_UCT']['ACT'] = 'job';
		$this->job();
	}

	public function job()
	{
		$option['sp_uid'] =  AccountMod::get_current_service_provider('uid');
		$option['page']  = requestInt('page',0);
		$option['limit']  = requestInt('limit',10);
		$option['dir'] = ($GLOBALS[ '_UCT' ][ 'APP' ]=='job')?'':$GLOBALS[ '_UCT' ][ 'APP' ];
		$job = JobMod::get_job_list($option);
		$pagination = uct_pagination($option[ 'page' ],
			ceil($job[ 'count' ] / $option[ 'limit' ]),
			'?_a='. $GLOBALS[ '_UCT' ][ 'APP' ].'&_u='.$GLOBALS[ '_UCT' ][ 'CTL' ].'.'.$GLOBALS[ '_UCT' ][ 'ACT' ].'&limit=' . $option[ 'limit' ] . '&page=');

		$params = array('job'=>$job,
		                'option' => $option,
		                'pagination' => $pagination
		);
		$this->sp_render($params);
	}


}

