<?php
/*
	商户子账号
*/

class  SubspMod {
	public static function func_get_subsp($item) {
		unset($item['passwd']);
		//if(!empty($item['access_rule'])) $item['access_rule'] = json_decode($item['access_rule'], true);
		if(!empty($item['uct_tokens'])) $item['uct_tokens'] = json_decode($item['uct_tokens']);

		//门店列表
		$item['store_uids'] = SubspMod::get_subsp_access_store_uids($item['uid']);
		$item['access_rule'] = SpInviteMod::get_access('access_'.$item['sp_uid'].'_'.$item['uid']);

		return $item;
	}
	
	/*
		检查子账号是否登陆, 通过$_SESSION['subsp_login']进行判断
	*/
	public static function has_subsp_login() {
		return AccountMod::has_subsp_login();
	}

	/*
		子账号登陆	
	*/
	public static function do_subsp_login($account, $password) {
		$sql = 'select * from sub_sp where account = "'.addslashes($account).'"';
		if(!($subsp = Dba::readRowAssoc($sql))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		//验证码
		if(!SafetyCodeMod::check_verify_code()) {
			return false;
		}

		//账号被锁定
		if(!($subsp = self::check_subsp_status($subsp))) {
			return false;
		}

		if(($subsp['passwd'] != md5($password))) {
			self::try_disable_subsp_1_hour($subsp['uid']);
			setLastError(ERROR_INVALID_EMAIL_OR_PASSWD);
			return false;
		}

		//$_SESSION = array();
		$_SESSION['sp_login'] = $_SESSION['sp_uid'] = $subsp['sp_uid'];
		$_SESSION['subsp_login'] = $_SESSION['subsp_uid'] = $subsp['uid'];
		if($subsp['uct_token']) {
			$_SESSION['uct_token'] = $subsp['uct_token'];
		}
		else {
			unset($_SESSION['uct_token']);
		}
	
		$update = array('last_time' => $_SERVER['REQUEST_TIME'], 'last_ip' => requestClientIP(), 'status' => $subsp['status']);
		Dba::update('sub_sp', $update, 'uid = '.$subsp['uid']);
		Event::handle('AfterSubspLogin');

		return array('uid' => $subsp['uid'], 'name' => $subsp['name']);
	}

	/*
		检查子账号状态
		成功返回$subsp,失败返回false
		会自动解除锁定状态	
	*/
	public static function check_subsp_status($subsp) {
		if(is_numeric($subsp)) {
			if(!($subsp = Dba::readRowAssoc('select * from sub_sp where uid = '.$subsp))) {
				setLastError(ERROR_OBJ_NOT_EXIST);
				return false;
			}
		}
		if($subsp['status'] >= 60) {
			if(($subsp['last_time'] + 3600) >= $_SERVER['REQUEST_TIME']) {
				setLastError(ERROR_DENYED_FOR_SAFETY);
				return false;
			}
			else {
				$subsp['status'] -= 60;
			}
		}
		if($subsp['status'] > 1) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		return $subsp;
	}

	/*
		锁定子账号1小时, 禁止登陆

		5分钟内连续10次出错才禁止账号
		$failcnt 出错次数
	*/
	public static function try_disable_subsp_1_hour($uid, $failcnt = 1) {
		$key = 'failsubsp_'.$uid;
		if(!($old = $GLOBALS['arraydb_sys'][$key])) {
			$old = 0;
		}
		$old += $failcnt;
		$GLOBALS['arraydb_sys'][$key] = array('expire' => 300, 'value' => $old);
		if($old < 10) {
			return 0;
		}

		$sql = 'update sub_sp set status = if(status < 60, status + 60, status), last_time = '.$_SERVER['REQUEST_TIME']
				.' where uid = '.$uid;
		Dba::write($sql);

		return Dba::affectedRows();
	}

	/*
		解除锁定子账号1小时,
	*/
	public static function enable_subsp_1_hour($uid) {
		$sql = 'update sub_sp set status = if(status >= 60, status - 60, status), last_time = '.$_SERVER['REQUEST_TIME']
				.' where uid = '.$uid;
		Dba::write($sql);

		return Dba::affectedRows();
	}

	/*
		检查子账号是否被注册
		@return true 是一个商户账号, $uid是一个子账号, false 账号不存在
	*/
	public static function check_subsp_account($account) {
		$sql = 'select uid from service_provider where account = "'.addslashes($account).'"';
		if(Dba::readOne($sql)) {
			return true;
		}

		$sql = 'select uid from sub_sp where account = "'.addslashes($account).'"';
		return Dba::readOne($sql);
	}

	
	/*
		子账号修改密码
	*/
	public static function change_subsp_password($old, $new, $uid = 0, $sp_uid = 0) {
		if(!$uid && !($uid = self::has_subsp_login())) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}
		if(!$sp_uid) {
			$sp_uid = AccountMod::get_current_service_provider('uid');
		}
		if(!($subsp = Dba::readRowAssoc('select uid, passwd from sub_sp where uid = '.$uid))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;	
		}
		if($subsp['passwd'] && (md5($old) != $subsp['passwd'])) {
			setLastError(ERROR_DBG_STEP_2);
			return false;
		}

		self::add_or_edit_subsp(array('passwd' => $new, 'uid' => $uid, 'sp_uid' => $sp_uid));
		return true;
	}

