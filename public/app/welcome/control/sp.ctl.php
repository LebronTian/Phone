<?php

class SpCtl {
	public function index() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			if($media_uid = requestInt('media_uid')) {
				$msg = array('media_type' => 0, 'media_uid' => $media_uid);
			}
			else {
				$msg = array('media_type' => 1, 'content' => requestString('msg'));
			}
			outRight(Welcome_WxPlugMod::set_public_welcome_msg($msg));
		}

		$msg = Welcome_WxPlugMod::get_public_welcome_msg();
		$param = array('msg' => $msg);
		render_sp_inner('', $param);
	}
	public function __call($function_name,$args)
	{
		redirectTo('?_a='.$GLOBALS[ '_UCT' ][ 'APP' ].'&_u=sp');
	}
}

