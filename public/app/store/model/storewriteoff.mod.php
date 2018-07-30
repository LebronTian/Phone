<?php
/*
	核销员管理
*/

class StoreWriteoffMod {
	public static function func_get_writeoffer($item) {
		if(!empty($item['store_uids'])) $item['store_uids'] = explode(';', $item['store_uids']);
		return $item;
	}

	/*
		添加编辑核销员
	*/
	public static function add_or_edit_writeoffer($wo) {
		if(!empty($wo['uid'])) {
			Dba::update('store_writeoffer', $wo, 'uid = '.$wo['uid'].' and sp_uid = '.$wo['sp_uid']);
		}
		else {
			unset($wo['uid']);
			$wo['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('store_writeoffer', $wo);
			$wo['uid'] = Dba::insertID();
		}

		return $wo['uid'];
	}


	/*
		核销员审核
	*/
	public static function review_writeoffer($uids, $status, $sp_uid) {
		$sql = 'update store_writeoffer set status = '.$status.
				' where sp_uid = '.$sp_uid.' && uid in ('.implode(',', $uids).')';
		return Dba::write($sql);
	}

	/*
		核销员删除
	*/
	public static function del_writeoffer($uids, $sp_uid) {
		$sql = 'delete from store_writeoffer  where sp_uid = '.$sp_uid.' && uid in ('.implode(',', $uids).')';
		
		return Dba::write($sql);
	}

	public static function get_writeoffer_by_uid($uid) {
		$sql = 'select * from store_writeoffer where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'StoreWriteoffMod::func_get_writeoffer');
	}

	/*
	*/
	public static function get_writeoffer_by_su_uid($su_uid, $sp_uid) {
		$sql = 'select * from store_writeoffer where sp_uid = '.$sp_uid.' && su_uid = '.$su_uid;
		return Dba::readRowAssoc($sql, 'StoreWriteoffMod::func_get_writeoffer');
	}

	/*
		核销员列表
	*/
	public static function get_writeoffer($option) {
		$sql = 'select * from store_writeoffer';

		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(isset($option['status']) && $option['status'] >= 0) {
			$where_arr[] = 'status = '.$option['status'];
		}

		//搜索
		if(!empty($option['key'])) {
			// todo 用户名搜索
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		$sort = 'uid desc';
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'StoreWriteoffMod::func_get_writeoffer');
	}

	/*
		检查用户是否有权限核销

		$store_uid 指定门店

		无权限返回false， 否则返回$wo
	*/
	public static function check_su_writeoff_access($su_uid, $sp_uid, $store_uid = 0) {
		if((!$wo = StoreWriteoffMod::get_writeoffer_by_su_uid($su_uid, $sp_uid)) ||
			$wo['status'] != 1) {
			return false;
		}	

		if($store_uid && $wo['store_uids'] && !in_array($store_uid, $wo['store_uids'])) {
			return false;
		}

		return $wo;
	}
}

