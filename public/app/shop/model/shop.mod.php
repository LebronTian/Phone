<?php

class ShopMod {
	public static function func_get_shop($item) {
		$item['title'] = htmlspecialchars($item['title']);
		$item['notice'] = htmlspecialchars($item['notice']);
		return $item;
	}

	public static function func_get_message($item) {
		$item['brief'] = XssHtml::clean_xss($item['brief']);
		if(!empty($item['extra_info'])) $item['extra_info'] = json_decode($item['extra_info'], true);
		if($item['user_id']) $item['user'] = AccountMod::get_service_user_by_uid($item['user_id']);
		if($item['reply_cnt'] > 0) {
			//取一下商家回复
			$item['replies'] = ShopMod::get_shop_messages(array('shop_uid' => $item['shop_uid'], 
									'parent_uid' => $item['uid'], 'page' => 0, 'limit' => -1));
		}
		return $item;
	}

	/*
		获取店铺信息
		
		如果网站不存在或已经下线,将返回false

		通过$_GET['shop_uid'] 或 $_GET['sp_uid']来确定
	*/
	public static function get_shop() {
		if($shop_uid = requestInt('shop_uid')) {
			$shop = Dba::readRowAssoc('select * from shop where uid = '.$shop_uid, 'ShopMod::func_get_shop');
		}
		else if($sp_uid = AccountMod::require_sp_uid()) {
			$shop = self::get_shop_by_sp_uid($sp_uid);
		}
		else {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}

		if($shop['status']) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		
		return $shop;
	}

	/*
		获取商家店铺信息
	*/
	public static function get_shop_by_sp_uid($sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))&&!($sp_uid = AccountMod::require_sp_uid())) {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}

		$sql = 'select * from shop where sp_uid = '.$sp_uid;
