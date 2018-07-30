<?php
/*
	本文件由 *uctphp框架代码半自动生成工具* 自动生成

	中文名： 预约项目
	类名： BookItem

	模块名： book_item
	表名： book_item
*/

class BookItemMod {
	public static function func_get_book_item($item) {
		//todo
		if(!empty($item['store_uid'])) {
			$item['store'] = StoreMod::get_store_by_uid($item['store_uid']);
		}
		return $item;
	}

	//获取分类
	public static function get_book_item_type($sp_uid) {
		return Dba::readAllOne('select distinct(type) from book_item where sp_uid = '.$sp_uid);
	}

	/*
		添加编辑预约项目	
	*/
	public static function add_or_edit_book_item($i) {
		if(!empty($i['uid'])) {
			Dba::update('book_item', $i, 'uid = '.$i['uid'].' && sp_uid = '.$i['sp_uid']);	
		}	
		else {
			unset($i['uid']);
			!isset($i['create_time']) && $i['create_time'] = $_SERVER['REQUEST_TIME'];

			Dba::insert('book_item', $i);	
			$i['uid'] = Dba::insertID();
		}

		return $i['uid'];
	}
	
	public static function get_book_item_by_uid($uid) {
		uct_use_app('store');
		return Dba::readRowAssoc('select * from book_item where uid = '.$uid, 'BookItemMod::func_get_book_item');
	}

	/*
		 预约项目数据列表	
	*/
	public static function get_book_item_list($option) {
		$sql = 'select * from book_item';
		
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(!empty($option['store_uid'])) {
			$where_arr[] = 'store_uid = '.$option['store_uid'];
		}
		if(!empty($option['type'])) {
			$where_arr[] = 'type like "'.addslashes($option['type']).'"';
		}
		//todo
		if(isset($option['status']) && ($option['status'] >= 0)) {
			$where_arr[] = 'status = '.$option['status'];
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		!isset($option['sort']) && $option['sort'] = 0;
		switch($option['sort'] ) {
			default: 
				$order = ' order by uid desc'; 
		}
		$sql .= $order;

		uct_use_app('store');
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'BookItemMod::func_get_book_item');
	}

	/*
		删除预约项目
	*/
	public static function delete_book_item($uids, $sp_uid) {
		if(!is_array($uids)) $uids = array($uids);
		$sql = 'delete from book_item where uid in ('.implode(',', $uids).') && sp_uid = '.$sp_uid;
		return Dba::write($sql);
	}
}




