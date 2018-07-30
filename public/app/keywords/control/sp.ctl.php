<?php

class SpCtl {
	public function index() {
		$keywords = Keywords_WxPlugMod::get_public_keywords();
		$params = array('keywords' => $keywords);
		render_sp_inner('', $params);
	}
	public function __call($function_name,$args)
	{
		redirectTo('?_a='.$GLOBALS[ '_UCT' ][ 'APP' ].'&_u=sp');
	}

}
