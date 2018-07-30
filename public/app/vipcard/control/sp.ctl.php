<?php

class SpCtl {

	public function get_menu_array()
	{
		$app = $GLOBALS['_UCT']['APP'];

		/*
			activeurl 确定是否为选中状态
		*/

		return array(
			array('name'      => '首页',
			      'icon'      => 'am-icon-home',
			      'link'      => '?_a=' . $app . '&_u=sp',
			      'activeurl' => 'sp.index'),
			array('name'      => '设置会员',
				'icon'      => 'am-icon-user',
				'link'      => '?_a=' . $app . '&_u=sp.set_vip_su',
				'activeurl' => 'sp.set_vip_su'),
			array('name'      => '会员列表',
			      'icon'      => 'am-icon-users',
			      'link'      => '?_a=' . $app . '&_u=sp.vip_card_list',
			      'activeurl' => 'sp.vip_card_list'),
			array('name'      => '基本设置',
			      'icon'      => 'am-icon-gear',
			      'link'      => '?_a=' . $app . '&_u=sp.set',
			      'activeurl' => 'sp.set'),
			array('name'  => '会员卡设置',
			      'icon'  => 'am-icon-gears',
			      'menus' => array(
				      array('name'      => '会员卡样式',
				            'icon'      => 'am-icon-files-o',
				            'link'      => '?_a=' . $app . '&_u=sp.tplset',
				            'activeurl' => 'sp.tplset'),
				      array('name'      => '底图样式',
				            'icon'      => 'am-icon-photo',
				            'link'      => '?_a=' . $app . '&_u=sp.uiset',
				            'activeurl' => 'sp.uiset'),
				      array('name'      => '文字样式',
				            'icon'      => 'am-icon-font',
				            'link'      => '?_a=' . $app . '&_u=sp.uiset2',
				            'activeurl' => 'sp.uiset2'),
				      array('name'      => '开卡资料设置',
				            'icon'      => 'am-icon-list-alt',
				            'link'      => '?_a=' . $app . '&_u=sp.connentset',
				            'activeurl' => 'sp.connentset'),
				      array('name'      => '等级积分设置',
				            'icon'      => 'am-icon-star',
				            'link'      => '?_a=' . $app . '&_u=sp.ruleset',
				            'activeurl' => 'sp.ruleset'),
			      )),
		);
	}

