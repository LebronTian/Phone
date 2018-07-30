<?php

class SpCtl {
	public function get_menu_array() {
		return array(
			array('name' => '首页', 'icon' => 'am-icon-home', 'link' => '?_a=shopdist&_u=sp', 'activeurl' => 'sp.index'),
		);
	}

	protected function sp_render($params = array())
	{
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}


	public function index() {
		redirectTo('?_a=shopdist&_u=sp.distribution');
	}


	/*
	 * 三级分销主页
	 */
	public function distribution()
	{
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$dtb = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);
		if(!$dtb){
			//默认设置
			$dtb_rule['shop_uid'] = $shop['uid'];
			$dtb_rule['create_time'] = $_SERVER['REQUEST_TIME'];
			$dtb_rule['rule_data'] = array(array(0,0),array(0,0),array(0,0),array(0,0));
			DistributionMod::add_or_edit_dtb_rule($dtb_rule);
			$dtb = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);
		}

		$params = array('shop' => $shop, 'dtb' => $dtb);
		$this->sp_render($params);
	}

    /*
     * 分销商品列表
     */
    public function distribution_productlist()
    {
		uct_use_app('shop');
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            return $this->error();
        }
        $option['shop_uid']  = $shop['uid'];
        $option['page']      = requestInt('page');
        $option['limit']     = requestInt('limit', 10);
        $option['status']    = requestInt('status'); //

        $products   = DistributionMod::get_product_dtb_rule_by_shop_uid($option);

        $pagination = uct_pagination($option['page'], ceil($products['count'] / $option['limit']),'?_a=shopdist&_u=sp.distribution_productlist&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');
        //		var_dump(__file__.' line:'.__line__,$products);exit;
        $params = array('shop'       => $shop,
                        'option'     => $option,
                        'products'   => $products,
                        'pagination' => $pagination);

        $this->sp_render($params);
    }

    /*
     * 分销商品详情
     */
    public function adddistribution_product()
    {
		uct_use_app('shop');
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            return $this->error();
        }
        $dtb_uid = requestInt('uid');
        $dtb     = array();
        $dtb['p_uid'] = requestInt('p_uid');
        if ($dtb_uid)
        {
            $dtb = DistributionMod::get_product_dtb_rule_by_uid($dtb_uid);
            if (!$dtb || ($dtb['shop_uid'] != $shop['uid']))
            {
                $dtb = array();
            }
        }else if($dtb['p_uid'])
        {
            $dtb = DistributionMod::get_dtb_rule_by_shop_product_uid($shop['uid'],$dtb['p_uid']);
            if (!$dtb || ($dtb['shop_uid'] != $shop['uid']))
            {
                $dtb['p_uid'] = requestInt('p_uid');
            }
        }
//var_export($dtb);
        $params     = array('shop' => $shop, 'dtb' => $dtb);
        $this->sp_render($params);
    }

	/*
	 * 分销记录
	 */
	public function orderlist()
	{
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['key']    = requestString('key', PATTERN_SEARCH_KEY);
		$option['su_uid'] = requestInt('su_uid');
		isset($_REQUEST['parent_su_uid']) && $option['parent_su_uid'] = requestInt('parent_su_uid');
		isset($_REQUEST['level']) && $option['level'] = requestInt('level');
		$option['order_uid'] = requestInt('order_uid');
		$option['limit']     = requestInt('limit', 10);
		$option['page']      = requestInt('page', 0);
		$option['sp_uid'] = $shop['sp_uid'];
		$dtblist = DistributionMod::get_dtb_record_list($option);

		$pagination = uct_pagination($option['page'], ceil($dtblist['count'] / $option['limit']),
			'?_a=shopdist&_u=sp.orderlist&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');
		$params     = array('shop' => $shop, 'dtblist' => $dtblist, 'option' => $option, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
	 * 分销成员设置
	 */
	public function distribution_user_set()
	{
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		if(!($su_uid = requestInt('uid')) || !($su = AccountMod::get_service_user_by_uid($su_uid)) ||
			($su['sp_uid'] != $shop['sp_uid'])) {
			$su = array();
		}
		if(!$su || !($dtb = DistributionMod::get_user_dtb_by_su_uid($su['uid']))) {
			$dtb = array();
		}	
		

		$this->sp_render(array('shop' => $shop, 'su' => $su, 'dtb' => $dtb));
	}

	/*
	 * 指定用户分组的分销设置
	 */
	public function distribution_user_group_set()
	{
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			return $this->error();
		}
		uct_use_app('su');

		if(!($g_uid = requestInt('uid')) || !($group = SuGroupMod::get_group_by_uid($g_uid)) ||
			($group['sp_uid'] != $shop['sp_uid'])) {
			$group = array();
		}
		if(!$group || !($dtb = DistributionMod::get_su_group_dtb($group['uid']))) {
			$dtb = array();
		}	
		$groups = SuGroupMod::get_sp_groups($shop['sp_uid']);
		

		$this->sp_render(array('shop' => $shop, 'groups' => $groups, 'group' => $group, 'dtb' => $dtb));
	}

	/*
	 * 分销用户表
	 */
	public function distribution_user_list()
	{
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['sp_uid'] = $shop['sp_uid'];
		$option['su_uid'] = requestInt('su_uid');
		isset($_REQUEST['parent_su_uid']) && $option['parent_su_uid'] = requestInt('parent_su_uid');
		$option['status'] = requestInt('status');
		$option['limit']  = requestInt('limit', 10);
		$option['page']   = requestInt('page', 0);
		$option['key']    = requestString('key', PATTERN_SEARCH_KEY);

		$dtb_user_list = DistributionMod::get_user_dtb_list($option);

		$pagination = uct_pagination($option['page'], ceil($dtb_user_list['count'] / $option['limit']),
			'?_a=shopdist&_u=sp.distribution_user_list&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('shop'          => $shop,
		                'dtb_user_list' => $dtb_user_list,
		                'option'        => $option,
		                'pagination'    => $pagination);
		//				var_dump(__file__.' line:'.__line__,$params);exit;
		$this->sp_render($params);
	}

	/*
	 * 分销协议
	 */
	public function user_agreement()
	{
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['type_in'] = 3;
		$document = DocumentMod::get_documents_know($option);

		$params     = array('shop' => $shop,'document' => $document);
		$this->sp_render($params);
	}
}



