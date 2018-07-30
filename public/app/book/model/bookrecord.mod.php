<?php
/*
	本文件由 *uctphp框架代码半自动生成工具* 自动生成

	中文名： 预约记录
	类名： BookRecord

	模块名： book_record
	表名： book_record
*/

class BookRecordMod {
	public static function func_get_book_record($item) {
		if(!empty($item['b_uid'])) $item['book'] = BookItemMod::get_book_item_by_uid($item['b_uid']);
		if(!empty($item['data'])) $item['data'] = json_decode($item['data'], true);
		$item['order'] = BookRecordMod::get_book_record_order_by_uid($item['uid']);

		return $item;
	}

	public static function func_get_book_record_order($item) {
		if(!empty($item['pay_info'])) $item['pay_info'] = json_decode($item['pay_info'], true);
		
		return $item;
	}

	/*
		添加编辑预约记录	
	*/
	public static function add_or_edit_book_record($i) {
		if(!empty($i['uid'])) {
			Dba::update('book_record', $i, 'uid = '.$i['uid'].' && b_uid = '.$i['b_uid']);	
		}	
		else {
			unset($i['uid']);
			!isset($i['create_time']) && $i['create_time'] = $_SERVER['REQUEST_TIME'];

			$price = Dba::readOne('select price from book_item where uid = '.$i['b_uid']);

			Dba::beginTransaction(); {
				Dba::insert('book_record', $i);	
				$i['uid'] = Dba::insertID();
				Dba::write('update book_item set book_cnt = book_cnt + 1 where uid = '.$i['b_uid']);
				if($price) {
					Dba::insert('book_record_order', array('r_uid' => $i['uid'], 'paid_fee' => $price));
					$order_uid = Dba::insertID();
					//setcookie('__book_order_uid', $order_uid, 0, '/');
				}
			} Dba::commit();
		}

		return $i['uid'];
	}
	
	public static function get_book_record_by_uid($uid) {
		return Dba::readRowAssoc('select * from book_record where uid = '.$uid, 'BookRecordMod::func_get_book_record');
	}

	/*
		 预约记录数据列表	
	*/
	public static function get_book_record_list($option) {
		$sql = 'select book_record.* from book_record';
		
		if(!empty($option['sp_uid'])) {
			$sql .= ' join book_item on book_item.uid = book_record.b_uid';
			$where_arr[] = 'book_item.sp_uid = '.$option['sp_uid'];
		}

		if(!empty($option['b_uid'])) {
			$where_arr[] = 'b_uid = '.$option['b_uid'];
		}
		if(!empty($option['su_uid'])) {
			$where_arr[] = 'su_uid = '.$option['su_uid'];
		}

		if(!empty($option['sp_remark']) && $option['sp_remark']>0) {
			$where_arr[] = 'sp_remark = '.$option['sp_remark'] ;
		}
		//搜索
		if(!empty($option['key'])) {
			$where_arr[] = '(data like "%'.
                addslashes(trim(str_replace(array('\\u'), array('\\\\u'), json_encode($option['key'])), '"')) . '%")';
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

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'BookRecordMod::func_get_book_record');
	}

	/*
		删除预约记录
	*/
	public static function delete_book_record($uids, $b_uid) {
		if(!is_array($uids)) $uids = array($uids);
		$sql = 'delete from book_record where uid in ('.implode(',', $uids).')';
		if(!empty($b_uid)) $sql .= ' && b_uid = '.$b_uid;
		return Dba::write($sql);
	}

	/*
	标记表单数据

	返回标记的条数
	*/
	public static function remark_book_record($uids, $sp_remark, $b_uid) {
		if(!is_array($uids)) {
			$uids = array($uids);
		}

		$sql = 'update book_record set sp_remark = '.$sp_remark.' where uid in ('.implode(',', $uids).')';
		if(!empty($b_uid)) $sql .= ' && b_uid = '.$b_uid;
		return	Dba::write($sql);
	}

	public static function get_book_record_order_by_uid($uid) {
		return Dba::readRowAssoc('select * from book_record_order where r_uid = '.$uid, 
						'BookRecordMod::func_get_book_record_order');
	}
	/*
		支付成功
	*/
	public static function onAfterBookRecordOrderPay($book_item, $record) {
	}
}




