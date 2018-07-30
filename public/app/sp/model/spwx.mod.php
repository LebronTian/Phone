<?php

class SpwxMod {
	public static function func_get_sp_wx($item) {
		if(!empty($item['cfg'])) $item['cfg'] = json_decode($item['cfg'], true);
		return $item;
	}

	public static function get_sp_wx_list($option) {
		$sql = 'select * from service_provider_wx_bind ';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}

		if(!empty($where_arr)) $sql .= ' where '.implode(' && ', $where_arr);
		
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SpwxMod::func_get_sp_wx');
	}

	public static function get_sp_wx_by_openid($openid) {
		return Dba::readRowAssoc('select * from service_provider_wx_bind where open_id = "'
											.addslashes($openid).'"', 'SpwxMod::func_get_sp_wx');
	}

	public static function add_or_edit_sp_wx($sw) {
		if($old = Dba::readRowAssoc('select * from service_provider_wx_bind where open_id = "'
									.$sw['open_id'].'"')) {
			$sw = array_merge($old, $sw);
		}	
		empty($sw['create_time']) && $sw['create_time'] = $_SERVER['REQUEST_TIME'];

		return Dba::replace('service_provider_wx_bind', $sw);
	}

	public static function delete_sp_wx($openid, $sp_uid) {
		return Dba::write('delete from service_provider_wx_bind where open_id = "'.$openid.
							'" && sp_uid = '.$sp_uid);
	}

}

