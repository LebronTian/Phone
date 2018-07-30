<?php

class XcxposterMod {
	public static function func_get_xcxposter($item) {
		if(!empty($item['photo_info'])) $item['photo_info'] = json_decode($item['photo_info'], true);
		if(!empty($item['reward_info'])) $item['reward_info'] = json_decode($item['reward_info'], true);
		if(!empty($item['notice_info'])) $item['notice_info'] = json_decode($item['notice_info'], true);

		return $item;
	}

	public static function add_or_edit_xcxposter($qp) {
		if(!empty($qp['uid'])) {
			Dba::update('xcxposter', $qp, 'uid = '.$qp['uid'].' && sp_uid = '.$qp['sp_uid']);
			if(!empty($qp['status'])&&$qp['status']==1){
				//把其他变成不可用
				//$sta['status'] = 0;
				//Dba::update('xcxposter', $sta, 'uid != '.$qp['uid'].' && sp_uid = '.$qp['sp_uid']);
			}
		}
		else {
			empty($app['create_time']) && $qp['create_time'] = $_SERVER['REQUEST_TIME'];
		
			Dba::insert('xcxposter', $qp);
			$qp['uid'] = Dba::insertID();
		}

		return $qp['uid'];
	}

	/*
		所有推广app或公众号列表
	*/
	public static function get_xcxposter_list($option) {
		$sql = 'select * from xcxposter';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(!empty($option['public_uid'])) {
			$where_arr[] = 'public_uid = '.$option['sp_uid'];
		}
		if(isset($option['status']) && ($option['status'] >= 0)) {
			$where_arr[] = 'status = '.$option['status'];
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .= ' order by uid desc';

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'XcxposterMod::func_get_xcxposter');
	}

	public static function get_xcxposter_by_uid($uid) {
		$sql = 'select * from xcxposter where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'XcxposterMod::func_get_xcxposter');
	}

	/*
		根据商户uid获取一个海报
	*/
	public static function get_default_xcxposter_by_sp_uid($sp_uid) {
		$ret = Dba::readRowAssoc('select * from xcxposter where sp_uid = '.$sp_uid.' and status = 1 order by uid desc limit 1','XcxposterMod::func_get_xcxposter');

		return $ret;
	}

	/*
		根据商户uid获取一个海报
	*/
	public static function get_xcxposter_by_public_uid($public_uid, $sp_uid) {
		return Dba::readRowAssoc('select * from xcxposter where sp_uid = '.$sp_uid.' && public_uid = '.$public_uid,
								'XcxposterMod::func_get_xcxposter');
	}

	public static function delete_xcxposter($uids, $sp_uid) {
		if(is_numeric($uids)) $uids = array($uids);

		$sql = 'delete from xcxposter where uid in('.implode(',', $uids).') && sp_uid = '.$sp_uid;
		return Dba::write($sql);
	}
	
}

