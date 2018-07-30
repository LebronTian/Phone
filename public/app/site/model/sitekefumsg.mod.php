<?php
/*
	本文件由 *uctphp框架代码半自动生成工具* 自动生成

	中文名： 数据
	类名： SiteKefuMsg

	模块名： site_kefu_msg
	表名： site_kefu_msg
*/

class SiteKefuMsgMod {
	public static function func_get_site_kefu_msg($item) {
		//todo
		if(!empty($item['kf_uid'])) $item['kefu'] = SiteKefuMod::get_site_kefu_by_uid($item['kf_uid']);
		return $item;
	}

	/*
		添加编辑数据	
	*/
	public static function add_or_edit_site_kefu_msg($i) {
		if(!empty($i['uid'])) {
			Dba::update('site_kefu_msg', $i, 'uid = '.$i['uid'].' && site_uid = '.$i['site_uid']);	
		}	else {
			unset($i['uid']);
			!isset($i['create_time']) && $i['create_time'] = $_SERVER['REQUEST_TIME'];

			Dba::insert('site_kefu_msg', $i);	
			$i['uid'] = Dba::insertID();
			//+1
			if(!empty($i['kf_uid'])) {
				Dba::write('update site_kefu set msg_cnt = msg_cnt + 1 where uid = '.$i['kf_uid']);
			}
		}

		return $i['uid'];
	}
	
	public static function get_site_kefu_msg_by_uid($uid) {
		return Dba::readRowAssoc('select * from site_kefu_msg where uid = '.$uid, 'SiteKefuMsgMod::func_get_site_kefu_msg');
	}

	/*
		 数据数据列表	
	*/
	public static function get_site_kefu_msg_list($option) {
		$sql = 'select * from site_kefu_msg';
		
		if(!empty($option['site_uid'])) {
			$where_arr[] = 'site_uid = '.$option['site_uid'];
		}
		if(!empty($option['kf_uid'])) {
			$where_arr[] = 'kf_uid = '.$option['kf_uid'];
		}
		//todo
		if(!empty($option['sp_remark']) && $option['sp_remark']>0) {
			$where_arr[] = 'sp_remark = '.$option['sp_remark'] ;
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

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SiteKefuMsgMod::func_get_site_kefu_msg');
	}

	/*
		删除数据
	*/
	public static function delete_site_kefu_msg($uids, $site_uid) {
		if(!is_array($uids)) $uids = array($uids);
		$sql = 'delete from site_kefu_msg where uid in ('.implode(',', $uids).') && site_uid = '.$site_uid;
		return Dba::write($sql);
	}

	/*
	返回标记的条数
	*/
	public static function remark_site_kefu_msg($uids, $sp_remark, $site_uid) {
		if(!is_array($uids)) {
			$uids = array($uids);
		}

		$sql = 'update site_kefu_msg set sp_remark = '.$sp_remark.' where uid in ('.implode(',', $uids).
				') && site_uid = '.$site_uid;
		return	Dba::write($sql);
	}

}




