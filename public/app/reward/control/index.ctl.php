<?php

class IndexCtl {
	public function init_reward() {

		if(!($r_uid = requestInt('r_uid')) ||
			!($reward = RewardMod::get_reward_by_uid($r_uid))) {
				//试着取默认商户抽奖
				if(!($reward = RewardMod::get_default_reward_by_sp_uid(AccountMod::require_sp_uid()))) {
					echo '参数错误! r_uid ';
					exit();
				}
		}
		if($reward['status'] > 0) {
			echo '该抽奖已经下线!';
			exit();
		}

		//设一下当前商户uid
		$_REQUEST['__sp_uid'] = $reward['sp_uid'];

		//必须要登陆, 注意首页不检查
		if(!empty($reward['access_rule']['must_login']) && !in_array($GLOBALS['_UCT']['ACT'], array('index'))) {
			uct_use_app('su');
			$su_uid = SuMod::require_su_uid();
		}

		//require一下, 防止某些情况下  Cannot modify header information
		AccountMod::require_sp_uid();

		!isset($GLOBALS['_UCT']['TPL']) && ($GLOBALS['_UCT']['TPL'] = $reward['tpl'] ? $reward['tpl'] : 'dial');
		return $reward;
	}

	/*
		抽奖页
	*/
	public function index() {
		$reward = $this->init_reward();
		$su = AccountMod::get_current_service_user();

		//取所有的抽奖项
		$option = array('r_uid' => $reward['uid'],
						'page'  => 0,
						'limit' => -1,
						'sort'  => requestInt('sort', SORT_VOTE_DESC), //排序按抽奖数从多到少
						'key'   => requestString('key', PATTERN_SEARCH_KEY), //搜索关键字
				);
		$items = RewardMod::get_reward_item_list($option);

		
		$option['limit']  = 6;
		$option['is_win']  = 1;
		unset($option['key']);
		$records    = RewardMod::get_reward_record_list($option);

		$record = array();
		if(($uid = requestInt('record_uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
		}

		$params = array('reward' => $reward, 'records'=>$records ,'items' => $items, 'su' => $su, 'record' => $record);
		// var_dump($params);exit;
		render_fg('', $params);
	}

	/*
		抽奖结果统计页
	*/
	public function statistic(){
		$reward = $this->init_reward();
		$su = AccountMod::get_current_service_user();

		$record = array();
		if(($uid = requestInt('record_uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
		}

		$params = array('reward' => $reward, 'su' => $su, 'record' => $record);
		render_fg('', $params);
	}

	/*
		表单填写页	
	*/
	public function form() {
		$reward = $this->init_reward();
		$su = AccountMod::get_current_service_user();

		$record = array();
		if(($uid = requestInt('record_uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
		}

		$params = array('reward' => $reward, 'su' => $su, 'record' => $record);
		render_fg('', $params);
	}

	/*
		奖品兑换页	
	*/
	public function check() {
		$reward = $this->init_reward();
		$su = AccountMod::get_current_service_user();

		$record = array();
		if(($uid = requestInt('record_uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
		}

		$params = array('reward' => $reward, 'su' => $su, 'record' => $record);
		// var_dump($params);exit;
		render_fg('', $params);
	}


	/*
		当前用户中奖记录
	*/
	public function result_user(){
		$reward = $this->init_reward();
		//如果指定了中奖记录uid, 那么只取一条
		$record = array();
		if(($uid = requestInt('record_uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
			$records = array();
		}
		else {
			$option['r_uid'] = $reward['uid'];
			if(!($option['su_uid'] = AccountMod::has_su_login())) {
				$option['user_ip'] = requestClientIP();
			}
			$option['page'] = 0;
			$option['limit'] = -1;

			$option['is_win'] = true;
			$option['no_remark'] = true; //只要未领取过的
			$records = RewardMod::get_reward_record_list($option);
		}
		
		$params = array('reward' => $reward, 'records' => $records);
		// var_dump($params);exit;
		render_fg('', $params);
	}

//------------------------------------


	public function active() {
	$reward = $this->init_reward();
	$su = AccountMod::get_current_service_user();

	//取所有的抽奖项
	$option = array('r_uid' => $reward['uid'],
					'page'  => 0,
					'limit' => -1,
					'sort'  => requestInt('sort', SORT_VOTE_DESC), //排序按抽奖数从多到少
					'key'   => requestString('key', PATTERN_SEARCH_KEY), //搜索关键字
			);
	$items = RewardMod::get_reward_item_list($option);

	$record = array();
	if(($uid = requestInt('uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
	}

	$params = array('reward' => $reward, 'items' => $items, 'su' => $su, 'record' => $record);
	render_fg('', $params);
	}

	public function isreward(){
	$reward = $this->init_reward();
	$su = AccountMod::get_current_service_user();

	//取所有的抽奖项
	$option = array('r_uid' => $reward['uid'],
					'page'  => 0,
					'limit' => -1,
					'sort'  => requestInt('sort', SORT_VOTE_DESC), //排序按抽奖数从多到少
					'key'   => requestString('key', PATTERN_SEARCH_KEY), //搜索关键字
			);
	$items = RewardMod::get_reward_item_list($option);

	$record = array();
	if(($uid = requestInt('uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
	}

	$params = array('reward' => $reward, 'items' => $items, 'su' => $su, 'record' => $record);
	render_fg('', $params);			
	}

	public function reward(){
	$reward = $this->init_reward();
	$su = AccountMod::get_current_service_user();

	//取所有的抽奖项
	$option = array('r_uid' => $reward['uid'],
					'page'  => 0,
					'limit' => -1,
					'sort'  => requestInt('sort', SORT_VOTE_DESC), //排序按抽奖数从多到少
					'key'   => requestString('key', PATTERN_SEARCH_KEY), //搜索关键字
			);
	$items = RewardMod::get_reward_item_list($option);

	$record = array();
	if(($uid = requestInt('uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
	}

	$params = array('reward' => $reward, 'items' => $items, 'su' => $su, 'record' => $record);
	render_fg('', $params);
	}



	public function myreward(){
	$reward = $this->init_reward();
	$option['r_uid'] = $reward['uid'];
	if(!($option['su_uid'] = AccountMod::has_su_login())) {
		$option['user_ip'] = requestClientIP();
	}
	$option['page'] = 0;
	$option['limit'] = -1;

	$option['is_win'] = true;
	$option['no_remark'] = true; //只要未领取过的
	$records = RewardMod::get_reward_record_list($option);
	
	$params = array('reward' => $reward, 'records' => $records);
	render_fg('', $params);
	}






	public function gift(){
	$reward = $this->init_reward();
	$su = AccountMod::get_current_service_user();
			
	$record = array();
	if(($uid = requestInt('record_uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
	}

	$params = array('reward' => $reward, 'record' => $record,'su'=>$su);
	render_fg('', $params);
	}


	public function exchange(){
	$reward = $this->init_reward();
	$record = array();
	if(($uid = requestInt('uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
	}

	$params = array('reward' => $reward,'record' => $record);
	render_fg('', $params);
	}

	public function minion(){
	$reward = $this->init_reward();
	$record = array();
	if(($uid = requestInt('uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
	}

	$params = array('reward' => $reward,'record' => $record);
	render_fg('', $params);
	}

	public function end(){
	$reward = $this->init_reward();
	$su = AccountMod::get_current_service_user();

	//取所有的抽奖项
	$option = array('r_uid' => $reward['uid'],
					'page'  => 0,
					'limit' => -1,
					'sort'  => requestInt('sort', SORT_VOTE_DESC), //排序按抽奖数从多到少
					'key'   => requestString('key', PATTERN_SEARCH_KEY), //搜索关键字
			);
	$items = RewardMod::get_reward_item_list($option);

	$record = array();
	if(($uid = requestInt('uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
	}

	$params = array('reward' => $reward, 'items' => $items, 'su' => $su, 'record' => $record);
	render_fg('', $params);
	}
	
	public function qrcode() {

	$r_uid = requestInt('r_uid');
	//$url = 'http://'.$_SERVER['HTTP_HOST'].'?_a=reward&r_uid='.$r_uid;
	$url = 'http://' . parse_url(DomainMod::get_app_url('reward', ""), PHP_URL_HOST).'?_a=reward&r_uid='.$r_uid;
	require_once UCT_PATH.'vendor/phpQrcode/PHPQRCode.php';
	\PHPQRCode\QRcode::png($url);
	}
	
	public function out()
	{	
		//var_dump(RewardMod::get_reward_record_by_uid(17));
	}
	
	public function play() {
		$reward = $this->init_reward();
		$su = AccountMod::get_current_service_user();

		//取所有的抽奖项
		$option = array('r_uid' => $reward['uid'],
						'page'  => 0,
						'limit' => -1,
						'sort'  => requestInt('sort', SORT_VOTE_DESC), //排序按抽奖数从多到少
						'key'   => requestString('key', PATTERN_SEARCH_KEY), //搜索关键字
				);
		$items = RewardMod::get_reward_item_list($option);

		
		$option['limit']  = 6;
		$option['is_win']  = 1;
		unset($option['key']);
		$records    = RewardMod::get_reward_record_list($option);

		$record = array();
		if(($uid = requestInt('record_uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
		}

		$params = array('reward' => $reward, 'records'=>$records ,'items' => $items, 'su' => $su, 'record' => $record);
		// var_dump($params);exit;
		render_fg('', $params);
	}

	public function christmas() {
		$reward = $this->init_reward();
		$su = AccountMod::get_current_service_user();

		//取所有的抽奖项
		$option = array('r_uid' => $reward['uid'],
						'page'  => 0,
						'limit' => -1,
						'sort'  => requestInt('sort', SORT_VOTE_DESC), //排序按抽奖数从多到少
						'key'   => requestString('key', PATTERN_SEARCH_KEY), //搜索关键字
				);
		$items = RewardMod::get_reward_item_list($option);

		
		$option['limit']  = 6;
		$option['is_win']  = 1;
		unset($option['key']);
		$records    = RewardMod::get_reward_record_list($option);

		$record = array();
		if(($uid = requestInt('record_uid')) && ($record = RewardMod::get_reward_record_by_uid($uid))) {
		}

		$params = array('reward' => $reward, 'records'=>$records ,'items' => $items, 'su' => $su, 'record' => $record);
		// var_dump($params);exit;
		render_fg('', $params);
	}


}

