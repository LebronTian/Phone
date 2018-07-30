<?php
/*
	自定义关键词回复

	注意 本插件要在默认回复插件之前加载
*/
class  Keywords_WxPlugMod {
	public static function func_get_keywords($item) {
		if(!empty($item['data'])) $item['data'] = json_decode($item['data'], true);
		return $item;
	}

	public static function onWeixinNormalMsg() {
		//$msg = '呵呵 <a href="'.'http://'.$_SERVER['HTTP_HOST'].'?WEIXINSESSIONID='.WeixinMod::get_a_weixin_session_id().'">点击进入</a>';
		//Weixin::weixin_reply_txt($msg);
	}	

	public static function onWeixinEventMsg() {
	}	

	public static function onDefaultWeixinMsg() {
		if(($ks = self::get_public_keywords()) && ($content = WeixinMod::get_weixin_xml_args('Content'))) {
			foreach($ks as $k) {
				if (false !== stripos($content, $k['keyword'])) {
					//WeixinMediaMod::xiaochengxu_reply_media($k['data']);
					return WeixinMediaMod::weixin_reply_media($k['data']);
				}
			}
		}
	}	
	
	/*
		获取自定义回复列表,
		不分页
	*/
	public static function get_public_keywords($uid = 0) {
		if(!$uid && !($uid = WeixinMod::get_current_weixin_public('uid'))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		return Dba::readAllAssoc('select * from keywords_reply where public_uid = '.$uid, 'Keywords_WxPlugMod::func_get_keywords');
	}

	/*
		添加或编辑关键词回复
	*/
	public static function add_or_edit_public_keywords($k, $public_uid = 0) {
		if(!$public_uid && !($public_uid = WeixinMod::get_current_weixin_public('uid'))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		if(!empty($k['uid'])) {
			Dba::update('keywords_reply', $k, 'uid = '.$k['uid'].' and public_uid = '.$public_uid);
		}
		else {
			$k['public_uid']=$public_uid;
			Dba::insert('keywords_reply', $k);
			$k['uid'] = Dba::insertID();
		}
		return $k['uid'];
	}

	/*
		删除关键词,返回删除的数目
	*/
	public static function delete_keywords($cids, $public_uid = 0) {
		if(!$public_uid && !($public_uid = WeixinMod::get_current_weixin_public('uid'))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'delete from keywords_reply where uid in ('.implode(',',$cids).') and public_uid= '.$public_uid;
		$ret = Dba::write($sql);

		return $ret;
	}
}

