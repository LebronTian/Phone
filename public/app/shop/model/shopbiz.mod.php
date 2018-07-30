<?php
/*
	本文件由 *uctphp框架代码半自动生成工具* 自动生成

	中文名： 商家入驻
	类名： ShopBiz

	模块名： shop_biz
	表名： shop_biz
*/

class ShopBizMod {
	public static function func_get_shop_biz($item) {
		unset($item['passwd']);

		if(!empty($item['images'])) $item['images'] = explode(';', $item['images']);
		if(!empty($item['extra_info'])) $item['extra_info'] = json_decode($item['extra_info'], true);
		if(!empty($item['admin_uids'])) $item['admin_uids'] = json_decode($item['admin_uids'],true);

		$item['product_number'] = Dba::readOne('select count(*) from product where shop_uid = '.$item['shop_uid'].' and biz_uid = '.$item['uid'].' && status = 0');
		$item['product_number_all'] = Dba::readOne('select count(*) from product where shop_uid = '.$item['shop_uid'].' and biz_uid = '.$item['uid'].' ');
		$item['coupon_number'] = Dba::readOne('select count(*) from biz_coupon where biz_uid = '.$item['uid'].' && status = 0');
		$item['order_number'] = Dba::readOne('select count(*) from shop_order where shop_uid = '.$item['shop_uid'].' and biz_uid = '.$item['uid']);


		return $item;
	}

