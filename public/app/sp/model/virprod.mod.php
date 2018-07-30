<?php
/*
 * 虚拟商品共用类
 */
class VirProdMod {

    public static $from;
    /*
     * 发送虚拟奖品
     * $from 触发发送来源
     */
    public static function send_to_user($type, $vir_id, $user_id, $from ='')
    {
        self::$from = $from;
        return self::$type($vir_id,$user_id);
    }

	/*
		什么都不做
	*/
	public static function empty_($vir_id, $user_id) {
		return true;
	}

    /*
     * 发送门店优惠券
     */
    public static function store_coupon($vir_id, $user_id)
    {
        uct_use_app('store');
        return StoreCouponMod::add_a_coupon_to_user($vir_id, $user_id);
    }

    /*
     * 发送商城优惠券
     */
    public static function shop_coupon($vir_id, $user_id)
    {
        uct_use_app('shop');
        return CouponMod::add_a_coupon_to_user($vir_id, $user_id);
    }

    /*
     * 发送积分
     */
    public static function point($vir_id, $user_id)
    {
		if($vir_id <= 0) return 0;

        uct_use_app('su');
        $record = array('su_uid' => $user_id,
                        'point' => $vir_id,
                        'info'   => self::$from);
        return SuPointMod::increase_user_point($record);
    }

    /*
     * 赠送余额
     */
    public static function cash($cash, $user_id)
    {
		if($cash <= 0) return 0;
        uct_use_app('su');
        $record = array('su_uid' => $user_id,
                        'cash' => $cash,
                        'info'   => self::$from);
        return SuPointMod::increase_user_cash($record);
    }

	/*
		直接发送系统红包
		其实是增加余额后自动做一次提现
	*/
	public static function sys_redpack($cash, $user_id) {
        uct_use_app('su');
        $record = array('su_uid' => $user_id,
                        'cash' => $cash,
                        'info'   => self::$from);
        if(!SuPointMod::increase_user_cash($record)) {
			return false;	
		}
		uct_use_app('pay');
	$sp_uid = AccountMod::require_sp_uid();
        $wd = array('su_uid' => $user_id,
                        'sp_uid' => $sp_uid,
                        'cash' => $cash,
                        'info'   => self::$from);
		return WithdrawMod::do_withdraw($wd);
	}

}

