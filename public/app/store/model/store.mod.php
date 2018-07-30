<?php
/*
	门店管理
*/

class StoreMod {
	public static function func_get_store($item) {
		$item['name'] = htmlspecialchars($item['name']);
		if(!empty($item['brief'])) $item['brief'] = XssHtml::clean_xss($item['brief']);
		if(!empty($item['images'])) $item['images'] = explode(';', $item['images']);

		if(!empty($item['address'])) $item['address'] = htmlspecialchars($item['address']);

		return $item;
	}

	public static function add_or_edit_store($store) {
		if(isset($store['lat'])  && isset($store['lng'])) {
			$store['geohash'] = Geohash::encode($store['lat'], $store['lng']);
		}

		if(!empty($store['uid'])) {
			Dba::update('store', $store, 'uid = '.$store['uid'].' and sp_uid = '.$store['sp_uid']);
		}
		else{
			$store['create_time'] = $_SERVER['REQUEST_TIME'];	
			Dba::insert('store', $store);
			$store['uid'] = Dba::insertID();
		}

		return $store['uid'];
	}

	/*
		删除门店
		返回删除的条数
	*/
	public static function delete_stores($sids, $sp_uid) {
		if(!is_array($sids)) {
			$sids = array($sids);
		}
		$sql = 'delete from store where uid in ('.implode(',',$sids).') and sp_uid = '.$sp_uid;
		return Dba::write($sql);
	}

	public static function get_store_by_uid($uid) {
		$sql = 'select * from store where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'StoreMod::func_get_store');
	}

	/*
		门店列表
	*/
	public static function get_store_list($option) {
		$sql = 'select * from store';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(isset($option['status']) && $option['status'] >= 0) {
			$where_arr[] = 'status = '.$option['status'];
		}
		if(isset($option['geohash'])) { //附近的门店
			$where_arr[] = 'geohash like "'.$option['geohash'].'%"';
		}

		//搜索
		if(!empty($option['key'])) {
			$where_arr[] = '(name like "%'.$option['key'].'%" or brief like "%'.$option['key'].'%" or store_code like "%'.$option['key'].'%")';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		$sort = 'sort desc, create_time desc';
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'StoreMod::func_get_store');
	}

}