	/*
    商家登陆
	*/
	public static function do_admin_login($account, $password) {
		$sql = 'select * from shop_biz where account = "'.addslashes($account).'"';
		$sql2 = 'select shop_biz.*, service_user.passwd as passwd from shop_biz join service_user on shop_biz.su_uid = service_user.uid where service_user.account = "'.addslashes($account).'"';
		if(!($admin = Dba::readRowAssoc($sql)) && !($admin = Dba::readRowAssoc($sql2))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		//验证码
		if(!SafetyCodeMod::check_verify_code()) {
			return false;
		}

		//审核不通过
		if($admin['status'] != 1) {
			return false;
		}

		if(($admin['passwd'] != md5($password))) {
			setLastError(ERROR_INVALID_EMAIL_OR_PASSWD);
			return false;
		}

		//不要把用户删了
		//$_SESSION = array();
		$_SESSION['admin_login'] = $_SESSION['admin_uid'] = $admin['uid'];


		$sql = 'select sp_uid from shop where uid = '.$admin['shop_uid'];
		$sp_uid =  Dba::readOne($sql);
		$_COOKIE['__sp_uid'] = $sp_uid;

//		$update = array('last_time' => $_SERVER['REQUEST_TIME'], 'last_ip' => requestClientIP(), 'status' => $admin['status']);
//		Dba::update('service_provider', $update, 'uid = '.$admin['uid']);

		return array('uid' => $admin['uid'], 'title' => $admin['title'],'sp_uid'=>$sp_uid);
	}

	/*
		添加编辑商家入驻	
	*/
	public static function add_or_edit_shop_biz($i) {
		if(!empty($i['passwd'])) {
			$i['passwd'] = md5($i['passwd']);
		}else{
			unset($i['passwd']);
		}
		if(!empty($i['uid'])) {
			$where = 'uid = '.$i['uid'];
//			if(!empty($i['su_uid'])) $where .= ' && su_uid = '.$i['su_uid'];
			if(!empty($i['shop_uid'])) $where .= ' && shop_uid = '.$i['shop_uid'];
			Dba::update('shop_biz', $i, $where);	
		}	
		else {
			unset($i['uid']);
			!isset($i['create_time']) && $i['create_time'] = $_SERVER['REQUEST_TIME'];

			Dba::insert('shop_biz', $i);	
			$i['uid'] = Dba::insertID();

			$sp_uid = Dba::readOne('select sp_uid from shop where uid = ' . $i['shop_uid']);
			//站内通知
			$msg = array(
				'title' => '微商城 商家入驻提醒 - ['.$i['title'].']',
				'content' => '收到商家入驻提醒<a href="?_a=shop&_u=sp.addbiz&uid=' . $i['uid'] . '">点击查看详情</a> ',
				'sp_uid' => $sp_uid,
			);
			uct_use_app('sp');
			SpMsgMod::add_sp_msg($msg);

		}

		return $i['uid'];
	}

	/*
    检查账号是否被注册
	*/
	public static function check_biz_account($account) {
		$sql = 'select uid from shop_biz where account = "'.addslashes($account).'"';
		return Dba::readOne($sql);
	}


	/*
		取商户状态
	*/
	public static function get_shop_biz_by_su_uid($su_uid, $shop_uid) {
		return Dba::readRowAssoc('select * from shop_biz where shop_uid = '.$shop_uid.
			' && su_uid = '.$su_uid, 'ShopBizMod::func_get_shop_biz');
	}
	public static function get_shop_biz_by_su_uids($su_uid,$shop_uid){
		return Dba::readRowAssoc('select * from shop_biz where shop_uid = '.$shop_uid.
			' && (su_uid = '.$su_uid.'|| admin_uids like "%\"'.$su_uid.'\"%")', 'ShopBizMod::func_get_shop_biz');
	}

	/*
    取商户id
	*/
	public static function get_shop_biz_uid_by_su_uid($su_uid, $shop_uid) {
		return Dba::readOne('select uid from shop_biz where shop_uid = '.$shop_uid.
			' && su_uid = '.$su_uid);
	}

	public static function get_shop_biz_by_uid($uid) {
		return Dba::readRowAssoc('select * from shop_biz where uid = '.$uid, 'ShopBizMod::func_get_shop_biz');
	}

	/*
		 商家入驻数据列表	
	*/
	public static function get_shop_biz_list($option) {
		$sql = 'select * ';
		if(!empty($option['lat'])&&!empty($option['lng'])){
			$sql .= ',(ACOS(SIN(('.$option['lat'].' * 3.1415) / 180 ) *SIN((lat * 3.1415) / 180 ) +COS(('.$option['lat'].' * 3.1415) / 180 ) * COS((lat * 3.1415) / 180 ) *COS(('.$option['lng'].' * 3.1415) / 180 - (lng * 3.1415) / 180 ) ) * 6380) as juli';
		}
		$sql .= ' from shop_biz ';
		
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		//todo
		if(isset($option['status']) && ($option['status'] >= 0)) {
			$where_arr[] = 'status = '.$option['status'];
		}
		if(!empty($option['key'])) {
			$where_arr[] = 'title like "%'.addslashes($option['key']).'%"';
		}
		if(!empty($option['type'])) {
			$where_arr[] = 'type like "'.addslashes($option['type']).'"';
		}
		if(!empty($option['hadv'])) {
			$where_arr[] = 'hadv = 1';
		}
		if(!empty($option['hadrecommend'])) {
			$where_arr[] = 'hadrecommend = 1';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		!isset($option['sort']) && $option['sort'] = 0;
		switch($option['sort']) {
			case 3:
				$order = ' order by hadv desc,juli asc,create_time desc';
				break;
			default: 
				$order = ' order by sort desc, hadv desc, uid desc'; 
		}
		$sql .= $order;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'ShopBizMod::func_get_shop_biz');
	}

	/*
		删除商家入驻
	*/
	public static function delete_shop_biz($uids, $shop_uid) {
		if(!is_array($uids)) $uids = array($uids);
		$sql = 'delete from shop_biz where uid in ('.implode(',', $uids).') && shop_uid = '.$shop_uid;
		return Dba::write($sql);
		//todo 是不是把商品也删掉
	}


	public static function func_get_bizcat($item) {
		$item['title'] = htmlspecialchars($item['title']);
		$item['title_en'] = htmlspecialchars($item['title_en']);

		if(!empty($item['uid'])) $item['children'] = self::get_biz_cats(array('shop_uid' => $item['shop_uid'],'parent_uid'=>$item['uid'],'status'=>0));
		if(!empty($item['uid'])) $item['value'] = $item['uid'];
		if(!empty($item['title'])) $item['text'] = $item['title'];

		return $item;
	}

	public static function func_get_son_biz_cats($item){

		$sql = 'select * from biz_cats where shop_uid = '.$item['shop_uid'].' and parent_uid = '.$item['uid'].' and status = 0';
		$item['son_cats']= Dba::readAllAssoc($sql);
//		var_dump($item);
		return $item;
	}

	/*
	 * 获取所有子分类，并用分号隔开
	 */
	public static function get_all_sons_biz_cats($option){
		$sql = 'select * from biz_cats where shop_uid = '.$option['shop_uid'].' and parent_uid = '.$option['uid'].' and status = 0';
		return Dba::readAllAssoc($sql, 'ShopBizMod::func_get_son_biz_cats');
	}



	/*
		商品分类
		不需要分页
	*/
	public static function get_biz_cats($option) {
		$sql = 'select * from biz_cats';
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		if(isset($option['parent_uid']) && $option['parent_uid'] >= 0) {
			$where_arr[] = 'parent_uid = '.$option['parent_uid'];
		}
		if(!empty($option['had_parent']) && $option['had_parent'] >= 0) {
			$where_arr[] = 'parent_uid > 0 ';
		}
		if(isset($option['status'])) {
			$where_arr[] = 'status = '.$option['status'];
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .= ' order by sort desc, create_time';

		$cats = Dba::readAllAssoc($sql, 'ShopbizMod::func_get_bizcat');

		return $cats;
	}

	/*
		分类详情
	*/
	public static function get_biz_cat_by_uid($uid) {
		$sql = 'select * from biz_cats where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'ShopbizMod::func_get_bizcat');
	}

	public static function add_or_edit_biz_cat($cat) {
		//如果设置父级目录必须为同一个shop_uid
		if(!empty($cat['parent_uid'])) {
			$su = Dba::readOne('select shop_uid from biz_cats where uid = '.$cat['parent_uid']);
			if($su != $cat['shop_uid']) {
				setLastError(ERROR_PERMISSION_DENIED);
				return false;
			}
		}

		if(!empty($cat['uid'])) {
			Dba::update('biz_cats', $cat, 'uid = '.$cat['uid'].' and shop_uid = '.$cat['shop_uid']);
		}
		else {
			$cat['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('biz_cats', $cat);
			$cat['uid'] = Dba::insertID();
		}

		return $cat['uid'];
	}

	/*
		删除分类
		返回删除的条数
	*/
	public static function delete_biz_cat($cids, $shop_uid) {
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'delete from biz_cats where uid in ('.implode(',',$cids).') and shop_uid = '.$shop_uid;

		Dba::beginTransaction(); {
			$ret = Dba::write($sql);
			if($ret) {
				//更新父级分类, 商品分类
				$sql = 'update biz_cats set parent_uid = 0 where parent_uid in ('.implode(',',$cids).') and shop_uid = '.$shop_uid;
				Dba::write($sql);
			}
		} Dba::commit();

		return $ret;
	}


	public static function func_get_fav($item) {
		if($item['biz_uid']) $item['biz'] = ShopBizMod::get_shop_biz_by_uid($item['biz_uid']);
		return $item;
	}
	/*
    判断是否已经添加收藏
	*/
	public static function has_fav($user_id, $biz_uid) {
		return Dba::readOne('select uid from biz_fav where user_id = '.$user_id.' && biz_uid = '.$biz_uid.' limit 1');
	}
	/*
		添加商家到收藏
	*/
	public static function add_or_edit_fav($item) {
		if(!isset($item['uid'])) {
			$item['create_time'] = $_SERVER['REQUEST_TIME'];
			//检查一下重复收藏, 更新一下
			if($uid = self::has_fav($item['user_id'], $item['biz_uid'])) {
				$item['uid'] = $uid;
			}
			else {
				Dba::beginTransaction(); {
					Dba::insert('biz_fav', $item);
					$item['uid'] = Dba::insertID();
					Dba::write('update shop_biz set fav_cnt = fav_cnt + 1 where uid = '.$item['biz_uid']);
				} Dba::commit();
				return $item['uid'];
			}
		}

		Dba::update('biz_fav', $item, 'uid = '.$item['uid']);
		return $item['uid'];
	}

	/*
   		 删除收藏
	*/
	public static function delete_fav($fids, $user_id) {
		if(!is_array($fids)) {
			$fids = array($fids);
		}

		$pids = Dba::readAllOne('select biz_uid from biz_fav where uid in ('.implode(',', $fids).') && user_id = '.$user_id);
		Dba::beginTransaction(); {
			$ret = Dba::write('delete from biz_fav where uid in ('.implode(',', $fids).') && user_id = '.$user_id);
			if($pids) {
				Dba::write('update shop_biz set fav_cnt = fav_cnt - 1 where uid in('.implode(',', $pids).')');
			}
		} Dba::commit();

		return $ret;
	}

	/*
		获取用户店铺收藏列表
	*/
	public static function get_user_fav_list($option) {
		$sql = 'select * from biz_fav';
		if(!empty($option['user_id'])) {
			$where_arr[] = 'user_id= '.$option['user_id'];
		}
		if(!empty($option['biz_uid'])) {
			$where_arr[] = 'biz_uid= '.$option['biz_uid'];
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .= ' order by create_time desc';

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'ShopBizMod::func_get_fav');
	}

	
	/*
		修改入驻商密码
	*/
	public static function change_biz_password($old, $new, $biz_uid) {
		if(!($biz = Dba::readRowAssoc('select uid, passwd from shop_biz where uid = '.$uid))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;	
		}
		if($biz['passwd'] && (md5($old) != $biz['passwd'])) {
			setLastError(ERROR_DBG_STEP_2);
			return false;
		}

		self::add_or_edit_shop_biz(array('passwd' => $new,'uid' => $uid));
		return true;
	}


}




