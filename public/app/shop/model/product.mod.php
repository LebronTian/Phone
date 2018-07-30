<?php
/*
	商品, 分类
*/

class ProductMod {
	public static function func_get_cat($item) {
		$item['title'] = htmlspecialchars($item['title']);
		$item['title_en'] = htmlspecialchars($item['title_en']);
		return $item;
	}

	public static function func_get_product($item) {
		$item['title'] = htmlspecialchars($item['title']);
		if(!empty($item['content'])) $item['content'] = XssHtml::clean_xss($item['content']);
		if(!empty($item['cat_uid'])) $item['cat'] = self::get_product_cat_by_uid($item['cat_uid']);
		if(!empty($item['images'])) $item['images'] = explode(';', $item['images']);
		//todo 展开info 0不包邮 1不开发票 2不保修 3不退换货 5不是新品 6不是热销 7不是推荐
		if(!empty($item['sku_table'])) {
			$item['sku_table'] = json_decode($item['sku_table'], true);
			$item['quantity'] = 0;
			foreach($item['sku_table']['info'] as $sti){
				$item['quantity'] += $sti['quantity'];
			}
		}
		if (!empty($item['bas_services']))
		{
			$item['bas_services'] = json_decode($item['bas_services'], true);
		}
		//location
		if(!empty($item['location'])) $item['location'] = json_decode($item['location'], true);
		//send_time
		if(!empty($item['send_time'])) $item['send_time'] = json_decode($item['send_time'], true);
		//秒杀时间
		if(!empty($item['kill_time'])) $item['kill_time'] = json_decode($item['kill_time'], true);
		//运费模板
		if(!empty($item['delivery_uid'])) $item['delivery'] = DeliveryMod::get_shop_delivery_by_uid($item['delivery_uid']);
		if(!empty($item['extra_info'])) $item['extra_info'] = ProductMod::get_product_extra_info($item['uid'], $item['shop_uid']);
		//商家信息
		if(!empty($item['biz_uid'])) $item['biz'] = ShopBizMod::get_shop_biz_by_uid($item['biz_uid']);

		if(!empty($item['virtual_info'])) {
			$item['virtual_info'] = json_decode($item['virtual_info'], true);
		}
		if(empty($item['virtual_info'])) $item['virtual_info'] = false;

		if(!empty($item['product_uids'])) $item['linked_products'] = ProductMod::get_shop_product_by_uids($item['product_uids'],$item['shop_uid']);

		return $item;
	}

	public static function func_get_products($item) {
		$item['title'] = htmlspecialchars($item['title']);
		if(!empty($item['cat_uid'])) $item['cat'] = self::get_product_cat_by_uid($item['cat_uid']);
		if(!empty($item['images'])) $item['images'] = explode(';', $item['images']);
		//todo 展开info 0不包邮 1不开发票 2不保修 3不退换货 5不是新品 6不是热销 7不是推荐
		if(!empty($item['sku_table'])) {
			$item['sku_table'] = json_decode($item['sku_table'], true);
		}
		//location
		if(!empty($item['location'])) $item['location'] = json_decode($item['location'], true);
		if(!empty($item['extra_info'])) $item['extra_info'] = ProductMod::get_product_extra_info($item['uid'], $item['shop_uid']);
		if(!empty($item['virtual_info'])) $item['virtual_info'] = json_decode($item['virtual_info'], true);

		return $item;
	}

	public static function func_get_product_info($item) {
		$item['data'] = htmlspecialchars($item['data']);
		return $item;
	}

	public static function func_get_son_product_cats($item){

		$sql = 'select * from product_cats where shop_uid = '.$item['shop_uid'].' and parent_uid = '.$item['uid'].' and status = 0';
		$item['son_cats']= Dba::readAllAssoc($sql);
//		var_dump($item);
		return $item;
	}

	/*
	 * 获取所有子分类，并用分号隔开
	 */
	public static function get_all_sons_product_cats($option){
		$sql = 'select * from product_cats where shop_uid = '.$option['shop_uid'].' and parent_uid = '.$option['uid'].' and status = 0';
		return Dba::readAllAssoc($sql, 'ProductMod::func_get_son_product_cats');
	}

