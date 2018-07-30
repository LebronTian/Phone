<?php
/*
	运费模板管理
	收货地址管理
*/
class DeliveryMod {
	public static function func_get_shop_user_address($item) {
		$item['address'] = htmlspecialchars($item['address']);
		return $item;
	}

	public static function func_get_shop_delivery($item) {
		$item['title'] = htmlspecialchars($item['title']);
		if(!empty($item['brief'])) $item['brief'] = htmlspecialchars($item['brief']);
		if(!empty($item['rule'])) $item['rule'] = json_decode($item['rule'], true);
		return $item;
	}

	public static function add_or_edit_user_address($ua) {
		if(!empty($ua['is_default'])) {
        	$ua['modify_time'] = $_SERVER['REQUEST_TIME'];
		}
		unset($ua['is_default']);

		if(!empty($ua['uid'])) {
			Dba::update('shop_user_address', $ua, 'uid = '.$ua['uid'].' and shop_uid = '.$ua['shop_uid'].' and user_id = '.$ua['user_id']);
		}
		else {

			Dba::insert('shop_user_address', $ua);
			$ua['uid'] = Dba::insertID();
		}

		return $ua['uid'];
	}

    /*
		删除收货地址
		返回删除的条数
	*/
	public static function delete_shop_user_address($aids, $shop_uid, $user_id) {
		if(!is_array($aids)) {
			$aids = array($aids);
		}
		$sql = 'delete from shop_user_address where uid in ('.implode(',',$aids).') and shop_uid = '.$shop_uid.' and user_id = '.$user_id;
		$ret = Dba::write($sql);
		return $ret;
	}

	/*
		获取收货地址列表
		不需要分页
	*/
	public static function get_shop_user_address($shop_uid, $user_id) {
		$sql = 'select * from shop_user_address where shop_uid = '.$shop_uid.' && user_id = '.$user_id.' order by modify_time desc';
		return Dba::readAllAssoc($sql, 'DeliveryMod::func_get_shop_user_address');
	}
 
	public static function get_shop_user_address_by_uid($uid) {
		$sql = 'select * from shop_user_address where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'DeliveryMod::func_get_shop_user_address');
	}

