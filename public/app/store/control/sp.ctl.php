<?php

class SpCtl {
	/*
		获取左侧菜单项
	*/
	public function get_menu_array() {
		/*
			activeurl 确定是否为选中状态
		*/
		return array(
			array('name' => '首页', 'icon' => 'am-icon-home', 'link' => '?_a=store&_u=sp', 'activeurl' => 'sp.index'),
			array('name' => '门店列表', 'icon' => 'am-icon-home', 'link' => '?_a=store&_u=sp.storelist', 'activeurl' => 'sp.storelist'),
            array('name' => '门店优惠劵管理', 'icon' => 'am-icon-money', 'menus' => array(
                array('name' => '优惠券种类', 'icon' => 'am-icon-list', 'link' => '?_a=store&_u=sp.storecoupon',
                    'activeurl' => 'sp.storecoupon'),
                #array('name' => '发放记录', 'icon' => 'am-icon-list', 'link' => '?_a=store&_u=sp.usercoupon',
                #    'activeurl' => 'sp.usercoupon'),
                array('name' => '发放记录', 'icon' => 'am-icon-line-chart', 'link' => '?_a=store&_u=sp.couponecharts',
                    'activeurl' => 'sp.couponecharts'),
            )),

			/*
				hide的菜单不显示出来，但是可以作为权限控制
			*/
			array('hide' => 1, 'name' => '添加门店', 'icon' => 'am-icon-plus', 'link' => '?_a=store&_u=sp.addstore', 'activeurl' => 'sp.addstore'),
			array('hide' => 1, 'name' => '添加优惠券', 'icon' => 'am-icon-plus', 'link' => '?_a=store&_u=sp.addstorecoupon', 'activeurl' => 'sp.addstorecoupon'),
			array('name' => '核销员管理', 'icon' => 'am-icon-user', 'link' => '?_a=store&_u=sp.writeofferlist', 'activeurl' => 'sp.writeofferlist'),
		);
	}

