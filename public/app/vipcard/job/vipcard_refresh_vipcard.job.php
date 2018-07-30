<?php
// 下载微信 素材到本地
class vipcard_refresh_vipcardJob {
	public function perform($sp_uid, $su_uid)
	{
		uct_use_app('vipcard');
		uct_use_app('upload');
		AccountMod::set_current_service_provider($sp_uid);

		if(!($su = AccountMod::get_service_user_by_uid($su_uid))
			|| !($su['sp_uid'] == $sp_uid)
			|| !($vip_card_su = VipcardMod::get_vip_card_by_su_uid($su_uid))
		)
		{
			return ;
		}
		$vip_card = VipcardMod::get_create_vip_card_array($su_uid,$sp_uid);
		$vip_card_imge = VipcardMod::create_vip_card_img($vip_card);
		$vip_card_su['card_url'] = VipcardMod::update_vip_card_image($vip_card_imge,$su_uid);
		VipcardMod::add_or_edit_vip_card( $vip_card_su);
	}

}

