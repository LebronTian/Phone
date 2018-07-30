<?php

/*
	支持emoji表情转换

	uct内部使用html保存表情，微信中用原始字符串
*/
define('TRY_SUPPORT_FOR_EMOJI_MB4', 1);
include_once UCT_PATH.'vendor/emoji/emoji.php';

class  MenuMod {
	/*
		获取公众号菜单
		返回结构参考 http://mp.weixin.qq.com/wiki/17/4dc4b0514fdad7a5fbbd477aa9aab5ed.html
	*/
	public static function get_weixin_public_menu($public_uid = 0)
	{
		if (!$public_uid && !($public_uid = WeixinMod::get_current_weixin_public('uid')))
		{
			setLastError(ERROR_OBJ_NOT_EXIST);

			return false;
		}

		$key = 'menu_' . $public_uid;
		$m   = $GLOBALS['arraydb_weixin_public'][$key];
		if (!$m || !($m = json_decode($m, true)))
		{
			$m = array();
		}
		if ($m)
		{
			//$m = htmlspecialchars($d);
		}

		return $m;
	}

	/*
		设置公众号菜单
		menu格式 参考 http://mp.weixin.qq.com/wiki/13/43de8269be54a0a6f64413e4dfa94f39.html

		注意 微信设置菜单的menu 和 获取菜单的menu 数据结构不一样!
		因此设置成功后这里又重新取了一遍以保证本地$GLOBALS['arraydb_weixin_public']数据结构一致
	*/
	public static function set_weixin_public_menu($menu, $public_uid = 0)
	{
		if (!$public_uid && !($public_uid = WeixinMod::get_current_weixin_public('uid')))
		{
			setLastError(ERROR_OBJ_NOT_EXIST);

			return false;
		}

		$key = 'menu_' . $public_uid;
		//$GLOBALS['arraydb_weixin_public'][$key] = json_encode($menu);

		if(defined('TRY_SUPPORT_FOR_EMOJI_MB4') && TRY_SUPPORT_FOR_EMOJI_MB4) {
			if($menu)
			array_walk_recursive($menu, function(&$v, $k){
				$k == 'name' && $v = MenuMod::mb4_uct_to_wx($v);
			});
		}

		$ret = Weixin::weixin_create_menu($menu, WeixinMod::get_weixin_access_token($public_uid));
		if (!$ret || (!$ret = json_decode($ret, true)) || !isset($ret['errcode']) || $ret['errcode'] != 0)
		{
			// if(!$ret) {
			WeixinMod::refresh_weixin_access_token($public_uid);
			setLastError(ERROR_IN_WEIXIN_API);

			return isset($ret['errcode']) ? $ret['errcode'] : 'false';
		}
		else
		{
			self::get_weixin_public_menu_from_tencent($public_uid);
			
		}

		return true;
	}

	/*
		 从腾讯服务器同步公众号菜单
	 */
	public static function get_weixin_public_menu_from_tencent($public_uid = 0)
	{
		if (!$public_uid && !($public_uid = WeixinMod::get_current_weixin_public('uid')))
		{
			setLastError(ERROR_OBJ_NOT_EXIST);

			return false;
		}
		$menus = Weixin::weixin_get_self_menu(WeixinMod::get_weixin_access_token($public_uid));
		//		$menu = $menus;
		$menu['is_menu_open'] = $menus['is_menu_open'];
		if (isset($menus['selfmenu_info']['button']))
		{
			$i = 0;
			foreach ($menus['selfmenu_info']['button'] as $kbut => $but)
			{
				if (isset($but['type']))
				{
					$ret = self::change_munu_from_wx($but);
					if (isset($ret))
					{
						$menu['selfmenu_info']['button'][$i] = $ret;
					}
					else
					{
						unset($menu['selfmenu_info']['button'][$i]);
						continue;
					}
					$i++;
				}
				else
				{
					$menu['selfmenu_info']['button'][$kbut]['name'] = $but['name'];
					if (isset($but['sub_button']))
					{
						$j = 0;
						foreach ($but["sub_button"]['list'] as $subk => $sub)
						{
							$ret = self::change_munu_from_wx($sub);
							if (isset($ret))
							{
								$menu['selfmenu_info']['button'][$kbut]['sub_button']['list'][$j] = $ret;
							}
							else
							{
								unset($menu['selfmenu_info']['button'][$kbut]['sub_button']['list'][$subk]);
								continue;
							}

							//                        $menu['selfmenu_info']['button'][$kbut]['sub_button']['list'][$subk] = $sub;
							$j++;
						}
					}
					if (empty($menu['selfmenu_info']['button'][$kbut]['sub_button']['list']))
					{
						unset($menu['selfmenu_info']['button'][$kbut]);
						continue;
					}
					$i++;
				}

			}
		}
		if (!$menu)
		{
			//如果为空是否要清空本地数据?
			// WeixinMod::refresh_weixin_access_token($public_uid);
		}
		else
		{
			$key                                    = 'menu_' . $public_uid;
			$GLOBALS['arraydb_weixin_public'][$key] = json_encode($menu);
		}
		self::add_menu_record($public_uid, json_encode($menu));

		return $menu;
	}

