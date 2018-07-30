<?php

class SpCtl {
	public function index() {
		$public_uid = WeixinMod::get_current_weixin_public('uid');
		$menu = MenuMod::get_weixin_public_menu();
		//$menu = MenuMod::get_weixin_public_menu_from_tencent(1);
		$menu_record =  $GLOBALS['arraydb_weixin_public']['menu_record_' . $public_uid];
		$params = array('menu' => $menu,
						'menu_record' => $menu_record);

		render_sp_inner('', $params);
	}

	public function save_menu() {
		$menu = requestString('menu');
		$menu = json_decode($menu, true);

		outRight(MenuMod::set_weixin_public_menu($menu));
		// echo MenuMod::set_weixin_public_menu($menu);
	}

	public function sync_menu() {
		outRight(MenuMod::get_weixin_public_menu_from_tencent());
	}

	public function delete_menu_record()
	{
		$public_uid = WeixinMod::get_current_weixin_public('uid');
		$i = requestInt('i');
		outRight(MenuMod::delete_menu_record($public_uid,$i));
	}


	public function test()
	{

	}

}