	protected function sp_render($params = array()) {
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index() {
		$params = array();
		$this->sp_render($params);
	}

	public function storelist() {
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$stores = StoreMod::get_store_list($option);
		$pagination = uct_pagination($option['page'], ceil($stores['count']/$option['limit']), 
						'?_a=store&_u=sp.storelist&key='.$option['key'].'&limit='.$option['limit'].'&page=');
		
		$params = array('option' => $option, 'stores' => $stores, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	public function addstore() {
		$store_uid = requestInt('uid');
		$store = array();
		if($store_uid) {
			$store = StoreMod::get_store_by_uid($store_uid);
			if(!$store || ($store['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
				$store = array();
			}
		}

		$params = array('store' => $store);
		$this->sp_render($params);
	}

    /*
        门店优惠劵
    */
    public function storecoupon() {
        $option['sp_uid'] = AccountMod::get_current_service_provider('uid');
        $option['store_uid'] = requestInt('store_uid');
        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', 10);
        $data = StoreCouponMod::get_store_coupon_list($option);
        $pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']),
            '?_a=store&_u=sp.storecoupon&store_uid='.$option['store_uid'].'&limit='.$option['limit'].'&page=');

		$option2 = array('sp_uid' => AccountMod::get_current_service_provider('uid'), 'status' => 0, 'page' => 0, 'limit' => -1);
		$stores = StoreMod::get_store_list($option2);
        $params = array('option' => $option, 'data' => $data, 'pagination' => $pagination, 'stores' => $stores);
        $this->sp_render($params);
    }

    /*
        添加编辑优惠劵
    */
    public function addstorecoupon() {
        $coupon_uid = requestInt('uid');
        $coupon = array();
        if($coupon_uid) {
            $coupon = StoreCouponMod::get_store_coupon_by_uid($coupon_uid);
            if(!$coupon || ($coupon['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
                $coupon= array();
            }
        }

		$option2 = array('sp_uid' => AccountMod::get_current_service_provider('uid'), 'status' => 0, 'page' => 0, 'limit' => -1);
		$stores = StoreMod::get_store_list($option2);
        $params = array('coupon' => $coupon, 'stores' => $stores);
        $this->sp_render($params);
    }

    /*
        已发放的优惠劵
    */
    public function usercoupon() {
        $option['sp_uid'] = AccountMod::get_current_service_provider('uid');
        $option['store_uid'] = requestInt('store_uid');
        $option['writeoff'] = requestInt('writeoff');
        $option['coupon_uid'] = requestInt('coupon_uid');
        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', 10);
        $data = StoreCouponMod::get_user_coupon_list($option);
        $pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']),
            '?_a=store&_u=sp.usercoupon&store_uid='.$option['store_uid'].'&coupon_uid='.$option['coupon_uid']
			.'&writeoff='.$option['writeoff'].'&limit='.$option['limit'].'&page=');

		$option2 = array('sp_uid' => AccountMod::get_current_service_provider('uid'), 'status' => 0, 'page' => 0, 'limit' => -1);
		$stores = StoreMod::get_store_list($option2);

		$option3 = array('sp_uid' => AccountMod::get_current_service_provider('uid'), 'page' => 0, 'limit' => -1);
		$coupons = StoreCouponMod::get_store_coupon_list($option3);
        $params = array('option' => $option, 'data' => $data, 'pagination' => $pagination, 'stores' => $stores, 'coupons' => $coupons);
        $this->sp_render($params);
    }

    /*
        excel 数据下载 已发放的优惠劵
    */
    public function excel_usercoupon() {
        $option['sp_uid'] = AccountMod::get_current_service_provider('uid');
        $option['store_uid'] = requestInt('store_uid');
        $option['writeoff'] = requestInt('writeoff');
        $option['coupon_uid'] = requestInt('coupon_uid');
        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', -1);
        $cs = StoreCouponMod::get_user_coupon_list($option);
		if(!$cs['list']) {
			echo '暂无数据！';
			return;
		}

		$header = array('优惠券名称', '顾客名称',  '发放时间',  '核销时间', );
		$data = array();
		foreach($cs['list'] as $c) {
			$u = AccountMod::get_service_user_by_uid($c['user_id']);
			$item = array(
				$c['info']['title'],
				($u['name'] ? $u['name'] : $u['account']),
				date('y-m-d H:i:s', $c['create_time']),
				($c['used_time'] ? date('y-m-d H:i:s', $c['used_time']) : '未核销'),
			);
			$data[] = $item;
		}

		$option = array('header' => $header, 'download' => true, 'title' => '门店优惠券');
		require_once UCT_PATH.'vendor/phpExcel/export.php';
		export_to_excel($data, $option);	
		exit();
    }

    /*
        发放用户优惠劵
    */
    public function addusercoupon() {
        $coupon_uid = requestInt('coupon_uid');
        $coupons = StoreCouponMod::get_store_coupon_list(array('sp_uid' => AccountMod::get_current_service_provider('uid'), 
																'available' => 1,'page' => 0, 'limit' => -1));
        $params = array('coupon_uid' => $coupon_uid, 'coupons' => $coupons);
        $this->sp_render($params);
    }

	/*
		优惠券统计图表
	*/
	public function couponecharts() {
		$store_uid = requestInt('store_uid'); //只看某个门店的数据
		

		$sp_uid = AccountMod::get_current_service_provider('uid');
		$today = strtotime('today');
		$sql = 'select count(*) from store_user_coupon where sp_uid = '.$sp_uid; 
		if($store_uid) {
			$sql .= ' && (store_uid = '.$store_uid.' || info like \'%"store_uids":["'.$store_uid.'"]%\')';
		}

		$cnts['total_coupons_cnt'] = Dba::readOne($sql); 
	
		$sql .= '&& create_time >= '.$today;
		$cnts['today_coupons_cnt'] = Dba::readOne($sql); 
				

		$sql = 'select count(*) from store_user_coupon where sp_uid = '.$sp_uid.' && used_time > 0';
		if($store_uid) {
			$sql .= ' && (store_uid = '.$store_uid.' || info like \'%"store_uids":["'.$store_uid.'"]%\')';
		}
		$cnts['total_writeoff_cnt'] = Dba::readOne($sql); 

		$sql .= '&& used_time >= '.$today;
		$cnts['today_writeoff_cnt'] = Dba::readOne($sql); 

		/*
		$sql = 'select count(*), substr(sign_code,1,3) as sc from bigidea_mcdonald_user join service_user on bigidea_mcdonald_user.su_uid 
				= service_user.uid where service_user.create_time >= '.$today.'group by sc';
		$params['today_users_store'] = Dba::readAllAssoc($sql);
		*/
		if($store_uid) {
			$s= StoreMod::get_store_by_uid($store_uid);
			if($s && $s['sp_uid'] == $sp_uid) {
				$stores = array($s);
			}
			else {
				$stores = array();
			}
		}
		else {
			$option = array('sp_uid' => $sp_uid, 'page' => 0, 'limit' => -1);
			$stores = StoreMod::get_store_list($option);
			$stores = $stores['list'];
		}
		$i=-1;
		$echarts=array();
		if($stores)
		foreach($stores as $s) {
			$i++;
			//$sc = 'SZ'.chr(ord('A') + $i);
			$echarts['xAxis']['data'][] = $s['name'];
			$sql = 'select count(*) from store_user_coupon where sp_uid = '.$sp_uid
					.' && (store_uid = '.$s['uid'].' || info like \'%"store_uids":["'.$s['uid'].'"]%\')';
			$echarts['series'][0]['data'][$i] = Dba::readOne($sql);//历史发放
			$sql2 = $sql.' && used_time > 0';
			$echarts['series'][2]['data'][$i] = Dba::readOne($sql2);//历史核销

			$sql .= ' && create_time >= '.$today;
			$echarts['series'][1]['data'][$i] = Dba::readOne($sql);//今日发放
			$echarts['series'][0]['data'][$i] -= $echarts['series'][1]['data'][$i];

			$sql2 .= ' && used_time >= '.$today;
			$echarts['series'][3]['data'][$i] = Dba::readOne($sql2);//今日核销
			$echarts['series'][2]['data'][$i] -= $echarts['series'][3]['data'][$i];
		}
		if(!empty($echarts)){
			$echarts['series'][0]['data'] = (is_array($echarts['series'][0]['data'])?array_values($echarts['series'][0]['data']):array()) ;
			$echarts['series'][1]['data'] = (is_array($echarts['series'][1]['data'])?array_values($echarts['series'][1]['data']):array());
			$echarts['series'][2]['data'] = (is_array($echarts['series'][2]['data'])?array_values($echarts['series'][2]['data']):array());
			$echarts['series'][3]['data'] = (is_array($echarts['series'][3]['data'])?array_values($echarts['series'][3]['data']):array());
		}


		$echarts2=array();
        $coupons = StoreCouponMod::get_store_coupon_list(array('sp_uid' => $sp_uid, 'store_uid' => $store_uid, 'page' => 0, 'limit' => -1));
		$coupons = $coupons['list'];
		if($coupons) {
			foreach($coupons as $c) {
				$cnt = Dba::readOne('select count(*) from store_user_coupon where sp_uid = '.$sp_uid.' && coupon_uid = '.$c['uid']);
				if(!$cnt) $cnt = 0;
				$echarts2['legend']['data'][]=$c['title'];
				$echarts2['series'][0]['data'][]=array('value'=>$cnt,'name'=>$c['title']);	
			}
		}
																
		$params = array('cnts' => $cnts, 'echarts' => $echarts, 'echarts2' => $echarts2, 'stores' => $stores, 'store_uid' => $store_uid);
		$this->sp_render($params);
	}

	/*
		核销员列表
	*/
	public function writeofferlist() {
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['status'] = requestInt('status', -1); //

		$data = StoreWriteoffMod::get_writeoffer($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=store&_u=sp.writeofferlist&key='
						.$option['key'].'&status='.$option['status'].'&limit='.$option['limit'].'&page=');
		
		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		添加核销员
	*/
	public function addwriteoffer() {
		$option2 = array('sp_uid' => AccountMod::get_current_service_provider('uid'), 'status' => 0, 'page' => 0, 'limit' => -1);
		$stores = StoreMod::get_store_list($option2);

		$params = array('stores' => $stores);
		$this->sp_render($params);
	}
}