	/*
	处理 微信后台设置菜单的情况
	 */
	public static function change_munu_from_wx($but)
	{
		//添加到素材 设置为关键字
		uct_use_app('sp');
		uct_use_app('keywords');
		$ret_but = $but;
		switch ($but['type'])
		{
			case 'view';
				$ret_but = $but;
				break;
			case 'news':

				unset($ret_but['type']);
				unset($ret_but['news_info']);
				unset($ret_but['value']);
				foreach ($but['news_info']['list'] as $new)
				{
					$media['content'][] = array('Title'       => empty($new) ? '' : $new['title'],
					                            'Description' => empty($new) ? '' : $new['digest'],
					                            'PicUrl'      => empty($new) ? '' : $new['cover_url'],
					                            'Url'         => empty($new) ? '' : $new['content_url']);
				}
				$media['media_type'] = (count($media['content']) == 1 ? 2 : 3);
				$media['sp_uid']     = AccountMod::get_current_service_provider('uid');

				$media_uid           = WeixinMediaMod::add_or_edit_weixin_media($media);
				$k['keyword']        = 'memu_news_' . md5(json_encode($but['news_info']));
				$k['data']           = WeixinMediaMod::get_weixin_media_by_uid($media_uid);
				$k['data']['sp_uid'] = AccountMod::get_current_service_provider('uid');
				Keywords_WxPlugMod::add_or_edit_public_keywords($k);
				$ret_but = array('type' => 'click', 'name' => $but['name'], 'key' => $k['keyword']);
				break;
			case 'video':
				return null;
				break;
			case 'voice':
				return null;

				break;
			case 'text':
				unset($ret_but['type']);
				unset($ret_but['value']);
				$media           = array('media_type' => 1, 'content' => $but['value']);
				$media['sp_uid'] = AccountMod::get_current_service_provider('uid');
				$media_uid       = WeixinMediaMod::add_or_edit_weixin_media($media);
				$k['keyword']    = 'memu_text_' . md5($but['value']);

				$k['data']           = WeixinMediaMod::get_weixin_media_by_uid($media_uid);
				$k['data']['sp_uid'] = AccountMod::get_current_service_provider('uid');
				Keywords_WxPlugMod::add_or_edit_public_keywords($k);
				$ret_but = array('type' => 'click', 'name' => $but['name'], 'key' => $k['keyword']);
				break;
			case 'img':
				return null;

				break;
		}

		if(defined('TRY_SUPPORT_FOR_EMOJI_MB4') && TRY_SUPPORT_FOR_EMOJI_MB4) {
			if(!empty($ret_but['name'])) {
				$ret_but['name'] = MenuMod::mb4_wx_to_uct($ret_but['name']);
			}
		}

		//var_dump($ret_but);
		return $ret_but;
	}


	/*
		删除公众号菜单 
	*/
	public static function delete_weixin_public_menu($public_uid = 0)
	{
		if (!$public_uid && !($public_uid = WeixinMod::get_current_weixin_public('uid')))
		{
			setLastError(ERROR_OBJ_NOT_EXIST);

			return false;
		}

		$ret = Weixin::weixin_delete_menu(WeixinMod::get_weixin_access_token($public_uid));
		if (!$ret)
		{
			// WeixinMod::refresh_weixin_access_token($public_uid);
		}
		else
		{
			$key = 'menu_' . $public_uid;
			unset($GLOBALS['arraydb_weixin_public'][$key]);
		}

		return $ret;
	}

	/*
	 * 增加设置菜单记录  存最5个
	 */
	public static function add_menu_record($public_uid, $menu)
	{
		$menu_record = json_decode($GLOBALS['arraydb_weixin_public']['menu_record_' . $public_uid], true);
		if (!is_array($menu_record))
		{
			$menu_record = array();
		}
		$menu_record[time()] = $menu;
		krsort($menu_record);
		//		array_unshift($menu_record, $menu);
		$menu_record                                                    = array_unique($menu_record);
		$menu_record                                                    = array_slice($menu_record, 0, 5, true);
		$GLOBALS['arraydb_weixin_public']['menu_record_' . $public_uid] = json_encode($menu_record);

	}

	/*
	 * 删除某个菜单记录
	 */
	public static function delete_menu_record($public_uid, $i)
	{
		$menu_record = json_decode($GLOBALS['arraydb_weixin_public']['menu_record_' . $public_uid], true);
		if (isset($menu_record[$i]))
		{
			unset($menu_record[$i]);
		}
		$GLOBALS['arraydb_weixin_public']['menu_record_' . $public_uid] = json_encode($menu_record);

		return true;
	}

	/*
		utf8mb4 to html
	*/
	protected static function mb4_wx_to_uct($str) {
		return emoji_unified_to_html($str);
	}

	/*
		html to utf8mb4
	*/
	protected static function mb4_uct_to_wx($str) {
		return emoji_html_to_unified($str);
	}

	
}

