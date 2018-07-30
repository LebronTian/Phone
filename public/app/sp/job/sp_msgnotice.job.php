<?php
/*
	系统通知
*/

class Sp_msgnoticeJob {
	public function perform($uid) {
		if(!$msg = SpMsgMod::get_sp_msg_by_uid($uid)) {
			echo '参数错误！';
			return;
		}
		
		$sw = SpwxMod::get_sp_wx_list(array('sp_uid' => $msg['sp_uid'], 'page' => 0, 'limit' => -1));
		$origin_id = SYS_WX_ORIGINID;
		$public_uid = Dba::readOne('select uid from weixin_public where origin_id = "'.$origin_id.'"');
		if(!$public_uid) {
			echo ('系统内部错误8!');
			return;
		}
		//todo  改一下
		$tid = 'KpiwXik_2753gtfbmI6R3FC5cTgdQfWuYPWMRJ1m1kQ';
		if($sw['list']) {
			$data = array(
				'template_id' => $tid,
				'topcolor' => '#DC143C',
				'data' => array(	
					'first' => array(
						'value' => '[快马加鞭] 商户消息通知',
						'color' => 	'#C0C0C0',
					),
					'keyword1' => array(
						'value' => $msg['title'],
						'color' => 	'#FF0000',
					),
					'keyword2' => array(
						'value' => strip_tags($msg['content']), //简单去掉a标签
						'color' => '#173177',
					),
					'keyword3' => array(
						'value' => date('Y-m-d H:i:s', $msg['create_time']),
						'color' => 	'#C0C0C0',
					),
					'remark' => array(
						'value' => '',
						'color' => '#173177',
					),
					),
				);
		foreach($sw['list'] as $s) {
			if(empty($s['cfg']['disable_msg'])) {
				$data['touser'] = $s['open_id'];
				WeixinMod::send_template_msg($data, $public_uid);
			}
		}
		}

		
	}
}