//		echo "$sql";
		if(!($shop = Dba::readRowAssoc($sql, 'ShopMod::func_get_shop'))) {
			$shop = array('sp_uid' => $sp_uid,
						  'title' => AccountMod::get_current_service_provider('name').'',
		            	  'create_time' => $_SERVER['REQUEST_TIME'],
					);
			Dba::insert('shop', $shop);
			$shop = Dba::readRowAssoc($sql, 'ShopMod::func_get_shop');
		}
	
		return $shop;
	}

	/*
		店铺设置
	*/
	public static function set($shop) {
		Dba::update('shop', $shop, 'uid = '.$shop['uid']);

		return $shop['uid'];
	}

	/*
		幻灯片
		不需要分页
	*/
	public static function get_shop_slides($option) {
		$sql = 'select * from shop_slides';	
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		if(isset($option['status']) && ($option['status'] >= 0)) {
			$where_arr[] = 'status = '.$option['status'];
		}
		if(isset($option['slides_in']) && ($option['slides_in'] >= 0)) {
			$where_arr[] = 'slides_in = '.$option['slides_in'];
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .= ' order by sort desc, create_time';

		return Dba::readAllAssoc($sql);
	}

	/*
		幻灯片详情
	*/
	public static function get_shop_slide_by_uid($uid) {
		$sql = 'select * from shop_slides where uid = '.$uid;
		return Dba::readRowAssoc($sql);
	}
	/*
		幻灯片
	*/
	public static function add_or_edit_slide($slide) {
		if(!empty($slide['uid'])) {
			Dba::update('shop_slides', $slide, 'uid = '.$slide['uid']);
		}
		else {
			$slide['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('shop_slides', $slide);
			$slide['uid'] = Dba::insertID();
		}

		return $slide['uid'];
	}

	/*
		删除分类
		返回删除的条数
	*/
	public static function delete_slides($sids, $shop_uid) {
		if(!is_array($sids)) {
			$sids = array($sids);
		}
		$sql = 'delete from shop_slides where uid in ('.implode(',',$sids).') and shop_uid = '.$shop_uid;
		$ret = Dba::write($sql);

		return $ret;
	}

	public static function get_shop_message_by_uid($uid) {
		return Dba::readRowAssoc('select * from shop_messages where uid = '.$uid, 'ShopMod::func_get_message');
	}

	/*
		评论列表
	*/
	public static function get_shop_messages($option) {
		$sql = 'select * from shop_messages';	
				
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		if(!empty($option['user_id'])) {
			$where_arr[] = 'user_id= '.$option['user_id'];
		}
		if(!empty($option['parent_uid']) && $option['parent_uid'] >= 0) {
			$where_arr[] = 'parent_uid= '.$option['parent_uid'];
		}
		else if(empty($option['all'])) { //通常只要用户列表
			$where_arr[] = 'parent_uid = 0';
		}

		if(isset($option['status']) && ($option['status'] >= 0)) {
			$where_arr[] = 'status = '.$option['status'];
		}

		//搜索
		if(!empty($option['key'])) {
			$where_arr[] = '(brief like "%'.$option['key'].'%")';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		$sql .= ' order by create_time desc';

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'ShopMod::func_get_message');
	}

	/*
		微商城留言 
	*/
	public static function add_or_edit_message($m) {
		if(!empty($m['uid'])) {
			Dba::update('shop_messages', $m, 'uid = '.$m['uid'].' and shop_uid = '.$m['shop_uid']);
		}
		else {
			$m['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('shop_messages', $m);
			$m['uid'] = Dba::insertID();
		
			//微商城留言提醒
			$shop = self::get_shop();
			$sp_uid = $shop['sp_uid'];
			$msg = array(
						'title'   => '微商城 用户留言提醒',
						'content' => '您的微商城收到了新的留言, 快去看看吧. <a href="?_a=shop&_u=sp.messagelist">点击查看</a>',
						'sp_uid'  => $sp_uid, 
			);
			uct_use_app('sp');
			SpMsgMod::add_sp_msg($msg);
		}

		return $m['uid'];
	}

	/*
		回复消息
	*/
	public static function reply_message($m) {
		if(!($msg = self::get_shop_message_by_uid($m['parent_uid'])) ||
			$msg['shop_uid'] != $m['shop_uid']) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		$m['create_time'] = $_SERVER['REQUEST_TIME'];
		Dba::beginTransaction(); {
			Dba::insert('shop_messages', $m);
			$m['uid'] = Dba::insertID();
			Dba::write('update shop_messages set reply_cnt = reply_cnt + 1 where uid = '.$m['parent_uid']);
		} Dba::commit();
		
		return $m['uid'];
	}

	/*
		删除评论
		返回删除的条数
	*/
	public static function delete_message($mids, $shop_uid) {
		if(!is_array($mids)) {
			$mids = array($mids);
		}
		
		$cnt = 0;
		Dba::beginTransaction(); {
			foreach($mids as $uid) {
				if(!$m = Dba::readRowAssoc('select parent_uid from shop_messages where uid = '.$uid.' && shop_uid = '.$shop_uid)) {
					continue;
				}
				$sql = 'delete from shop_messages where uid = '.$uid;
				Dba::write($sql);
				//删除回复
				$sql = 'delete from shop_messages where parent_uid = '.$uid;
				Dba::write($sql);
				if($m['parent_uid']) {
					//更新评论数
					$sql = 'update shop_messages set reply_cnt = reply_cnt - 1 where uid = '.$m['parent_uid'];
					Dba::write($sql);
				}
				$cnt++;
			}
		} Dba::commit();

		return $cnt;
	}

	/*
		评论审核,支持批量
		返回影响的条数
	*/
	public static function review_message($cids, $status, $shop_uid) {
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'update shop_messages set status = '.$status.' where uid in ('.implode(',',$cids).') and shop_uid = '.$shop_uid;
		$ret = Dba::write($sql);

		return $ret;
	}

	public static function add_shop_visit_record($visit_record)
	{
		$visit_record['create_time'] = $_SERVER['REQUEST_TIME'];
		$visit_record['user_ip'] = requestClientIP();
		return Dba::insert('shop_visit_record',$visit_record);
	}

	public static function get_user_good($su_uid){
		$sql = 'select me_uid from shop_message_good';
		if(!empty($su_uid)) {
			$where_arr[] = 'su_uid = '.$su_uid;
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$good = Dba::readAllOne($sql);
		return $good;
	}
	//检测是否点赞-点赞
	public static function set_good_by_id($option,$option2){
		$sql = 'select * from shop_message_good';
		if(!empty($option['me_uid'])) {
			$where_arr[] = 'me_uid = '.$option['me_uid'];
		}
		if(!empty($option['su_uid'])) {
			$where_arr[] = 'su_uid = '.$option['su_uid'];
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$good = Dba::readOne($sql);

		if(empty($good)){
			Dba::update('shop_messages', $option2, 'uid = '.$option['me_uid']);
			Dba::insert('shop_message_good', $option);
			$option['uid'] = Dba::insertID();
		}else{
			$option['uid'] = 0;
		}

		return $option['uid'];
	}


	public static function func_get_index($item) {

		if(!empty($item['mks'])) $item['mks'] = json_decode($item['mks'], true);

		return $item;
	}

	//首页
	public static function get_index($shop_uid){

		return Dba::readRowAssoc('select * from shop_index where shop_uid = '.$shop_uid, 'ShopMod::func_get_index');
	}
	//编辑首页
	public static function set_index($option){
		if(empty($option['uid'])){
			$option['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('shop_index', $option);
			$option['uid'] = Dba::insertID();
		}else{
			Dba::update('shop_index', $option, 'uid = '.$option['uid']);
		}
		return $option['uid'];

	}

	public static function func_index_set($item){
		if(!empty($item['content'])) $item['content'] = json_decode($item['content'],true);

		return $item;
	}
	public static function get_index_set($sp_uid){
		return Dba::readRowAssoc('select * from shop_index_set where sp_uid = '.$sp_uid,'ShopMod::func_index_set');
	}
	/*
	 * 设置页面信息
	 */
	public static function add_or_edit_index_set($data)
	{
		if($uid = Dba::readOne('select uid from shop_index_set where sp_uid ='.$data['sp_uid'])){
			Dba::update('shop_index_set', $data, 'uid = '.$uid);
		}else{
			$data['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('shop_index_set',$data);
			$uid = Dba::insertID();
		}
		return $uid;
	}

}

