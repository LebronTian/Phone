<?php


class  Shop_WxPlugMod {
	public static function onWeixinNormalMsg() {
		self::shop_wx_to_do();
	}

/*
	小程序审核通过
<xml><ToUserName><![CDATA[gh_3a5f4763ccf2]]></ToUserName>
<FromUserName><![CDATA[omxz40Bu_z-p1W9ITWsekEnsBy3Q]]></FromUserName>
<CreateTime>1522659844</CreateTime>
<MsgType><![CDATA[event]]></MsgType>
<Event><![CDATA[weapp_audit_success]]></Event>
<SuccTime>1522659844</SuccTime>
</xml>
*/
	public static function on_xiaochengxu_audit_ok() {
		XiaochengxuMod::release_xiaochengxu(WeixinMod::get_current_weixin_public());
		uct_use_app('sp');
		$msg = array('sp_uid' => WeixinMod::get_current_weixin_public('sp_uid'),
					'title' => '小程序 审核通过 通知',
					'content' => '小程序 ['.WeixinMod::get_current_weixin_public('public_name').
		'] 已经成功通过审核！审核时间 '.date('Y-m-d H:i:s', WeixinMod::get_weixin_xml_args('SuccTime')),
		);
		SpMsgMod::add_sp_msg($msg);
	}

	public static function onWeixinEventMsg() {
		if(WeixinMod::get_weixin_xml_args('Event') === 'weapp_audit_success') {
			return self::on_xiaochengxu_audit_ok();
		}	

		self::shop_wx_to_do();
	}

	public static function shop_wx_to_do()
	{

 		$args                  = WeixinMod::get_weixin_xml_args();
		if(!isset($args['Content']))
			return ;
		if (!strcasecmp($args['Content'], '微商城')) {
			$msg = '<a href="'.DomainMod::get_app_url('shop').'">微商城</a>';
			Weixin::weixin_reply_txt($msg);
		}
		if (!strcasecmp($args['Content'], '二维码')) {
			uct_use_app('material');
			$su_uid = AccountMod::get_current_service_user('uid');

			$url = DomainMod::get_app_url('shop',AccountMod::get_current_service_provider('uid'),array('_u'=>'user','parent_su_uid'=>$su_uid));
			require_once UCT_PATH.'vendor/phpQrcode/PHPQRCode.php';
			ob_start();
			\PHPQRCode\QRcode::png($url);
			$image_data = ob_get_contents();
			ob_end_clean();
			Header("Content-Type:text/html");
			header_remove();
			$data['type'] = 'image';
			$varname = 'qrcode';//上传到$_FILES数组中的 key
			$name = time().'.png';//文件名
			$data['media']=  "$varname\"; filename=\"$name\r\nContent-Type: image/png\r\n";
			$data[$data['media']] = $image_data;
			$access_token = WeixinMod::get_weixin_access_token( WeixinMod::get_current_weixin_public('uid'));
			$ret = Material::media_upload($access_token, $data);
			if ( !$ret || !( $ret = json_decode( $ret, true ) ) || isset( $ret[ 'errcode' ] ) ) {
				Weixin::weixin_reply_txt('获取失败！');
			}
			$media_id =$ret['media_id'];
			Weixin::weixin_reply_image($media_id);
		}
	}
}

