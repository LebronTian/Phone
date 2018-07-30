<?php
/*
	余额变更发送微信通知
*/

class Su_cashnoticeJob {
	public function perform($uid) {
		if(!($cr = SuPointMod::get_cash_record_by_uid($uid)) ||
			!($su = AccountMod::get_service_user_by_uid($cr['su_uid']))) {
			
			echo '参数错误！';
			return;
		}
		
		if(!$cfg = SuPointMod::is_cashnotice_available($su['sp_uid'])) {
			echo '未设置余额变更通知';
			return;
		}

		if($open_id = Dba::readOne('select open_id from weixin_fans where su_uid = '.$su['uid'])) {
			$data = array(
				'template_id' => $cfg['tid'],
				'touser' => $open_id,
				'topcolor' => '#DC143C',
				'data' => array(	
					'first' => array(
						'value' => '账号余额变更提醒 - '.($cr['type'] == 1 ? '支出' : '收入'),
						'color' => 	'#C0C0C0',
					),
					'keyword1' => array(
						'value' => ($cr['type'] == 1 ? '支出/提现' : '收入/奖励').($cr['cash']/100).'元',
						'color' => 	'#C0C0C0',
					),
					'keyword2' => array(
						'value' => '当前余额: '.($cr['cash_remain']/100).'元',
						'color' => '#173177',
					),
					'remark' => array(
						'value' => $cr['info'],
						'color' => '#173177',
					),
				),
			);

			$ret = WeixinMod::send_template_msg($data, $cfg['public_uid']);
			echo '发送模板消息。。。'.($ret?$ret:'失败！！！');
		}
		else {
			echo '粉丝未绑定微信,无法发送模板消息';
		}
	}
}

