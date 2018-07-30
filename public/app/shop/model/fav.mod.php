<?php

/*
	收藏(关注),推荐商品, 类似商品
*/
class FavMod {
	public static function func_get_fav($item) {
		if($item['product_uid']) $item['product'] = ProductMod::get_shop_product_by_uid($item['product_uid']);
		return $item;
	}


	/*
		判断是否已经添加收藏 
	*/
	public static function has_fav($user_id, $product_uid) {
		return Dba::readOne('select uid from product_fav where user_id = '.$user_id.' && product_uid = '.$product_uid.' limit 1');
	}

	/*
		添加商品到收藏
	*/
	public static function add_or_edit_fav($item) {
		if(!isset($item['uid'])) {
			$item['create_time'] = $_SERVER['REQUEST_TIME'];
			//检查一下重复收藏, 更新一下
			if($uid = self::has_fav($item['user_id'], $item['product_uid'])) {
				$item['uid'] = $uid;
			}
			else {
				Dba::beginTransaction(); {
					Dba::insert('product_fav', $item);
					$item['uid'] = Dba::insertID();
					Dba::write('update product set fav_cnt = fav_cnt + 1 where uid = '.$item['product_uid']);
				} Dba::commit();
				return $item['uid'];
			}
		}

		Dba::update('product_fav', $item, 'uid = '.$item['uid']);
		return $item['uid'];
	}

	/*
		删除收藏	
	*/
	public static function delete_fav($fids, $user_id) {
		if(!is_array($fids)) {
			$fids = array($fids);
		}

		$pids = Dba::readAllOne('select product_uid from product_fav where uid in ('.implode(',', $fids).') && user_id = '.$user_id);	
		Dba::beginTransaction(); {
			$ret = Dba::write('delete from product_fav where uid in ('.implode(',', $fids).') && user_id = '.$user_id);	
			if($pids) {
				Dba::write('update product set fav_cnt = fav_cnt - 1 where uid in('.implode(',', $pids).')');
			}
		} Dba::commit();
		
		return $ret;
	}

	/*
		删除收藏商品	
	*/
	public static function delete_fav_product($pids, $user_id) {
		if(!is_array($pids)) {
			$pids = array($pids);
		}

		$pids = Dba::readAllOne('select product_uid from product_fav where user_id = '.$user_id.' && product_uid in ('.implode(',', $pids).')');
		if(!$pids) {
			return 0;
		}

		Dba::beginTransaction(); {
			$ret = Dba::write('delete from product_fav where  user_id = '.$user_id.' && product_uid in ('.implode(',', $pids).')');
			Dba::write('update product set fav_cnt = fav_cnt - 1 where uid in('.implode(',', $pids).')');
		} Dba::commit();
		
		return $ret;
	}

	/*	
		获取用户收藏列表
	*/
	public static function get_user_fav_list($option) {
		$sql = 'select * from product_fav';
		if(!empty($option['user_id'])) {
			$where_arr[] = 'user_id= '.$option['user_id'];
		}
		if(!empty($option['product_uid'])) {
			$where_arr[] = 'product_uid= '.$option['product_uid'];
		}
		if(isset($option['notify_price']) && $option['notify_price'] >= 0) { //降价通知
			$where_arr[] = 'notify_price >= '.$option['notify_price'];
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .= ' order by create_time desc';

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'FavMod::func_get_fav');
	}


	/*
		推荐商品, 类似商品,猜你喜欢 todo
	*/
	public static function suggest_products($option) {
		//类似商品
		if(!empty($option['product_uid']) &&
			$p = ProductMod::get_shop_product_by_uid($option['product_uid'])) {
			$option['cat_uid'] = $p['cat_uid'];
			$ukeys = array();
			foreach(array('分类', '行业', '型号') as $v) {
				if(!empty($P['extra_info'][$v])) {
					$ukeys[$k] = stripcslashes($p['extra_info'][$v]);
				}	
			}
			$option['ukeys'] = $ukeys;
			$option['exclude_uids'] = array($option['product_uid']);
		}

		return ProductMod::get_shop_products($option);
	}

}

