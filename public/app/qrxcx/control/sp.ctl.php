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
			array('name' => '生成小程序码', 'icon' => 'am-icon-home', 'link' => '?_a=qrxcx&_u=sp', 'activeurl' => 'sp.index'),
			array('name' => '小程序码海报图', 'icon' => 'am-icon-photo', 'link' => '?_a=qrxcx&_u=sp.photolist',	'activeurl' => 'sp.photolist'),
		);
	}

	protected function sp_render($params = array()) {
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	//小程序码/二维码生成
	public function index() {

		$public_uid = WeixinMod::get_current_weixin_public('uid');
		$public = WeixinMod::get_weixin_public_by_uid($public_uid);
		$uct_token = $public['uct_token'];
		$params = array('uct_token'=>$uct_token);
		$this->sp_render($params);
	}

	//小程序码海报列表
	public function photolist() {

		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');

		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$data = XcxposterMod::get_xcxposter_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count'] / $option['limit']),
			'?_a=qrxcx&_u=sp.photolist&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	//小程序码海报设置
	public function photoset() {
		$sp_uid = AccountMod::get_current_service_provider('uid');

		$qp = array();
		if($uid = requestInt('uid')) {
			$qp = XcxposterMod::get_xcxposter_by_uid($uid);
			if(!$qp || ($qp['sp_uid'] != $sp_uid)) {
				$qp = array();
			}
		}

		if($copy_uid = requestInt('copy_uid')) {
			$qp = XcxposterMod::get_xcxposter_by_uid($copy_uid);
			if(!$qp || ($qp['sp_uid'] != $sp_uid)) {
				$qp = array();
			}
			unset($qp['uid']);
		}

		$params = array('qp' => $qp);
		$this->sp_render($params);
	}

}