	/*
		运费模板
		$d = array(
			格式如下
			'valuation' => 0 固定邮费
			'rule' => array(
				'express' => 10,
				'ems' => 20,
				'mail' => 7,
			)

			
			'valuation' => 1 计件
			'rule' => array(
				'express' => {
					'normal' => array(
						'start' => 2,
						'start_fee' => 10,
						'add' => 1,
						'add_fee' => 5,
					)
					'customer' => array(
						array(
							'location' => array(
								//指定地区邮费, 可以是省, 或市
								array('province' => '江苏省'), 
								array('province' => '浙江省'), 
								array('province' => '上海市'), 

								array('province' => '广东省', 'city' => '深圳市'), 
							),
							'start' => 2,
							'start_fee' => 10,
							'add' => 1,
							'add_fee' => 5,
						),
						...
					)
				},
				'ems' => ...
				'mail' => ...
			)

			
		)
	*/
	public static function add_or_edit_delivery($d) {
		if(!empty($d['uid'])) {
			Dba::update('shop_delivery', $d, 'uid = '.$d['uid'].' and shop_uid = '.$d['shop_uid']);
		}
		else {
			$d['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('shop_delivery', $d);
			$d['uid'] = Dba::insertID();
		}

		return $d['uid'];
	}


    /*
		删除运费模板
		返回删除的条数
	*/
	public static function delete_shop_delivery($dids, $shop_uid) {
		if(!is_array($dids)) {
			$dids = array($dids);
		}

		Dba::beginTransaction(); {
			$sql = 'delete from shop_delivery where uid in ('.implode(',',$dids).') and shop_uid = '.$shop_uid;
			$ret = Dba::write($sql);
			if($ret) {
				//更新商品的运费模板
				$sql = 'update product set delivery_uid = 0 where delivery_uid in ('.implode(',',$dids).') and shop_uid = '.$shop_uid;
				Dba::write($sql);
			}
		} Dba::commit();

		return $ret;
	}

	/*
		获取运费模板列表
		不需要分页
	*/
	public static function get_shop_delivery($shop_uid) {
		$sql = 'select * from shop_delivery where shop_uid = '.$shop_uid.' order by create_time desc';
		return Dba::readAllAssoc($sql, 'DeliveryMod::func_get_shop_delivery');
	}
 
	/*
		运费模板详情
	*/
	public static function get_shop_delivery_by_uid($uid) {
		$sql = 'select * from shop_delivery where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'DeliveryMod::func_get_shop_delivery');
	}


	/*
		计算运费
		$d 运费模板参数, 也可以是运费模板uid
		$address 送货地址  'address' => array(
							'province' => '广东省',
							'city' => '深圳市',
							'town' => '南山区',
							
							'delivery' => '' //运送方式, 可以为空,或 express ems mail self 自提
							)
		$goods 货物信息 array(
							'count' => 2
						)

	*/
	public static function calc_delivery_fee($d, $address, $goods) {
		if(!$d || (is_numeric($d) && !($d = self::get_shop_delivery_by_uid($d)))) {
			return 0;
		}

		//如果address中没有指定运送方式则以规则第一个为准,快递
		$way = isset($address['delivery']) ? $address['delivery'] : '';
		if(!isset($d['rule'][$way])) $way = key($d['rule']);

		switch($d['valuation']) {
			//固定运费
			case 0: {
				return $d['rule'][$way];
			}

			//计件
			case 1:
			default: {
				if(!empty($d['rule'][$way]['customer'])) {
					$rule = array_usearch($address, $d['rule'][$way]['customer'], function($a, $as){						
						foreach($as['location'] as $l) {
							if(isset($l['city'])) {
								if(($l['city'] == $a['city']) && ($l['province'] == $a['province'])) {
									return true;
								}
							}
							else {
								//var_export($l);
								//var_export($a);
								if(($l['province'] == $a['province'])) {
									return true;
								}
							}
						}
						return false;
					});
				}
				if(empty($rule)) {
					$rule = $d['rule'][$way]['normal'];
				}

				if(empty($rule['add'])) {
					return false;
				}
				return $goods['count'] <= $rule['start'] ? $rule['start_fee'] : 
						($rule['start_fee'] + ceil((float)($goods['count'] - $rule['start'])/$rule['add']) * $rule['add_fee']);	
			}
		}
	}

	/*
		邮费预览
		$goods = array(
			'uid' => 商品uid
			'count' => 商品件数
		)

		返回 array(
		)
	*/
	public static function preview_delivery($goods, $address) {
		if(!($d = Dba::readOne('select delivery_uid from product where uid = '.$goods['uid'])) ||
			!($d = self::get_shop_delivery_by_uid($d)) ||
			empty($d['rule'])) {
			return (array('free' => 0));
		}

		$ret = array();
		foreach(array_keys($d['rule']) as $k) {
			$address['delivery'] = $k;
			$ret[$k] = self::calc_delivery_fee($d, $address, $goods);
		}

		return $ret;
	}

	/*
		邮费预览, 多个商品
		$products = array(
			array(
			'uid' => 商品uid
			'count' => 商品件数
			),
		)

		$address = array(
			'province' => 
			'city' => 
		)

		返回 array(
		)
	*/
	public static function precalc_delivery($products, $address) {
		$dps = array(); //计算运费
		foreach($products as $p) {
			if(!($sp = ProductMod::get_shop_product_by_sku_uid($p['uid']))) { 
				setLastError(ERROR_OBJ_NOT_EXIST);
				return false;
			}
			if(isset($dps[$sp['delivery_uid']])) {
				$dps[$sp['delivery_uid']]['count'] += $p['count'];
			}
			else {
				$dps[$sp['delivery_uid']] = array('count' => $p['count']);	
			}
		}	

		$ret = array();
		foreach($dps as $d => $goods) {
			if(!$d || !($d = DeliveryMod::get_shop_delivery_by_uid($d)) || empty($d['rule'])) {
				$k = 'free';
				if(isset($ret[$k])) {
					$ret[$k] = array('fee' => 0, 'cnt' => $ret[$k]+1);
				}
				else {
					$ret[$k] = array('fee' => 0, 'cnt' => 1);
				}
				continue;
			}
			foreach(array_keys($d['rule']) as $k) {
				$address['delivery'] = $k;
				$fee = DeliveryMod::calc_delivery_fee($d, $address, $goods);
				if(isset($ret[$k])) {
					$ret[$k] = array('fee' => $ret[$k]['fee'] + $fee, 'cnt' => $ret[$k]['cnt'] + 1);
				}
				else {
					$ret[$k] = array('fee' => $fee, 'cnt' => 1);
				}
			}
		}

		uasort($ret, function($a, $b) {
			return $a['cnt'] == $b['cnt'] ? 0 : ($a['cnt'] > $b['cnt'] ? 1 : -1);
		});
		$cnt = count($dps);
		foreach($ret as $k => $v) {
			$ret[$k] = $ret[$k]['fee'];
		}
		return $ret;
	}

}

