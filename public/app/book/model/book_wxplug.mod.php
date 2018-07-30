<?php


class  Book_WxPlugMod {
	public static function func_get_book_cfg($item) {
		if(!empty($item['cfg'])) $item['cfg'] = json_decode($item['cfg'], true);
		return $item;
	}

	public static function get_book_cfg($sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			return false;
		}

		$cfg = Dba::readRowAssoc('select * from book_cfg where sp_uid = '.$sp_uid, 'Book_WxPlugMod::func_get_book_cfg');
		if(!$cfg) {
			$dft = array('sp_uid' => $sp_uid);
			Dba::insert('book_cfg', $dft);
			$cfg = Dba::readRowAssoc('select * from book_cfg where sp_uid = '.$sp_uid, 'Book_WxPlugMod::func_get_book_cfg');
			
		}

		return $cfg;
	}

	public static function set_book_cfg($cfg) {
		return Dba::update('book_cfg', $cfg, 'sp_uid = '.$cfg['sp_uid']);
	}

	public static function onWeixinNormalMsg() {
		#$msg = '呵呵 <a href="'.'http://'.$_SERVER['HTTP_HOST'].'?WEIXINSESSIONID='.WeixinMod::get_a_weixin_session_id().'">点击进入</a>';
		#Weixin::weixin_reply_txt($msg);
	}	

	public static function onWeixinEventMsg() {
	}	
}

