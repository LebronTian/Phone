<?php


class UsignRuleMod {
	//定义 签到规则对应的 响应方法
	protected static $usignrule_arr = array(
		'addpoint'
	);

	public static function do_sign_by_rule($su_uid,$rule)
	{

		if(empty($rule) || !isset($rule['0']) || empty($rule['1']))
			return ;
		$func  = self::$usignrule_arr[$rule[0]];
	    return self::$func($su_uid,$rule[1]);
	}

	public static function addpoint($su_uid,$point)
	{
		uct_use_app('su');
		uct_use_app('vipcard');
		SuPointMod::increase_user_point(array('su_uid' => $su_uid,
		                                      'point' => $point,
		                                      'info' => '签到增加积分' ));
		$GLOBALS['_TMP']['INFO_DATA'] = '奖励'.$point.'点积分';
		Event::handle('AfterIncrease_User_Point', array($su_uid));
		return true;
	}
}

