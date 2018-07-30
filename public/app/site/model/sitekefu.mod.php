<?php
/*
	本文件由 *uctphp框架代码半自动生成工具* 自动生成

	中文名： 客服/服务/门店
	类名： SiteKefu

	模块名： site_kefu
	表名： site_kefu
*/

class SiteKefuMod {
	public static function func_get_site_kefu($item) {
		//todo
		return $item;
	}

	/*
		添加编辑客服/服务/门店	
	*/
	public static function add_or_edit_site_kefu($i) {
		if(!empty($i['uid'])) {
			Dba::update('site_kefu', $i, 'uid = '.$i['uid'].' && site_uid = '.$i['site_uid']);	
		}	
		else {
			unset($i['uid']);
			!isset($i['create_time']) && $i['create_time'] = $_SERVER['REQUEST_TIME'];

			Dba::insert('site_kefu', $i);	
			$i['uid'] = Dba::insertID();
		}

		return $i['uid'];
	}
	
	public static function get_site_kefu_by_uid($uid) {
		return Dba::readRowAssoc('select * from site_kefu where uid = '.$uid, 'SiteKefuMod::func_get_site_kefu');
	}

	/*
		 客服/服务/门店数据列表	
	*/
	public static function get_site_kefu_list($option) {
		$sql = 'select * from site_kefu';
		
		if(!empty($option['site_uid'])) {
			$where_arr[] = 'site_uid = '.$option['site_uid'];
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

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SiteKefuMod::func_get_site_kefu');
	}

	/*
		删除客服/服务/门店
	*/
	public static function delete_site_kefu($uids, $site_uid) {
		if(!is_array($uids)) $uids = array($uids);
		$sql = 'delete from site_kefu where uid in ('.implode(',', $uids).') && site_uid = '.$site_uid;
		return Dba::write($sql);
	}
}




