<?php

class DomainMod {
	public static function func_get_domain($item)
	{
		return $item;
	}

	/*
		todo
		检查是否
	*/
	public static function checkAppMirror()
	{
		$map = array(
			'mooncake' => 'game',
		);

		if (isset($map[$GLOBALS['_UCT']['APP']]))
		{
			$GLOBALS['_UCT']['APP_ORIG'] = $GLOBALS['_UCT']['APP'];
			$GLOBALS['_UCT']['APP']      = $map[$GLOBALS['_UCT']['APP']];
		}
	}

	/*
		检查是否有域名绑定
	*/
	public static function checkDomainBind()
	{
		if (!($db = self::get_domain_by_name()))
		{
			return;
		}

		$_REQUEST['_sp_uid']    = $db['sp_uid'];
		$_SERVER['SERVER_NAME'] = $db['domain'];
		//mark
		if(0 == strncmp('x.', $db['domain'], 2)) {
			$_REQUEST['_spv3'] = 1;
		}

		//如果是默认地址, 跳转到绑定模块
		if (($GLOBALS['_UCT']['APP'] == 'web') && ($GLOBALS['_UCT']['CTL'] == 'index') && ($GLOBALS['_UCT']['ACT'] == 'index') &&
			$db['bind']
		)
		{
			list($GLOBALS['_UCT']['APP'], $GLOBALS['_UCT']['CTL'], $GLOBALS['_UCT']['ACT']) = explode('.', $db['bind'], 3);
		}
	}

	public static function get_domain_by_name($domain = '')
	{
		if (!$domain && !($domain = checkString($_SERVER['HTTP_HOST'], PATTERN_DOMAIN_NAME)))
		{
			setLastError(ERROR_INVALID_REQUEST_PARAM);

			return false;
		}

		$sql = 'select * from domain_bind where domain ="' . addslashes($domain) . '"';

		return Dba::readRowAssoc($sql, 'DomainMod::func_get_domain');
	}

	public static function get_domain_by_uid($uid)
	{
		$sql = 'select * from domain_bind where uid ="' . ($uid) . '"';

		return Dba::readRowAssoc($sql, 'DomainMod::func_get_domain');
	}

	public static function add_or_edit_domain($db)
	{
		if (isset($db['domain']) && ($uid = Dba::readOne('select uid from domain_bind where domain = "' . addslashes($db['domain']) . '"'))
			&& (!isset($db['uid']) || ($db['uid'] != $uid))
		)
		{
			setLastError(ERROR_OBJECT_ALREADY_EXIST);

			return false;
		}

		if (empty($db['uid']))
		{
			$db['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('domain_bind', $db);
			$db['uid'] = Dba::insertID();
		}
		else
		{
			Dba::update('domain_bind', $db, 'uid = ' . $db['uid']);
		}

		return $db['uid'];
	}

	public static function get_domain_list($option)
	{
		$sql = 'select * from domain_bind';
		if (!empty($option['sp_uid']))
		{
			$where_arr[] = 'sp_uid=' . $option['sp_uid'];
		}

		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by uid desc';
		
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'DomainMod::func_get_domain');
	}

	/*
		删除绑定域名

		返回删除的条数
		//todo 更新一下配额 
	*/
	public static function delete_domain($dids, $sp_uid)
	{
		if (!is_array($dids))
		{
			$dids = array($dids);
		}
		$sql = 'delete from domain_bind where uid in (' . implode(',', $dids) . ') && sp_uid = ' . $sp_uid;
		$ret = Dba::write($sql);

		return $ret;
	}

	
	/*
	取某个商户开通的模块列表
	*/
	
	public static function get_pluging_by_uid()
	{
		$sql = 'select  name, dir from weixin_plugins_installed ' .
			'right join weixin_public on weixin_public.uid=weixin_plugins_installed.public_uid ' .
			'where sp_uid=' . AccountMod::get_current_service_provider('uid');

		return Dba::readallAssoc($sql);
	}
	/*
          获取模块访问bt
    */
	public static function get_app_bt($shop_uid = 0)
	{
		if (is_array($shop_uid))
		{
			$shop_uid = http_build_query($shop_uid);
		}
		$bt = Dba::readOne('select group_name from shop_distribution where shop_uid = ' . $shop_uid);

		return $bt;
	}


