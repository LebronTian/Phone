<?php

class SpCtl {
	public function index() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			$type = requestString('type');
			if(!in_array($type, array('msg', 'keyword', 'proxy','nodo','robot'))) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}

			//可以留空
			if($media_uid = requestInt('media_uid')) {
				$msg = array('media_type' => 0, 'media_uid' => $media_uid);
			}
			else {
				$msg = array('media_type' => 1, 'content' => requestString('msg_content'));
			}
			$keyword = requestString('keyword', PATTERN_USER_NAME);
			$url = requestString('url', PATTERN_FULLURL);
			if($url) {
				$mix = parse_url($url);
				if(empty($mix['host']) || ($mix['host'] == getDomainName())) {
					outError(ERROR_DBG_STEP_1);
				}
			}
			$token = requestString('token', PATTERN_TOKEN);
			$msg_mode = requestInt('msg_mode', 1);
			$aes_key = requestString('aes_key', PATTERN_AES);

			$dft = array(
				'type' => $type,
				'msg' => $msg,
				'keyword' => array('key' => $keyword),
				'proxy' => array('url' => $url, 'token' => $token, 'msg_mode' => $msg_mode, 'aes_key' => $aes_key,
				),
				'nodo'=>'nodo',
//				'robot'=>'robot',
				//'robot'=>array('url' => 'http://www.tuling123.com/openapi/wechatapi?key=278c41acf653a73f733ad7bc8ad63933', 'token' => 'test', 'msg_mode' => $msg_mode, 'aes_key' => $aes_key,
				'robot'=>array('url' => 'http://www.tuling123.com/openapi/api?key=278c41acf653a73f733ad7bc8ad63933', 'token' => 'test', 'msg_mode' => $msg_mode, 'aes_key' => $aes_key,
				),
			);
			outRight(Default_WxPlugMod::set_public_default_action($dft));
		}

		$dft = Default_WxPlugMod::get_public_default_action();
		$params = array('dft' => $dft);
		render_sp_inner('', $params);
	}
	public function __call($function_name,$args)
	{
		redirectTo('?_a='.$GLOBALS[ '_UCT' ][ 'APP' ].'&_u=sp');
	}
}