	/*
		创建或编辑子账号
		$subsp['sp_uid'] 必须存在，否则会出错
	*/
	public static function add_or_edit_subsp($subsp) {
		if(isset($subsp['store_uids'])) {
			$store_uids = $subsp['store_uids'];
			unset($subsp['store_uids']);
		}
		if(isset($subsp['access_rule'])) {
			$access_rule = $subsp['access_rule'];
			unset($subsp['access_rule']);
		}

		if(!empty($subsp['uid'])) {
			if(!empty($subsp['account'])) {
				if(self::check_subsp_account($subsp['account'])) {
					unset($subsp['account']);
				}
			}
			if(isset($subsp['passwd'])) {
				$subsp['passwd'] = md5($subsp['passwd']);
			}

			Dba::update('sub_sp', $subsp, 'uid = '.$subsp['uid'].' && sp_uid = '.$subsp['sp_uid']);
		}
		else {
			if(self::check_subsp_account($subsp['account'])) {
				setLastError(ERROR_OBJECT_ALREADY_EXIST);
				return false;
			}
			$cnt = Dba::readOne('select count(*) from sub_sp where sp_uid = '.$subsp['sp_uid']);
			$max_cnt = SpLimitMod::get_current_max_subsp_cnt($subsp['sp_uid']);
			if($max_cnt && $cnt >= $max_cnt) {
				setLastError(ERROR_OUT_OF_LIMIT);
				return false;
			}
			
			$subsp['passwd'] = md5($subsp['passwd']);
			$subsp['create_time'] = $_SERVER['REQUEST_TIME'];
			unset($subsp['uid']);
			Dba::insert('sub_sp', $subsp);
			$subsp['uid'] = Dba::insertID();
		}

		if(isset($store_uids)) self::set_subsp_access_store_uids($store_uids, $subsp['uid']);
		if(isset($access_rule)) SpInviteMod::set_access($access_rule, 'access_'.$subsp['sp_uid'].'_'.$subsp['uid']);
		return $subsp['uid'];
	}

	public static function get_subsp_by_uid($uid) {
		return Dba::readRowAssoc('select * from sub_sp where uid = '.$uid, 'SubspMod::func_get_subsp');
	}

	public static function get_subsp_list($option) {
		$sql = 'select * from sub_sp';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		return Dba::readAllAssoc($sql, 'SubspMod::func_get_subsp');
	}
	
	/*
		删除子账号
	*/
	public static function delete_subsp($uids, $sp_uid) {
		if(!is_array($$uids)) {
			$uids = array($uids);
		}

		$sql = 'delete from sub_sp where uid in ('.implode(',',$uids).') && sp_uid = '.$sp_uid;
		return Dba::write($sql);
	}

