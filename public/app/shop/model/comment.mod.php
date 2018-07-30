<?php

/*
	商品评论和打分
	购买记录
*/

class CommentMod {
	public static function func_get_comment($item) {
//		$item['images'] = explode(';', $item['images']);
		$item['images'] = json_decode($item['images'],true);
		$item['brief'] = htmlspecialchars($item['brief']);
		$item['user'] = AccountMod::get_service_user_by_uid($item['user_id']);
		$item['product'] = ProductMod::get_shop_product_by_uid($item['product_uid']);
		if(Dba::readOne('select count(*) from product_comment where parent_uid ='.$item['uid']) > 0) {
			//取一下商家回复
			$item['replies'] = CommentMod::get_product_comments(array('shop_uid' => $item['shop_uid'],
				'parent_uid' => $item['uid'], 'page' => 0, 'limit' => -1));
		}

		return $item;
	}

	public static function func_get_sell($item) {
		$item['user'] = AccountMod::get_service_user_by_uid($item['user_id']);
		if($item['detail']) $item['detail'] = json_decode($item['detail'], true);
		return $item;
	}

	/*
		获取商品评论
	*/
	public static function get_product_comments($option) {
		$sql = 'select * from product_comment';
		if(!empty($option['biz_uid'])) {
			$where_arr[] = 'product_uid in (select uid from product where shop_uid = '.$option['shop_uid'].' and biz_uid = '.$option['biz_uid'].')';
		}
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		if(!empty($option['user_id'])) {
			$where_arr[] = 'user_id = '.$option['user_id'];
		}
		if(!empty($option['product_uid'])) {
			$where_arr[] = 'product_uid = '.$option['product_uid'];
		}
		if(!empty($option['parent_uid']) && $option['parent_uid'] >= 0) {
			$where_arr[] = 'parent_uid = '.$option['parent_uid'];
		}
		else if(empty($option['all'])) { //通常只要用户列表
			$where_arr[] = 'parent_uid = 0';
		}
		if(isset($option['status']) && $option['status'] >= 0) {
			$where_arr[] = 'status = '.$option['status'];
		}
		//未拒绝的都可以
		if(!empty($option['no_need_check'])) {
			$where_arr[] = 'status < 2';
		}
		

		//搜索
		if(!empty($option['key'])) {
			$where_arr[] = '(brief like "%'.$option['key'].'%")';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sort = 'create_time desc';
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'CommentMod::func_get_comment');
	}

	/*
		添加评论,评星
		只有购买成功过才能评论, 并且只能评论一次

		$pc = array(
				'user_id' => 顾客uid
				'product_uid' => 商品uid
				'order_uid' => 订单uid
				
				'score' => 5, 评星
		)
	*/
	public static function add_product_comment($pc) {
		$sql = 'select 1 from product_comment where product_uid = '.$pc['product_uid'].' && order_uid = '.$pc['order_uid']
				.' && user_id = '.$pc['user_id'].' limit 1';
		//只能评论一次
		if(Dba::readOne($sql)) {
			setLastError(ERROR_OBJECT_ALREADY_EXIST);
			return false;
		}

		//只有购买过才能评论
		$sql = 'select 1 from product_sell where product_uid = '.$pc['product_uid'].' && order_uid = '.$pc['order_uid']
				.' && user_id = '.$pc['user_id'].' limit 1';
		if(!Dba::readOne($sql)) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		$pc['create_time'] = $_SERVER['REQUEST_TIME'];
		Dba::beginTransaction(); {
			Dba::insert('product_comment', $pc);
			$pc['uid'] = Dba::insertID();
			//更新评论打分数目
			$sql = 'update product set comment_cnt = comment_cnt + 1, score_cnt = score_cnt + 1, score_total = score_total + '.
					$pc['score'].' where uid = '.$pc['product_uid'];
			Dba::write($sql);
			//更新订单状态
			$sql = 'update shop_order set status = '.OrderMod::ORDER_COMMENT_OK.' where uid = '.$pc['order_uid'].
					' && status = '.OrderMod::ORDER_DELIVERY_OK;
			Dba::write($sql);
		} Dba::commit();

		//todo 发个通知消息给商户
			
		return $pc['uid'];
	}

