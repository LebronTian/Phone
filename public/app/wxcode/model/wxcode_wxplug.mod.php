<?php


class  Wxcode_WxPlugMod {
	public static function onWeixinNormalMsg() {
		return self::onWeixinEventMsg();
	}	

	public static function onWeixinSubscribeMsg() {
		return self::onWeixinEventMsg();
	}

	/*
		扫描带参数二维码事件
	*/
	public static function onWeixinEventMsg() {
		if(!strcasecmp(WeixinMod::get_weixin_xml_args('Event'), 'subscribe')) {
			if(($scene_id = WeixinMod::get_weixin_xml_args('EventKey')) && !strncmp('qrscene_', $scene_id, strlen('qrscene_'))) {	
				$scene_id = checkInt(substr($scene_id,  strlen('qrscene_')));
			}
			else {
				unset($scene_id);
			}
		}
		else if(!strcasecmp(WeixinMod::get_weixin_xml_args('Event'), 'SCAN')) {
			$scene_id = checkInt(WeixinMod::get_weixin_xml_args('EventKey'));	
		}
		
		if(!empty($scene_id)) {
			$sp = AccountMod::get_current_service_provider('name');
			if(!$sp) $sp = '快马加鞭';
			$sp = str_replace('刘路浩', '快马加鞭', $sp);

			if(!$c = WxCodeMod::get_wxcode_by_scene_uid($scene_id)) {
				//todo 订阅号scene_id 固定找不到 10000001 ~ 10000007
				$txt = '['.$sp.'] 二维码已过期, 请重试';
			}
			else {
				switch($c['type']) {
					case WxCodeMod::WXCODE_TYPE_SET_UCTPAY_TRANSFER: {
						uct_use_app('pay');	
						//$sp_uid = AccountMod::get_current_service_provider('uid');
						if(!$sp_uid = checkInt($c['param'])) {
							$txt = 'uct代收款服务提现微信号设置失败！参数错误！';
						}
						else {
							$pay = array('sp_uid' => $sp_uid, 'transfer_info' => 
									array('type' => 'wx_transfer', 'open_id' => WeixinMod::get_current_weixin_fan('open_id')));
							UctpayMod::add_or_edit_uctpay($pay);	
							$txt = '['.$sp.'] 您已成功设置uct代收款服务提现微信号，提现金额将打款到此号中， 请刷新页面进行提现操作';
						}
						break;
					}

					case WxCodeMod::WXCODE_TYPE_EXPTUI_TRACK: {
						if(!$t_uid = checkInt($c['param'])) {
							//$txt = '快递推记录错误！参数错误！';
						}
						uct_use_app('expresstui');
						ExpressTui_WxPlugMod::wx_track($t_uid);
						return;
					}

					case WxCodeMod::WXCODE_TYPE_QRPOSTER: {
						$param = json_decode($c['param'], true);
						if(!$su_uid = checkInt($param['su_uid'])) {
							//$txt = '二维码海报错误！参数错误！';
						}
						if(!$qp_uid = checkInt($param['qp_uid'])) {
							//$txt = '二维码海报错误！参数错误！';
						}
						uct_use_app('qrposter');
						QrPoster_WxPlugMod::on_qrcode_scan($su_uid, $qp_uid);
						return;
					}
					
					case WxCodeMod::WXCODE_TYPE_SET_SP_WX: {
						if(!$sp_uid = checkInt($c['param'])) {
							$txt = '微信号设置失败！参数错误！';
						}
						else {
							$txt = '['.$sp.'] 您已成功设置微信号，10分钟内有效, 请刷新页面继续操作';
							$open_id = WeixinMod::get_current_weixin_fan('open_id');
							$key = 'scan_open_id_'.$sp_uid;
							$GLOBALS['arraydb_sys'][$key] = array('value' => $open_id,  'expire' => 600);
						}
						break;
					}

					case WxCodeMod::WXCODE_TYPE_SCAN_SP_LOGIN: {
						$open_id = WeixinMod::get_current_weixin_fan('open_id');
						$txt = SpScanloginMod::on_sp_scanlogin_confirm($open_id, $c);
						break; 
					}

					case WxCodeMod::WXCODE_TYPE_CHECK_CODE:
					default:
					$txt = '['.$sp.'] 您的微信验证码是 '.$c['short_code'].' , 10分钟内有效,请勿告诉他人';
				}
			}	

			Weixin::weixin_reply_txt($txt);	
		}
	}	
}

