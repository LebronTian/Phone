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
			array('name' => '砍价背景', 'icon' => 'am-icon-files-o', 'link' => '?_a=bargain&_u=sp.card_img', 'activeurl' => 'sp.card_img'),
			array('name' => '砍价商品', 'icon' => 'am-icon-home', 'link' => '?_a=bargain&_u=sp', 'activeurl' => 'sp.index'),
			array('name' => '砍价列表', 'icon' => 'am-icon-home', 'link' => '?_a=bargain&_u=sp.user_bargainlist', 'activeurl' => 'sp.user_bargainlist'),
			array('name' => '帮砍列表', 'icon' => 'am-icon-home', 'link' => '?_a=bargain&_u=sp.help_bargainlist', 'activeurl' => 'sp.help_bargainlist'),

		);
	}

	protected function sp_render($params = array()) {
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	//砍价背景图
	public function card_img(){

		$key = 'bargain_card_img';
		if(!empty($GLOBALS['arraydb_sys'][$key])){
			$info = json_decode($GLOBALS['arraydb_sys'][$key],true);
		}else{
			$public_uid = WeixinMod::get_current_weixin_public('uid');
			$info = array('public_uid'=>$public_uid,'url'=>'app/bargain/static/images/bg.png');
		}

		$params = array('card_img'=>$info);
		$this->sp_render($params);
	}

	//砍价商品表
	public function index() {

		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$data = BargainMod::get_bargainlist($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']),
			'?_a=bargain&_u=sp&limit='.$option['limit'].'&page=');

		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	//添加砍价商品
	public function add_bargain(){
		$params = array();

		//编辑模式
		if(($uid = requestInt('uid')) &&
			($bargain = BargainMod::get_bargain_by_uid($uid)) &&
			($bargain['sp_uid'] == AccountMod::get_current_service_provider('uid'))) {
			$params['data'] = $bargain;
//			$option['type'] = $form['type'];
		}

		$this->sp_render($params);
	}

	//用户砍价表
	public function user_bargainlist() {

		$option['su_uid'] = requestInt('su_uid');
		$option['bargain_uid'] = requestInt('b_uid');
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$data = BargainMod::user_bargainlist($option);

		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']),
			'?_a=bargain&_u=sp.user_bargainlist&su_uid='.$option['su_uid'].'&bargain_uid='.$option['bargain_uid'].'&limit='.$option['limit'].'&page=');

		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	//帮砍列表
	public function help_bargainlist(){

		$option['su_uid'] = requestInt('su_uid');
		$option['bu_uid'] = requestInt('bu_uid');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$data = BargainMod::help_bargainlist($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']),
			'?_a=bargain&_u=sp.help_bargainlist&su_uid='.$option['su_uid'].'&bu_uid='.$option['bu_uid'].'&limit='.$option['limit'].'&page=');

		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

}