	/*
		编辑评论
	*/
	public static function edit_comment($c) {
		return Dba::update('product_comment', $c, 'uid = '.$c['uid']);
	}


	/*
		确认收货后增加购买记录
	*/
	public static function onAfterRecvOrder($order) {
		$inserts = array();
		foreach($order['products'] as $p) {
			$sp = ProductMod::get_shop_product_by_sku_uid($p['sku_uid']);
			if($sp) {
			$insert = array('order_uid' => $order['uid'],
							'shop_uid' => $order['shop_uid'],
							'product_uid' => current(explode(';', $p['sku_uid'])),
							'user_id' => $order['user_id'],
							'create_time' => $_SERVER['REQUEST_TIME'],
							'paid_price' => $sp['price'],
							'quantity' => $p['quantity'],
							'detail' => array('sku_uid' => $p['sku_uid']),
			);
			$inserts[] = $insert;
			}
		}

		Dba::insertS('product_sell', $inserts);
		return true;
	}

	/*
		获取商品成交记录
	*/
	public static function get_product_sell($option) {
		$sql = 'select * from product_sell';
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		if(!empty($option['product_uid'])) {
			$where_arr[] = 'product_uid = '.$option['product_uid'];
		}
		if(!empty($option['user_id'])) {
			$where_arr[] = 'user_id = '.$option['user_id'];
		}
		if(!empty($option['min_time'])) {
			$where_arr[] = 'create_time >= '.$option['min_time'];
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sort = 'create_time desc';
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'CommentMod::func_get_sell');
	}

	/*
    回复消息
	*/
	public static function reply_comment($m) {
		if(!($msg = self::get_shop_comment_by_uid($m['parent_uid'])) ||
			$msg['shop_uid'] != $m['shop_uid']) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		$m['create_time'] = $_SERVER['REQUEST_TIME'];
		Dba::beginTransaction(); {
			Dba::insert('product_comment', $m);
			$m['uid'] = Dba::insertID();
//			Dba::write('update product_comment set reply_cnt = reply_cnt + 1 where uid = '.$m['parent_uid']);
		} Dba::commit();

		return $m['uid'];
	}

	/*
	回复消息
	*/
	public static function add_comment($m) {

		$m['create_time'] = $_SERVER['REQUEST_TIME'];
		Dba::beginTransaction(); {
			Dba::insert('product_comment', $m);
			$m['uid'] = Dba::insertID();
//			Dba::write('update product_comment set reply_cnt = reply_cnt + 1 where uid = '.$m['parent_uid']);
		} Dba::commit();

		return $m['uid'];
	}

	/*
    删除评论
    返回删除的条数
	*/
	public static function delete_comment($mids, $shop_uid) {
		if(!is_array($mids)) {
			$mids = array($mids);
		}
		$cnt = 0;
		Dba::beginTransaction(); {
			foreach($mids as $uid) {
//				if(!$m = Dba::readRowAssoc('select parent_uid from product_comment where uid = '.$uid.' && shop_uid = '.$shop_uid)) {
//					continue;
//				}
				$sql = 'delete from product_comment where uid = '.$uid;
				Dba::write($sql);
				//删除回复
				$sql = 'delete from product_comment where parent_uid = '.$uid;
				Dba::write($sql);
//				if($m['parent_uid']) {
//					//更新评论数
//					$sql = 'update product_comment set reply_cnt = reply_cnt - 1 where uid = '.$m['parent_uid'];
//					Dba::write($sql);
//				}
				$cnt++;
			}
		} Dba::commit();

		return $cnt;
	}