	/*
		获取模块访问url, 如果有域名绑定,自动选择绑定后的域名
	*/
	public static function get_app_url($app, $sp_uid = 0, $params = '')
	{
		if (!$sp_uid)
		{
			$sp_uid = AccountMod::get_current_service_provider('uid');
		}
		if (is_array($params))
		{
			$params = http_build_query($params);
		}
		if ($sp_uid && ($ho = Dba::readOne('select domain from domain_bind where sp_uid = ' . $sp_uid . ' && bind like "' . $app .
				'.%" order by uid desc'))
		)
		{
			$url = (isHttps() ? 'https://' : 'http://').$ho;
			if(!in_array($_SERVER['SERVER_PORT'], array(80, 443))) {
				$url .= ':'.$_SERVER['SERVER_PORT'];
			}
			if ($params)
			{
				$params .= '&_a='.$app;
				$url .= '?' . $params;
			}

			return $url;
		}

		$url = (isHttps() ? 'https://' : 'http://').$_SERVER['HTTP_HOST'] . '?_a=' . $app . '&__sp_uid=' . $sp_uid;
		if ($params)
		{
			$url .= '&' . $params;
		}

		return $url;
	}
	
	/*
		多域名分布式部署 根据sp_uid分
		最多支持5个不同顶级域名
	*/
	public static function get_all_uct_top_domains()
	{
		return array(
			'uctphp.com' => array('offset_sp_uid' => 0),
			#'uctoo.cn'  => array('offset_sp_uid' => 100),
			#'uctoo.ucloud'  => array('offset_sp_uid' => 200),
			#'uctoo.sae'     => array('offset_sp_uid' => 300),
			#'uctoo.reserve' => array('offset_sp_uid' => 400),
		);
	}
	
	
	/*
		获取sp_uid所属的顶级域名
	*/
	public static function get_top_domain_of_sp_uid($sp_uid)
	{
		$hash = $sp_uid % 500;
		$ds   = self::get_all_uct_top_domains();
		foreach ($ds as $k => $d)
		{
			if ($hash < $d['offset_sp_uid'] + 100)
			{
				return $k;
			}
		}

		die('fatal error! get top domain of sp_uid failed! ' . $sp_uid);
	}

	/*
		是否为主域名 uctphp.com 
	*/
	public static function is_master_top_domain()
	{
		return self::get_current_top_domain() == 'uctphp.com';
	}

	/*
		获取当前机器顶级域名, 
		考虑到内网开发任意配置的情况, 默认取第一个
	*/
	public static function get_current_top_domain()
	{
		if (defined('CURRENT_TOP_DOMAIN') && CURRENT_TOP_DOMAIN)
		{
			return CURRENT_TOP_DOMAIN;
		}

		$d  = getDomainName();
		$td = strtolower(checkString($d, '/[\.\^]([\w+].[\w]+)$/'));
		$ds = self::get_all_uct_top_domains();

		return (!empty($td) && isset($ds[$td])) ? $ds[$td] : key($ds);
	}

	/*
		根据商户sp_uid 分布式部署
	*/
	public static function goto_its_top_domain($sp_uid = 0)
	{
		!$sp_uid && $sp_uid = AccountMod::get_current_service_provider('uid');
		$should_go = self::get_top_domain_of_sp_uid($sp_uid);
		$current   = self::get_current_top_domain();
		if ($current == $should_go)
		{
			return true;
		}

		//客户端未必支持重定向
		redirectTo((isHttps() ? 'https://' : 'http://').'weixin.' . $should_go . '/?' . http_build_query($_GET));
	}

	/*
		取一个符合当前域名的sp_uid, >= $begin_uid
	*/
	public static function get_a_sp_uid_for_current_top_domain($begin_uid = 1)
	{
		$ds     = self::get_all_uct_top_domains();
		$d      = self::get_current_top_domain();
		$offset = isset($ds[$d]['offset_sp_uid']) ? $ds[$d]['offset_sp_uid'] : 0;
		$hash   = $begin_uid % 500;
		if (($hash >= $offset) && ($hash < $offset + 100))
		{
			return $begin_uid;
		}
		else
		{
			return $begin_uid - $hash + 500 + $offset;
		}
	}

	public static function get_allow_plugin_array()
	{
		return array('form.index.index'=>'通用表单',
		             'reward.index.index'=>'通用抽奖',
		             'vote.index.index'=>'通用投票',
		             'shop.index.index'=>'微商城',
		             'site.index.index'=>'微官网',
		             'takeaway.index.index'=>'微外卖',
		             'old.index.index'=>'微医疗',
		             'vipcard.index.index'=>'会员卡',
		             'ticket.index.index'=>'优车票',
		);
	}
}