	protected function sp_render($params = array())
	{
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index()
	{
		$sp_uid            = AccountMod::get_current_service_provider('uid');
		$sql               = 'select count(*) from vip_card_su left join service_user on service_user.uid=vip_card_su.su_uid where service_user.sp_uid=' . $sp_uid;
		$total_vipcard_cnt = Dba::readone($sql);
		$sql1              = $sql . ' and vip_card_su.create_time >=' . strtotime('today');
		$today_vipcard_cnt = Dba::readone($sql1);
		$sql2              = $sql . ' and vip_card_su.status=1';
		$total_uncheck_cnt = Dba::readone($sql2);
		$cnts              = array(
			'total_vipcard_cnt' => $total_vipcard_cnt,
			'today_vipcard_cnt' => $today_vipcard_cnt,
			'total_uncheck_cnt' => $total_uncheck_cnt,
		);
		$params            = array('cnts' => $cnts);
		//		var_dump(__file__.' line:'.__line__,$sql2);exit;
		$this->sp_render($params);
	}

	//初始化 会员卡
	public function init_vip_card()
	{
		if (($sp_uid = AccountMod::get_current_service_provider('uid')) &&
			!($vip_card_set = VipcardMod::get_vip_card_sp_set_by_sp_uid($sp_uid))
		)
		{
			$vip_card_set['sp_uid']     = $sp_uid;
			$vip_card_set['public_uid'] = WeixinMod::get_current_weixin_public('uid');
			VipcardMod::add_or_edit_vip_card_sp_set($vip_card_set);
			$vip_card_set = VipcardMod::get_vip_card_sp_set_by_sp_uid($sp_uid);
		}

		return $vip_card_set;
	}

	public function tplset()
	{
		$vip_card_set      = $this->init_vip_card();
		$option['sp_uid']  = AccountMod::get_current_service_provider('uid');
		$option['status']  = 1;//商户取 启用的
		$option['page']    = requestInt('page', 0);
		$option['limit']   = requestInt('limit', 10);
		$vip_card_tpl_list = VipcardMod::get_vip_card_tpl_list($option);
		//		var_dump(__file__.' line:'.__line__,$vip_card_tpl_list);exit;
		$pagination = uct_pagination($option['page'], ceil($vip_card_tpl_list['count'] / $option['limit']), '?_a=' .
			$GLOBALS['_UCT']['APP'] . '&_u=' . $GLOBALS['_UCT']['CTL'] . '.' . $GLOBALS['_UCT']['ACT'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('vip_card_set'      => $vip_card_set,
		                'vip_card_tpl_list' => $vip_card_tpl_list,
		                'pagination'        => $pagination);
		$this->sp_render($params);
	}


	public function uiset()
	{
		$vip_card_set = $this->init_vip_card();
		if (empty($vip_card_set['vip_card_tpl_uid']))
		{
			$GLOBALS['_UCT']['ACT'] = 'tplset';

			return $this->tplset();
		}
		$vip_card_tpl = VipcardMod::get_vip_card_tpl_by_uid($vip_card_set['vip_card_tpl_uid']);
		$vip_card_tpl = $vip_card_tpl['data'];
		$params       = array('vip_card_set' => $vip_card_set, 'vip_card_tpl' => $vip_card_tpl);
		$this->sp_render($params);
	}

	/*
		spv3 的 会员卡设置
	*/
	public function uiset33()
	{
		$vip_card_set = $this->init_vip_card();
		if (empty($vip_card_set['vip_card_tpl_uid']))
		{
			$dft = array (	
				#'sp_uid' => AccountMod::get_current_service_provider('uid'),
				#'public_uid' => WeixinMod::get_current_weixin_public('uid'),
				'rank_rule' => array(1=> array('rank_name' => 'VIP会员', 'rank_discount' => 100)),
			'connent' => array(
				'name' => array('need' => 0, 'title' => '姓名', 'group' => 'user', 'show' => 1, 'value' => '',),
				'phone' => array('need' => 0, 'title' => '手机', 'group' => 'user_profile', 'show' => 1, 'value' => '',),
				'address' => array('need' => 0, 'title' => '地址', 'group' => 'user_profile', 'show' => 1, 'value' => '',),
				),
			'ui_set' => array(
				'back_ground' => array('path' => '/app/vipcard/static/images/spv3vip.jpg', 'color' => '', 'size' => array(500,300)),	
				'image' => array(
					'logo' =>  array('path' => '', 'size' => array(80,80), 'point' => array(5, 5)),	
				),

				'other_rule' => array(
					'readme' => '1. 仅限本人使用  2. 有效期1年  3. 各门店均有效 ',
					'first_point' => 1, //赠送积分
					'baoyou' => 0, //包邮
					'youhuiquan' => 0, //优惠券
				),
				),
			'vip_card_tpl_uid' => 999999, //not exist
			);	
			
			$vip_card_set = array_merge($vip_card_set, $dft);
			VipcardMod::add_or_edit_vip_card_sp_set($vip_card_set);
			
			//$GLOBALS['_UCT']['ACT'] = 'tplset';
			//return $this->tplset();
		}
		#$vip_card_tpl = VipcardMod::get_vip_card_tpl_by_uid($vip_card_set['vip_card_tpl_uid']);
		#$vip_card_tpl = $vip_card_tpl['data'];
		$params       = array('card' => $vip_card_set);
		$this->sp_render($params);
	}

	public function connentset()
	{
		$vip_card_set = $this->init_vip_card();
		if (empty($vip_card_set['ui_set']))
		{
			$GLOBALS['_UCT']['ACT'] = 'uiset';

			return $this->uiset();
		}
		//保留字段
		$retain_field = VipcardMod::get_retain_field_arr();


		$params = array('vip_card_set' => $vip_card_set,
		                'retain_field' => $retain_field,
		                'connent'      => $vip_card_set['connent'],);
		$this->sp_render($params);
	}

	public function uiset2()
	{
		$vip_card_set = $this->init_vip_card();
		if (empty($vip_card_set['connent']))
		{
			$GLOBALS['_UCT']['ACT'] = 'connent';

			return $this->uiset();
		}
		//保留字段
		$connent_show_arr = array();
		$retain_field     = VipcardMod::get_retain_field_arr();
		foreach ($vip_card_set['connent'] as $ck => $cv)
		{
			if (!isset($retain_field[$cv['group']][$ck]))
			{

				$retain_field['vip_card_su'] = array_merge($retain_field['vip_card_su'],
					array($ck => (!empty($cv['title']) ? $cv['title'] : '自定义字段' . (strtr($ck, array('other_' => ''))))));
			}
			if (!empty($cv['show']))
			{
				($ck == 'avatar') && $connent_show_arr['image'][$cv['show']] = $ck;
				($ck != 'avatar') && $connent_show_arr['string'][$cv['show']] = $ck;
			}
		}


		$params = array('vip_card_set'     => $vip_card_set,
		                'connent'          => $vip_card_set['connent'],
		                'retain_field'     => $retain_field,
		                'connent_show_arr' => $connent_show_arr);
		$this->sp_render($params);
	}


	public function ruleset()
	{
		$vip_card_set = $this->init_vip_card();
		$params       = array('vip_card_set' => $vip_card_set);
		$this->sp_render($params);
	}

	public function vip_card_list()
	{

		$vip_card_set         = $this->init_vip_card();
		$option['sp_uid']     = $vip_card_set['sp_uid'];
		$option['public_uid'] = requestInt('public_uid');
		$option['page']       = requestInt('page', 0);
		$option['limit']      = requestInt('limit', 10);
		isset($_REQUEST['status']) && $option['status'] = requestInt('status');
		$option['key'] = requeststring('key');
		//短 会员卡 直接返回为uid 长会员卡为数组 取最后一个
		$option['card_id'] = requeststring('card_id');
		!empty($option['card_id'])
		&& ($option['card_ids'] = get_ps_int($option['card_id']))
		&& is_array($option['card_ids'])
		&& ($option['card_ids'] =$option['card_ids'][2]);
		$vip_card_list = VipcardMod::get_vip_card_list($option);
		$pagination    = uct_pagination($option['page'], ceil($vip_card_list['count'] / $option['limit']),
			'?_a=' . $GLOBALS['_UCT']['APP'] .
			'&_u=' . $GLOBALS['_UCT']['CTL'] . '.' . $GLOBALS['_UCT']['ACT'] .
			'&limit=' . $option['limit'] .
			'&key=' . $option['key'] .
			'&card_id=' . $option['card_id'] .
			'&page=');
		$params        = array('vip_card_set'  => $vip_card_set,
		                       'vip_card_list' => $vip_card_list,
		                       'option'        => $option,
		                       'pagination'    => $pagination);


		$this->sp_render($params);
	}

	public function edittpl()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if (!($uid = requestInt('uid'))
			|| !($vipcardtpl = VipcardMod::get_vip_card_tpl_by_uid($uid))
			|| !($sp_uid  == $vipcardtpl['sp_uid'] || $vipcardtpl['sp_uid']==0 )
		)
		{
			$GLOBALS['_UCT']['ACT'] = 'tplset';

			return $this->tplset();
		}
		;
		$params     = array('vipcardtpl' => $vipcardtpl);

		$this->sp_render($params);
	}

	public function set()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$vip_card_sp_set = VipcardMod::get_vip_card_sp_set_by_sp_uid($sp_uid);
		$params     = array('vip_card_sp_set' => $vip_card_sp_set);
		$this->sp_render($params);
	}

	public function set_vip_su()
	{
		$vip_card_set = $this->init_vip_card();
//		header('Content-Type:text/html;charset=utf-8');
//		var_dump($vip_card_set['rank_rule']);
		$params       = array('rank_rule' => $vip_card_set['rank_rule']);
		$this->sp_render($params);
	}

}