	/*
    评论审核,支持批量
    返回影响的条数
	*/
	public static function review_comment($cids, $status, $shop_uid) {
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'update product_comment set status = '.$status.' where uid in ('.implode(',',$cids).') and shop_uid = '.$shop_uid;
		$ret = Dba::write($sql);

		return $ret;
	}

	/*
	 * 获取评论
	 */
	public static function get_shop_comment_by_uid($uid) {
		return Dba::readRowAssoc('select * from product_comment where uid = '.$uid, 'CommentMod::func_get_comment');
	}

	/*
	*/
	public static function get_comment_cfg($shop_uid) {
		$key = 'shop_comment_'.$shop_uid;
		if(!isset($GLOBALS['arraydb_sys'][$key])) {
			$cfg = array(
					'need_check' => 1, //需要审核
			);
		} else {
			$cfg = json_decode($GLOBALS['arraydb_sys'][$key], true);
		}
		return $cfg;
	}

	public static function set_comment_cfg($shop_uid, $cfg) {
		$key = 'shop_comment_'.$shop_uid;
		if(is_array($cfg)) $cfg = json_encode($cfg);
		return	$GLOBALS['arraydb_sys'][$key] = $cfg;
	}

	/*获取店铺对应评论积分*/
	public static function get_comment_point_by_shop_uid($shop_uid){
		$sql = 'select * from shop_comment_point where shop_uid ='.$shop_uid;
		if(!($point = Dba::readRowAssoc($sql))){
			return false;
		} else{
			// var_dump($point);die;
			return $point;
		}
	}


	/*设置审核通过评论获得积分*/
	public static function set_comment_point($shop_uid,$text_point,$img_point){
		// var_dump($shop_uid);die;
		
		// var_dump($sql);die;
		if(!($shop_id = isset($shop_uid) ? '0': $shop_uid)){
			 if(!($shop_id = Dba::readOne('select shop_uid from shop_comment_point where shop_uid ='.$shop_uid))){
			 		
			 		if(!Dba::write('insert into shop_comment_point (shop_uid,text_point,img_point) values('.$shop_uid.','.$text_point.','.$img_point.')')){
			 			return false;
			 		}
			 
			 } else {
			 		// echo 1;die;
			 		// var_dump('update shop_comment_point set text_point ='.$text_point.',img_point ='.$img_point.' where shop_uid ='.$shop_id);die;
			 		if(!Dba::write('update shop_comment_point set text_point ='.$text_point.',img_point ='.$img_point.' where shop_uid ='.$shop_id)) {
			 		return false;
					
				}

			}
		
		
		}


	}

	/*设置用户积分*/
	 public static function change_user_point($point,$comment,$status){
	 	// var_dump('update user_points set point_remain = point_remain+'.$point['img_point'].' where su_uid ='.$comment['user']['uid']);die;
		if($comment['status'] == 0 && $status == 1){
			/*判断是否带图评论*/
			if(empty($comment['images'])){
		 		Dba::write('update user_points set point_remain = point_remain+'.$point['text_point']);
		 	} else{
		 		Dba::write('update user_points set point_remain = point_remain+'.$point['img_point']);
		 	}

		} else if($comment['status'] == 1 && $status == 20){

			/*判断是否带图评论*/
		 	if(empty($comment['images'])){
		 		Dba::write('update user_points set point_remain = point_remain-'.$point['text_point']);
		 	} else{
		 		Dba::write('update user_points set point_remain = point_remain-'.$point['img_point']);
		 	}
			
		} else if($comment['status'] == 20 && $status == 1){
			/*判断是否带图评论*/
		 	if(empty($comment['images'])){
		 		Dba::write('update user_points set point_remain = point_remain+'.$point['text_point']);
		 	} else{
		 		Dba::write('update user_points set point_remain = point_remain+'.$point['img_point']);
		 	}


		}

		
		
	}

}