	/*
		取商户所有后台菜单列表
	*/
	public static function get_all_sp_menu_array_of_sp_uid($sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}
		if((!$uids = Dba::readAllOne('select uid from weixin_public where sp_uid = '.$sp_uid))) {
			return array();
		} 
		$apps = Dba::readAllAssoc('select distinct(dir) as dir, name from weixin_plugins_installed where public_uid in('.implode(',', $uids).')'); 
		!$apps && $apps = array();
		array_unshift($apps, array('dir' => 'sp', 'name' => '首页'));
		
		$ret = array();
		foreach($apps as $app) {
			$ret[] = array( 'dir' => $app['dir'], 		
							'name' => $app['name'], 
							'menus' => self::get_sp_menu_array_of_app($app['dir']));
		}

		return $ret;
	}

	/*
		获取某个插件的后台菜单数组, 通过正则表达式方式获取 get_menu_array 函数的返回值
	*/
	public static function get_sp_menu_array_of_app($app) {
		$file = ($app == 'sp' ? 'index' : 'sp').'.ctl.php';
		$path = UCT_PATH.'app'.DS.$app.DS.'control'.DS.$file;
		if(!file_exists($path)) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		$pattern = '/public\s+function\s+get_menu_array\s*\(.*?\)\s*\{([^\}]*?)\}/';
		if(!$code = checkString(file_get_contents($path), $pattern)) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		if(!$menu = eval($code)) {
			return array();
		}
		$ret = array();
		foreach($menu as $m) {
			if(isset($m['menus'])) {
				foreach($m['menus'] as $mm) {
					$ret[] = array('name' => $mm['name'], 'url' => $app.'.'.$mm['activeurl']);
				}
			}
			else {
				$ret[] = array('name' => $m['name'], 'url' => $app.'.'.$m['activeurl']);
			}
		}
		return $ret;
	}

	
	/*
		设置子账号允许管理门店列表
	*/
	public static function set_subsp_access_store_uids($store_uids, $subsp_uid) {
		$key = 'access_store_uids_'.$subsp_uid;
		if(empty($store_uids)) {
			unset($GLOBALS['arraydb_sys'][$key]);
			return array();
		}
		else {
			if(is_array($store_uids)) $store_uids = json_encode($store_uids);
			return $GLOBALS['arraydb_sys'][$key] = $store_uids;
		}
	}

	/*
		允许门店列表
		空表示不限制
	*/
	public static function get_subsp_access_store_uids($subsp_uid = 0) {
		if(!$subsp_uid && !($subsp_uid = AccountMod::has_subsp_login())) {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}

		$key = 'access_store_uids_'.$subsp_uid;
		if(!isset($GLOBALS['arraydb_sys'][$key]) ||
			!($access = json_decode($GLOBALS['arraydb_sys'][$key], true))) {
			return false;
		}

		return $access;
	}

	/*
		子账号 更精细的检查访问权限
	*/
	public static function checkActionPermission($subsp_uid = 0) {
		if($GLOBALS['_UCT']['APP'] != 'subsp') {
			unset($GLOBALS['_UCT']['autoload'][array_search('subsp', $GLOBALS['_UCT']['autoload'])]);	
		}

		if(!$subsp_uid && !($subsp_uid = AccountMod::has_subsp_login())) {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}
		
		/*
			门店管理
		*/
		if(($GLOBALS['_UCT']['APP'] == 'store') && 
		   ($store_uids = self::get_subsp_access_store_uids($subsp_uid))) {
			//编辑查看页  只能看指定门店
			if(in_array($GLOBALS['_UCT']['ACT'], array('addstore'))) {
				if(($s = requestInt('uid')) && !in_array($s, $store_uids)) {
					unset($_REQUEST['uid']);
					return false;
				}
			}

			//优惠券 只能看指定门店
			if(in_array($GLOBALS['_UCT']['ACT'], array('couponecharts', 'usercoupon', 'storecoupon'))) {
				if($s = requestInt('store_uid')) {
					if(!in_array($s, $store_uids)) {
						//unset($_REQUEST['store_uid']);
						$_REQUEST['store_uid'] = $store_uids[0];
						return false;
					}
				}
				else {
					$_REQUEST['store_uid'] = $store_uids[0];
				}
			}
		} //end of store

	}
	
}

