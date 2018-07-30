<?php
/*
	后台ajax接口 
*/

class ApiCtl {
	public function test_bigidea() {
		if(isset($_REQUEST['title']) && !($reward['title'] = requestStringLen('title', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}
		isset($_REQUEST['brief']) && $reward['brief'] = requestString('brief');
		isset($_REQUEST['status']) && $reward['status'] = requestInt('status');
		isset($_REQUEST['tpl']) && $reward['tpl'] = requestString('tpl', PATTERN_NORMAL_STRING);
		isset($_REQUEST['img']) && $reward['img'] = requestString('img', PATTERN_URL);
		if(isset($_REQUEST['access_rule']) && !($reward['access_rule'] = requestKvJson('access_rule', array(
				 array('must_login',   'Bool', true),
				 array('start_time',   'Int'),
				 array('end_time',     'Int'),
				 array('max_item',     'Int'),
				 array('max_cnt',      'Int', 1),
				 array('max_cnt_day',  'Int', 1),
			)))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['win_rule']) && $reward['win_rule'] = requestKvJson('win_rule');

		if(empty($reward)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		isset($_REQUEST['uid']) && $reward['uid'] = requestInt('uid');
		$reward['sp_uid'] = AccountMod::get_current_service_provider('uid');

		$r_uid = (RewardMod::add_or_edit_reward($reward));
		echo $r_uid.'!';

		$items = array(
			array('url' => 'http://weixin.uctoo.com/?_a=upload&_u=index.out&uidm=404489d', 'title' => '珍藏版小黄人玩具全套', 'weight' => '10', 'total_cnt' => 0),
			array('url' => 'http://weixin.uctoo.com/?_a=upload&_u=index.out&uidm=4031235', 'title' => '波纳纳香蕉', 'weight' => '10', 'total_cnt' => 0),
			array('url' => 'http://weixin.uctoo.com/?_a=upload&_u=index.out&uidm=40262ed', 'title' => '麦乐鸡5块', 'weight' => '10', 'total_cnt' => 0),
			array('url' => 'http://weixin.uctoo.com/?_a=upload&_u=index.out&uidm=40262ed', 'title' => '吉拉度冰激凌', 'weight' => '10', 'total_cnt' => 0),
			array('url' => 'http://weixin.uctoo.com/?_a=upload&_u=index.out&uidm=4002d05', 'title' => '咔咔麦旋风', 'weight' => '10', 'total_cnt' => 0),
			array('url' => 'http://weixin.uctoo.com/?_a=upload&_u=index.out&uidm=399d332', 'title' => '麦辣鸡翅', 'weight' => '20', 'total_cnt' => 0),
			array('url' => 'http://weixin.uctoo.com/?_a=upload&_u=index.out&uidm=3980802', 'title' => '薯条', 'weight' => '30', 'total_cnt' => 0),
		);
		foreach($items as $k=>$i) {
			$item = array(
						'r_uid' => $r_uid,
						'title' => $i['title'],
						//'brief' => '描述'.$k,
						'img' => $i['url'],
						'weight' => $i['weight'],
						'total_cnt' => $i['total_cnt'],
						);
			echo RewardMod::add_or_edit_reward_item($item).'!';
		}
		echo 'done!';
	}

	/*
		添加或编辑抽奖
	*/
	public function addreward() {
		if(isset($_REQUEST['title']) && !($reward['title'] = requestStringLen('title', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}
		isset($_REQUEST['brief']) && $reward['brief'] = requestString('brief');
		isset($_REQUEST['status']) && $reward['status'] = requestInt('status');
		isset($_REQUEST['tpl']) && $reward['tpl'] = requestString('tpl', PATTERN_NORMAL_STRING);
		isset($_REQUEST['img']) && $reward['img'] = requestString('img', PATTERN_URL);
		if(isset($_REQUEST['access_rule']) && !($reward['access_rule'] = requestKvJson('access_rule', array(
				 array('must_login',   'Bool', true),
				 array('start_time',   'Int'),
				 array('end_time',     'Int'),
				 array('max_item',     'Int'),
				 array('max_cnt',      'Int'),
				 array('max_cnt_day',  'Int'),
			)))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['win_rule']) && $reward['win_rule'] = requestKvJson('win_rule');
		// var_dump( $reward['win_rule']);
		// exit;
		if(empty($reward)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		isset($_REQUEST['uid']) && $reward['uid'] = requestInt('uid');
		$reward['sp_uid'] = AccountMod::get_current_service_provider('uid');
		outRight(RewardMod::add_or_edit_reward($reward));
	}

	/*
		删除抽奖
	*/
	public function delreward() {
		if(!($rids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(RewardMod::delete_reward($rids, AccountMod::get_current_service_provider('uid')));
	}

	/*
		添加或编辑奖品选项
	*/
	public function addrewarditem() {
		if(isset($_REQUEST['title']) && !($item['title'] = requestStringLen('title', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}
		isset($_REQUEST['brief']) && $item['brief'] = requestString('brief');
		isset($_REQUEST['sort']) && $item['sort'] = requestInt('sort');
		isset($_REQUEST['total_cnt']) && $item['total_cnt'] = requestInt('total_cnt');
		isset($_REQUEST['win_cnt']) && $item['win_cnt'] = requestInt('win_cnt');
		isset($_REQUEST['weight']) && $item['weight'] = requestInt('weight');
        isset($_REQUEST['img']) && $item['img'] = requestString('img', PATTERN_URL);
        isset($_REQUEST['virtual_info']) && $item['virtual_info'] = requestKvJson('virtual_info');
		//var_dump($_REQUEST);
		if(empty($item)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!($item['r_uid'] = requestInt('r_uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		isset($_REQUEST['uid']) && $item['uid'] = requestInt('uid');
		outRight(RewardMod::add_or_edit_reward_item($item));
	}

	/*
		删除奖品选项
	*/
	public function delrewarditem() {
		if(!($r_uid = requestInt('r_uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!($iids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(RewardMod::delete_reward_item($iids, $r_uid));
	}

	/*
		删除中奖记录
	*/
	public function delrewardrecord() {
		if(!($r_uid = requestInt('r_uid')) ||
			!($reward = RewardMod::get_reward_by_uid($r_uid)) ||
			($reward['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!($rids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(RewardMod::delete_reward_record($rids, $r_uid));
	}
	
	/*
		做颜色标记
	*/
	public function markrewardrecord()
	{
		isset($_REQUEST['uids']) && $uids = requestString('uids');
		isset($_REQUEST['sp_remark']) && $sp_remark= requestInt('sp_remark');
		isset($_REQUEST['r_uid']) && $r_uid = requestInt('r_uid');
		if(empty($uids)||empty($sp_remark)||empty($r_uid)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$uids =explode(";",$uids);
		outRight(RewardMod::remark_reward_record($uids,$sp_remark ,$r_uid));

	}

	public function get_tpls()
	{
		$option['key']   = requestString('key', PATTERN_SEARCH_KEY);
		$option['type']  = requestString('type');
		$option['page']  = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		outRight(SptplMod::get_tpls_list($option));
	}


}


