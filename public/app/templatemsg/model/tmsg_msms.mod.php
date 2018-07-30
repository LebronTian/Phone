<?php
/*
	如何添加一个模板消息通知

	1. 实现这样一个类3个函数 get_even_args_arr get_even_arr get_args
	2. app/templatemsg/model/template_msg_wxplug.mod.php +580 +634 各增加一行用于后台菜单设置
            '995'=> Tmsg_msmsMod::get_even_args_arr(),
            '995'=> Tmsg_msmsMod::get_even_arr($key),

	3. app/templatemsg/control/sp.ctl.php +48 增加一行入口
			

	4. 在需要调用的地方 调用一下发送
		if(uct_class_exists('Template_Msg_WxPlugMod', 'templatemsg')) {
			...
			Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__.'.'.__FUNCTION__, 
						$sp_uid, $su_uid, Tmsg_msmsMod::get_args($args));
		}
	

*/

class Tmsg_msmsMod {
	/*
		获取模板消息内可用的变量
	*/
	public static function get_even_args_arr()
	{
		$arr = array(
				array('key' => 'status', 'title' => '审核结果'),
				array('key' => 'su_uid', 'title' => '用户名'),
				array('key' => 'sign', 'title' => '短信签名'),
				array('key' => 'content', 'title' => '短信内容'),
		);

		return $arr;
	}

	// 取触发模板消息时间数组 
	public static function get_even_arr($key = '') {
		$arr = array(
				'0' => array('key' => 'MsmsNoticeTplMod.review_tpl', 'title' => '短信模板审核结果'),
		);

		return $arr;
	}

	/*
		格式化参数用的
	*/
	public static function get_args($args) {
		$su = AccountMod::get_service_user_by_uid($args['su_uid']);

		return array('su_name' => $su['name'] ? $su['name'] : $su['account'], 
					'content' => $args['content'],
					'sign' => $args['sign'],
					'status' => $args['status'] == 1 ? '成功' : ($args['status'] == 2 ? '失败' : '未审核'),
					);
	}

}