	/*
		商品分类
		不需要分页
	*/
	public static function get_product_cats($option) {
		$sql = 'select * from product_cats';	
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		if(isset($option['parent_uid']) && $option['parent_uid'] >= 0) {
			$where_arr[] = 'parent_uid = '.$option['parent_uid'];
		}
		if(isset($option['status'])) {
			$where_arr[] = 'status = '.$option['status'];
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		empty($option['sort']) && $option['sort'] = SORT_CREATE_TIME_DESC;
		switch($option['sort']) {
			case SORT_CREATE_TIME:
			$sql .= ' order by sort desc, create_time desc';
			break;
			default:
			$sql .= ' order by sort desc, create_time ';
		}

		$cats = Dba::readAllAssoc($sql, 'ProductMod::func_get_cat');

		//获取父级分类信息
		if(!empty($option['with_parent_info']) && $cats) {
			foreach($cats as $k => $c) {
				if($c['parent_uid']) {
					$cats[$k]['parent_cat'] = self::get_product_cat_by_uid($c['parent_uid']);
				}
			}
		}
		return $cats;
	}

	/*
		分类详情
	*/
	public static function get_product_cat_by_uid($uid) {
		$sql = 'select * from product_cats where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'ProductMod::func_get_cat');
	}

	public static function add_or_edit_cat($cat) {
		//如果设置父级目录必须为同一个shop_uid
		if(!empty($cat['parent_uid'])) {
			$su = Dba::readOne('select shop_uid from product_cats where uid = '.$cat['parent_uid']);
			if($su != $cat['shop_uid']) {
				setLastError(ERROR_PERMISSION_DENIED);
				return false;
			}
			//不能设置自己为parent
			if(!empty($cat['uid']) && ($cat['uid'] == $cat['parent_uid'])) {
				$cat['parent_uid'] = 0;	
			}
		}

		if(!empty($cat['uid'])) {
			Dba::update('product_cats', $cat, 'uid = '.$cat['uid'].' and shop_uid = '.$cat['shop_uid']);
		}
		else {
			$cat['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('product_cats', $cat);
			$cat['uid'] = Dba::insertID();
		}

		return $cat['uid'];
	}

	/*
		删除分类
		返回删除的条数
	*/
	public static function delete_cat($cids, $shop_uid) {
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'delete from product_cats where uid in ('.implode(',',$cids).') and shop_uid = '.$shop_uid;

		Dba::beginTransaction(); {
			$ret = Dba::write($sql);
			if($ret) {
				//更新父级分类, 商品分类 
				$sql = 'update product_cats set parent_uid = 0 where parent_uid in ('.implode(',',$cids).') and shop_uid = '.$shop_uid;
				Dba::write($sql);
				$sql = 'update product set cat_uid = 0 where cat_uid in ('.implode(',',$cids).') and shop_uid = '.$shop_uid;
				Dba::write($sql);
			}
		} Dba::commit();

		return $ret;
	}

	/*
		商品列表, 不包含content, sku_table, location, delivery_uid 
	*/
	public static function get_shop_products($option,$agent_product=1) {
		$sql = 'select p.uid,p.shop_uid,p.cat_uid,p.biz_uid,p.title,p.title_second,p.main_img,p.images,p.like_cnt,p.fav_cnt,p.comment_cnt,p.click_cnt,p.sell_cnt,
				p.price,p.ori_price,p.quantity,p.product_code,p.info,p.point_price,p.buy_limit,p.create_time,p.modify_time,p.sort,
				p.status,p.group_price,p.group_cnt,p.kill_time,p.sku_table';
		!empty($option['ukeys']) && $sql .= ', "extra_info"';
		if(($a_uid = AgentMod::require_agent()) && $agent_product ==1)
		{
			$sql .= ',ag.price,ag.ori_price,ag.title,ag.main_img,ag.images,ag.status,ag.modify_time';
		}
		$sql .= ' from product as p';
		//代理商设置的商品信息
		if(($a_uid = AgentMod::require_agent()) && $agent_product ==1)
		{
			$sql .= ' right join shop_agent_to_user_product as ag on ag.p_uid = p.uid ';
			$where_arr[] = 'ag.a_uid = '.$a_uid;
			$where_arr[] = ' p.sku_table =""' ;//暂时不支持带sku 的
		}

		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'p.shop_uid = '.$option['shop_uid'];
		}
		if(!empty($option['uid'])) {
			$where_arr[] = 'p.uid = '.$option['uid'];
		}
		if(!empty($option['biz_uid'])) {
			$where_arr[] = 'p.biz_uid = '.$option['biz_uid'];
		}
		if(isset($option['is_biz'])) {
			$where_arr[] = $option['is_biz'] ? 'p.biz_uid != 0' : 'p.biz_uid = 0';
		}
		if(isset($option['is_group'])) {
			$where_arr[] = $option['is_group'] ? 'p.group_price > 0' : 'p.group_price = 0';
		}
		if(isset($option['is_kill'])) {
			//$where_arr[] = $option['is_kill'] ? 'p.kill_time != ""' : 'p.kill_time = ""';
		}
	

		if(!empty($option['cat_uid'])) {
			if(is_array($option['cat_uid'])) {
				$where_arr[] = 'p.cat_uid in '.Dba::makeIn($option['cat_uid']);
			}
			else {
				$where_arr[] = 'p.cat_uid = '.$option['cat_uid'];
			}
		}
		if(isset($option['status']) && $option['status'] >= 0) {
			if(($a_uid = AgentMod::require_agent()) && $agent_product ==1)
			{
				$where_arr[] = 'ag.status = '.$option['status'];
				$where_arr[] = 'p.status = '.$option['status'];
				//供货商 上架 且 代理商上架
			}
			else
			{
				$where_arr[] = 'p.status = '.$option['status'];
			}
		}
		if(isset($option['low_stock']) && $option['low_stock'] >= 0) {
			$where_arr[] = 'p.quantity <= '.$option['low_stock'];
		}

		//搜索额外信息
		if(!empty($option['ukeys'])) {
			$option['uids'] = self::search_product_extra_info($option);
			//关键字只搜索额外信息
			if($option['uids']) {
				unset($option['key']);
			}
		}

		if(isset($option['uids'])) {
			if($option['uids']) {
				$where_arr[] = 'p.uid in('.implode(',', $option['uids']).')';
			}
			else if(empty($option['key'])){
				return array('count' =>0, 'list' => array());
			}
		}
		if(!empty($option['product_code'])) {
			if(is_array($option['product_code'])) {
				$where_arr[] = 'p.product_code in '.Dba::makeIn($option['product_code']);
			}
			else {
				$where_arr[] = 'p.product_code = "'.addslashes($option['product_code']).'"';
			}
		}

		if(!empty($option['min_price'])) {
			$where_arr[] = 'p.ori_price >= '.$option['min_price'];
		}
		if(!empty($option['max_price'])) {
			$where_arr[] = 'p.ori_price <= '.$option['max_price'];
		}
		if(!empty($option['info'])) {
			$where_arr[] = '(p.info &'.$option['info'].') = '.$option['info'];
		}

		//搜索
		if(!empty($option['key'])) {
			$where_arr[] = '((p.title like "%'.$option['key'].'%" or content like "%'.
							$option['key'].'%") or p.product_code like "%'.$option['key'].'%")';
		}
		if(!empty($option['exclude_uids'])) {
			$where_arr[] = 'p.uid not in ('.implode(',', $option['exclude_uids']).')';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		if(!empty($option['group_by'])) {
			$sql .= ' group by '.$option['group_by'];
		}

		if(!empty($option['uids'])) {
			$sort = 'find_in_set(uid, "'.implode(',', $option['uids']).'")';
		}
		else {
			empty($option['sort']) && $option['sort'] = SORT_CREATE_TIME;
			switch($option['sort']) {
				case SORT_SALSE_COUNT_DESC:
					$sort = 'sort desc, p.sell_cnt desc';
					break;
				case SORT_SALSE_COUNT:
					$sort = 'sort desc, p.sell_cnt';
					break;
				case SORT_PRICE_DESC:
					$sort = 'sort desc, p.price desc';
					break;
				case SORT_PRICE:
					$sort = 'sort desc, p.price';
					break;
				case SORT_ORI_PRICE_DESC:
					$sort = 'sort desc, p.ori_price desc';
					break;
				case SORT_ORI_PRICE:
					$sort = 'sort desc, p.ori_price';
					break;
				case SORT_QUANTITY_DESC:
					$sort = 'sort desc, p.quantity desc';
					break;
				case SORT_QUANTITY:
					$sort = 'sort desc, p.quantity';
					break;
				default:
					$sort = 'sort desc, create_time desc';
			}
		}
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'ProductMod::func_get_product');
	}

	/*
		商品详情
	*/
	public static function get_shop_product_by_uid($uid,$agent_product=1) {
		$sql = 'select p.*, "extra_info" ';
		if(($a_uid = AgentMod::require_agent()) && $agent_product ==1)
		{
			$sql .= ',ag.content,ag.price,ag.ori_price,ag.title,ag.main_img,ag.images,ag.status,ag.modify_time ';
		}
		$sql .='from product as p ';
		$where_arr[] = 'p.uid = '.$uid;
		//代理商设置的商品信息
		if(($a_uid = AgentMod::require_agent()) && $agent_product ==1 )
		{
			$sql .= ' right join shop_agent_to_user_product as ag on ag.p_uid = p.uid ';
			$where_arr[] = ' ag.a_uid = '.$a_uid;
			$where_arr[] = ' p.sku_table =""' ;//暂时不支持带sku 的
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
//		var_dump(__file__.' line:'.__line__,$sql);exit;
		return Dba::readRowAssoc($sql, 'ProductMod::func_get_product');
	}

	public static function get_shop_product_by_uids($uids,$shop_uid) {

		$uidarr = explode(",", $uids);
		foreach($uidarr as $k => $ua){
			if(!(is_numeric($ua))){
				unset($uidarr[$k]);
			}
		}
		$uids = implode(",", $uidarr);

		$sql = 'select * from product where uid in ('.$uids.') and shop_uid = '.$shop_uid;
		return Dba::readAllAssoc($sql, 'ProductMod::func_get_products');
	}
//	public static function get_product_package_by_uid($product_uid){
//		$sql = 'select package from shop_product_package';
//		if(!empty($product_uid)) {
//			$where_arr[] = 'p_uid = '.$product_uid;
//		}
//		if(!empty($where_arr)) {
//			$sql .= ' where '.implode(' and ', $where_arr);
//		}
//		return Dba::readOne($sql);
//
//	}

	/*
		todo 可以cache一下
		在购物车,订单订单等地方用到
		根据sku_uid获取商品简要信息

		$sku_uid的格式 'pruduct_uid;尺寸:X;颜色:红色'
		也可以是一个单独的product_uid

		返回 array(
			'uid' =>
			'shop_uid' =>
			'title' =>
			'main_img' =>
			'price' =>
			'ori_price' =>
			'quantity' =>
			'point_price' =>
			'buy_limit'	=>
			'delivery_uid' =>
			'sku_uid' =>
			'quantity_total' =>
			'virtual_info' =>
		)
	*/
	public static function get_shop_product_by_sku_uid($sku_uid,$agent_product=1) {
		$sku_uid = explode(';', $sku_uid, 2);
		$product_uid = $sku_uid[0];

//        $sql = 'select p.uid, p.shop_uid, p.title, p.main_img, p.price, p.ori_price, p.quantity,p.package, p.info, p.sku_table, p.point_price, p.buy_limit, p.delivery_uid,
//				p.product_code, p.back_point, p.virtual_info';
        $sql = 'select p.* ';
		if(($a_uid = AgentMod::require_agent()) && $agent_product ==1)
		{
		$sql .= ',ag.price,ag.ori_price,ag.title,ag.main_img ';
		}
		$sql .='from product  as p ';
		$where_arr[] = 'p.uid = '.$product_uid;
		//代理商设置的商品信息
		if(($a_uid = AgentMod::require_agent()) && $agent_product ==1)
		{
			$sql .= ' right join shop_agent_to_user_product as ag on ag.p_uid = p.uid ';
			$where_arr[] = ' ag.a_uid = '.$a_uid;
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$ret = Dba::readRowAssoc($sql, 'ProductMod::func_get_product');
		$ret['quantity_total'] = $ret['quantity'];
		if(!empty($sku_uid[1]) && !empty($ret['sku_table']['info'][$sku_uid[1]])) {
			$ret = array_merge($ret, $ret['sku_table']['info'][$sku_uid[1]]);
		}
		unset($ret['sku_table']);
		$ret['sku_uid'] = $sku_uid;
		return $ret;
	}

	/*
		创建或编辑商品

		$product = array(
			//sku数据结构
			'sku_table' => array(
				'table' => array(
					'颜色' => array('红色', '绿色')),
					'尺寸' => array('L', 'X')),
					...
				),
				'info' => array(
					'颜色:红色;尺寸:L' => array(
						'price' => , 'ori_price' => , 'quantity' => , 'icon_img' => ''
					),
					'颜色:红色;尺寸:X' => array(
						'price' => , 'ori_price' => , 'quantity' => , 'icon_img' => ''
					),
					'颜色:绿色;尺寸:L' => array(
						'price' => , 'ori_price' => , 'quantity' => , 'icon_img' => ''
					),
					'颜色:绿色;尺寸:X' => array(
						'price' => , 'ori_price' => , 'quantity' => , 'icon_img' => ''
					),
				)
			)
		)
	*/
	public static function add_or_edit_product($product) {
		//保证cat_uid存在
		if(!empty($product['cat_uid'])) {
			$su = Dba::readOne('select shop_uid from product_cats where uid = '.$product['cat_uid']);
			if($su != $product['shop_uid']) {
				setLastError(ERROR_PERMISSION_DENIED);
				return false;
			}
		}

		$product['modify_time'] = $_SERVER['REQUEST_TIME'];
		if(!empty($product['uid'])) {
//			Dba::update('shop_product_package', $product['package'], 'p_uid = '.$product['uid']);
			Dba::update('product', $product, 'uid = '.$product['uid'].' and shop_uid = '.$product['shop_uid']);

		}
		else {
			$product['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('product', $product);
//			Dba::insert('shop_product_package', $product);
			$product['uid'] = Dba::insertID();
		}

		return $product['uid'];
	}

	//批量改商品
	public static function bat_edit_product($option, $uids, $shop_uid) {
		//保证cat_uid存在
		if(!empty($option['cat_uid'])) {
			$su = Dba::readOne('select shop_uid from product_cats where uid = '.$option['cat_uid']);
			if($su != $shop_uid) {
				setLastError(ERROR_PERMISSION_DENIED);
				return false;
			}
		}
		
		$option['modify_time'] = $_SERVER['REQUEST_TIME'];
		$ret = Dba::update('product', $option, ' uid in ('.implode(',',$uids).
							') && shop_uid = '.$shop_uid);
		return $ret;
	}

	/*
	 * 快捷复制商品
	 */
	public static function copy_product($uid){

		$sql = 'select * from product where uid = '.$uid;
		$product = Dba::readRowAssoc($sql);
		unset($product['uid']);

		$product['modify_time'] = $_SERVER['REQUEST_TIME'];
		$product['create_time'] = $_SERVER['REQUEST_TIME'];
		Dba::insert('product', $product);
//			Dba::insert('shop_product_package', $product);
		$product['uid'] = Dba::insertID();

		return $product['uid'];
	}

	/*
		删除商品 
		返回删除的条数
	*/
	public static function delete_products($pids, $shop_uid) {
		if(!is_array($pids)) {
			$pids = array($pids);
		}
		$sql = 'delete from product where uid in ('.implode(',',$pids).') and shop_uid = '.$shop_uid;
		$ret = Dba::write($sql);

		//删除商品额外信息
		$sql = 'delete from product_extra_info where shop_uid = '.$shop_uid.' and product_uid in ('.implode(',',$pids).')'; 
		$ret = Dba::write($sql);
		Event::handle('Afterdelete_product',array($pids,$shop_uid));
		return $ret;
	}

	/*
	删除商品 可被代理信息 和正被代理的商品
	 */
	public static function onAfterdelete_product($uids,$shop_uid)
	{
		AgentMod::delete_agent_product($uids,$shop_uid);
		$sql = 'delete from shop_agent_to_user_product where p_uid in (' . implode(',', $uids) . ') ';
		return Dba::write($sql);
	}

	/*
		减库存 , 加销量
	*/
	public static function decrease_product_quantity($sku_uid, $quantity) {
		$sku_uid = explode(';', $sku_uid, 2);	
		do {
			$p = Dba::readRowAssoc('select uid, quantity, sku_table from product where uid = '.$sku_uid[0]);
			$p['sku_table_ori'] = $p['sku_table'];
			if($p['sku_table']) $p['sku_table'] = json_decode($p['sku_table'], true);

			if(empty($sku_uid[1])) { //普通减库存
				if($p['quantity'] < $quantity) {
					setLastError(ERROR_OUT_OF_LIMIT);
					return false;
				}	

				$sql = 'update product set quantity = quantity - '.$quantity.', sell_cnt=sell_cnt+'.$quantity
						.' where uid = '.$p['uid'].' && quantity >= '.$quantity;
			}
			else {
				if(empty($p['sku_table']['info'][$sku_uid[1]])) {
					setLastError(ERROR_OBJ_NOT_EXIST);
					return false;
				}
				if($p['sku_table']['info'][$sku_uid[1]]['quantity'] < $quantity) {
					setLastError(ERROR_OUT_OF_LIMIT);
					return false;
				}	

				$new = $p['sku_table'];
				$new['info'][$sku_uid[1]]['quantity'] -= $quantity;
				$sql = 'update product set sku_table = "'.addslashes(json_encode($new)).'", sell_cnt=sell_cnt+'.$quantity
						.' where uid = '.$p['uid'].' && sku_table = "'.addslashes(($p['sku_table_ori'])).'"';
			}
		} while(!Dba::write($sql));
		
		return true;
	}

	/*
		取消订单后 加库存, 减销量
	*/
	public static function increase_product_quantity($sku_uid, $quantity) {
		$sku_uid = explode(';', $sku_uid, 2);	
		do {
			$p = ProductMod::get_shop_product_by_uid($sku_uid[0],0);
			if(!$p) {
				setLastError(ERROR_OBJ_NOT_EXIST);
				return false;
			}
			if(empty($sku_uid[1])) { //普通减库存
				$sql = 'update product set quantity = quantity + '.$quantity;
				# $sql .= ',sell_cnt=sell_cnt-'.$quantity;
				$sql .= ' where uid = '.$p['uid'];
			}
			else {
				if(empty($p['sku_table']['info'][$sku_uid[1]])) {
					setLastError(ERROR_OBJ_NOT_EXIST);
					return false;
				}
            
				$new = $p['sku_table'];
				$new['info'][$sku_uid[1]]['quantity'] += $quantity;
				$sql = 'update product set sku_table = "'.addslashes(json_encode($new)).'"';
				# $sql .= ',sell_cnt=sell_cnt-'.$quantity;
				$sql .= ' where uid = '.$p['uid'];
				#todo 中文编码问题
				#$sql .= ' && (sku_table = "'.addslashes(json_encode($p['sku_table'], JSON_UNESCAPED_UNICODE)).
				#' || sku_table = "'.addslashes(json_encode($p['sku_table'])).'")"';
			}
			
		} while(!Dba::write($sql));
		
		return true;
	}

	/*
		获取店铺商品额外信息	
		返回
		array(
			'品牌' => array(iphone, nokia),
			'行业' => array(手机, 饮食),
			'供应商' => array(富士康, ),
			...
		)
	*/
	public static function get_shop_product_extra_info($shop_uid) {
		if(!($all = Dba::readAllAssoc('select * from product_extra_info where shop_uid = '.$shop_uid.' order by sort desc', 
										'ProductMod::func_get_product_info'))) {
			return array();
		}
		$ret = array();
		foreach($all as $a) {
			if(!isset($ret[$a['ukey']]) || !in_array($a['data'], $ret[$a['ukey']])) {
				$ret[$a['ukey']][] = $a['data'];	
			}
		}

		return $ret;
	}

	/*
		获取商品更多信息, 不分页
	*/
	public static function get_product_extra_info($product_uid, $shop_uid) {
		return Dba::readAllAssoc('select * from product_extra_info where shop_uid = '.$shop_uid.' && product_uid = '.$product_uid
								.' order by sort desc','ProductMod::func_get_product_info');
	}

	/*
		新增商品额外信息	
		$pei = array(
				'product_uid'
				'shop_uid'
				'ukey'
				'data'
		)
	*/
	public static function add_product_extra_info($pei) {
		//存在则更新
		if($uid = Dba::readOne('select uid from product_extra_info where shop_uid = '.$pei['shop_uid'].' && product_uid = '
								.$pei['product_uid'].' && ukey = "'.addslashes($pei['ukey']).'"')) {
			Dba::update('product_extra_info', $pei, 'uid = '.$uid);
			$pei['uid'] = $uid;
		}	
		else {
			Dba::insert('product_extra_info', $pei);
			$pei['uid'] = Dba::insertID();
		}

		return $pei['uid'];
	}

	/*
		批量新增商品额外信息	
		注意这里没检查重复ukey的情况
		$peis = array(array(
				'product_uid'
				'shop_uid'
				'ukey' => 
				'data' => 
		))
	*/
	public static function bat_add_product_extra_info($peis) {
		return Dba::insertS('product_extra_info', $peis);
	}

	public static function delete_product_extra_info($product_uid, $ukey, $shop_uid) {
			return Dba::write('delete from product_extra_info where shop_uid = '.$shop_uid.' && product_uid = '.
								$product_uid.' && ukey = "'.addslashes($ukey).'"');
	}

	/*
		$option = array(
				'shop_uid'
				'key'
				'ukeys' => array(
					'品牌' => array('iphone', 'nokia')
					'厂家' => array('富士康')
					...
				)
		)	
	*/
	public static function search_product_extra_info($option) {
		$sql = 'select distinct(product_uid) from product_extra_info';
		if(!empty($option['shop_uid'])) {
			$where_arr[] = 'shop_uid = '.$option['shop_uid'];
		}
		if(!empty($option['key'])) {
			$where_arr[] = 'data like "%'.addslashes($option['key']).'%"';
		}
		if(!empty($option['ukeys']) && is_array($option['ukeys'])) {
			foreach($option['ukeys'] as $k => $v) {
				if(is_numeric($k)) continue; 
				if(!is_array($v)) $v = array($v);
				$like = array();
				foreach($v as $vv) {
					if($vv)
					$like[] = 'data like "%'.addslashes($vv).'%"';
				}
				if($like)
				$where_arr[] = '(ukey="'.addslashes($k).'" && ('.implode(' || ', $like).'))';
			}
		}
		
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		
		return Dba::readAllOne($sql);
	}

	public static function get_product_content($uid){
		$sql = 'select content from product where uid = '.$uid;

		return Dba::readOne($sql);
	}
	//检测商品是收藏
	public static function get_product_fav($option){
		$sql = 'select * from product_fav';
		if(!empty($option['user_uid'])) {
			$where_arr[] = 'user_id ='.$option['user_id'];
		}
		if(!empty($option['product_uid'])) {
			$where_arr[] = 'product_uid ='.$option['product_uid'];
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		return Dba::readOne($sql);
	}

}

