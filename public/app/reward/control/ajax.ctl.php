<?php
/*
	前台ajax接口 
*/

class AjaxCtl {
	/*
		获取抽奖信息
	*/
	public function get_reward() {
		if(!($r_uid = requestInt('r_uid')) ||
			!($reward = RewardMod::get_reward_by_uid($r_uid))) {
				//试着取默认商户抽奖
				if(!($reward = RewardMod::get_default_reward_by_sp_uid(AccountMod::require_sp_uid()))) {
					outError(ERROR_INVALID_REQUEST_PARAM);
				}
		}
		if($reward['status'] > 0) {
			//outError(ERROR_BAD_STATUS);
		}
		$option2['r_uid'] = $reward['uid'];
		$option2['page'] = 0;
		$option2['limit'] = 10;
		$items = RewardMod::get_reward_item_list($option2);
		$reward['items'] = $items;

		$option3['r_uid'] = $reward['uid'];
		if(!($option3['su_uid'] = AccountMod::has_su_login())) {
			$option3['user_ip'] = requestClientIP();
		}
		$option3['page'] = 0;
		$option3['limit'] = -1;

		$option3['is_win'] = true;
		$option3['no_remark'] = true; //只要未领取过的
		$records = RewardMod::get_reward_record_list($option3);
		$reward['records'] = $records;

		outRight($reward);
	}

	/*
		抽奖
	*/
	public function doreward() {
		if(!($record['r_uid'] = requestInt('r_uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$record['su_uid'] = AccountMod::has_su_login();
		$record['user_ip'] = requestClientIP();

		outRight(RewardMod::do_reward($record['r_uid'], $record));
	}

	/*
		获取抽奖项列表 
	*/
	public function itemlist() {
		if(!($option['r_uid'] = requestInt('r_uid')) ||
			!($reward = RewardMod::get_reward_by_uid($option['r_uid']))) { 
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$option['r_uid'] =  $reward['uid'];
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['sort'] = requestInt('sort', SORT_VOTE_DESC);

		$items = RewardMod::get_reward_item_list($option);
		
		outRight($items);
	}

	/*
		获取用户中奖记录列表
	*/
	public function get_user_record_list() {	
		if(!($option['r_uid'] = requestInt('r_uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		if(empty($_REQUEST['all'])) {
		if(!($option['su_uid'] = AccountMod::has_su_login())) {
			$option['user_ip'] = requestClientIP();
		}
		}

		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$option['is_win'] = true;
		$option['no_remark'] = requestBool('no_remark', false); //默认只要未领取过的

		outRight(RewardMod::get_reward_record_list($option));
	}

	/*
		填写中奖信息
		todo 检查合法性
	*/
	public function set_win_info() {
		if(!($record['uid'] = requestInt('uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$record['data'] = requestKvJson('data'); //领奖信息 [姓名,手机,地址,邮箱]
		
		if(!($record['su_uid'] = AccountMod::has_su_login())) {
			$record['user_ip'] = requestClientIP();
		}
		$record['sp_remark'] = 2;//标记领奖

		outRight(RewardMod::edit_reward_record($record));	
	}

	/*
		标记领奖
	*/
	public function do_remark() {
		if(!($record['uid'] = requestInt('uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!($record['su_uid'] = AccountMod::has_su_login())) {
			$record['user_ip'] = requestClientIP();
		}
		$record['sp_remark'] = 1;

		outRight(RewardMod::edit_reward_record($record));	
	}

	/*
		分享到朋友圈 +1 次抽奖机会
	*/
	public function on_share_wx() {
		if(!($r_uid = requestInt('r_uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$user['su_uid'] = AccountMod::has_su_login();
		$user['user_ip'] = requestClientIP();

		$chance = array('reason' => 'share_wx', 'cnt' => 1);

		outRight(RewardMod::add_reward_chance_to_user($r_uid, $user, $chance));
	}

}

