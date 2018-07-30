<?php
/*
	如何添加一个模板消息通知

	1. 实现这样一个类3个函数 get_even_args_arr get_even_arr get_args
	2. app/templatemsg/model/template_msg_wxplug.mod.php +634 增加一行用于后台菜单设置
            '996'=> Tmsg_suMod::get_even_arr($key),

	3. 在需要调用的地方 调用一下发送
		if(uct_class_exists('Template_Msg_WxPlugMod', 'templatemsg')) {
			...
			Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__.'.'.__FUNCTION__, 
						$sp_uid, $su_uid, Tmsg_suMod::get_args($args));
		}
	

*/

class Tmsg_suMod {
	/*
		获取模板消息内可用的变量
	*/
	public static function get_even_args_arr()
	{
		$arr = array(
				array('key' => 'su_name', 'title' => '下级用户姓名'),
				array('key' => 'from_su_name',   'title' => '推荐人姓名'),
		);

		return $arr;
	}

	// 取触发模板消息时间数组 
	public static function get_even_arr($key = '') {
		$arr = array(
				'0' => array('key' => 'SuMod.update_su', 'title' => '新推荐人加入'),
		);

		return $arr;
	}

	/*
		格式化参数用的
	*/
	public static function get_args($args) {
		$su = AccountMod::get_service_user_by_uid($args['su_uid']);
		$from_su = AccountMod::get_service_user_by_uid($args['from_su_uid']);

		return array('su_name' => $su['name'] ? $su['name'] : $su['account'], 
					'from_su_name' => $from_su['name'] ? $from_su['name'] : $from_su['account'], 
					);
	}

}

