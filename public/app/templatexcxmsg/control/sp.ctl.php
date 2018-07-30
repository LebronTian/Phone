<?php

class SpCtl {

	/*
		获取左侧菜单项
	*/
	public function get_menu_array()
	{
		/*
			activeurl 确定是否为选中状态
		*/
		//这一句用于防止子账号模块报错
		uct_use_app('templatexcxmsg');
		$even_arr = Templatexcx_Msg_WxPlugMod::get_even_arr();
		$menus_arr_key =array();
		foreach ($even_arr as $ek => $e)
			foreach ($e as $k => $menus)
				(in_array($ek,$menus_arr_key) || $menus_arr_key[] = $ek) &&
				$menus_arr[$ek][] = array('name'      => $menus['title'],
					'icon'      => 'am-icon-comment',
					'link'      => '?_a=templatexcxmsg&_u=sp.templatelist&even=' . (1000 * $ek + $k),
					'activeurl' => 'sp.templatelist&even=' . (1000 * $ek + $k),
				);

		return array(
			array('name'      => '首页',
			      'icon'      => 'am-icon-home',
			      'link'      => '?_a=templatexcxmsg&_u=sp',
			      'activeurl' => 'sp.index'),
			array('name'      => '发送记录',
			      'icon'      => 'am-icon-list',
			      'link'      => '?_a=templatexcxmsg&_u=sp.record',
			      'activeurl' => 'sp.record'),
			array('name'  => '微商城通知',
			      'icon'  => 'am-icon-shopping-cart',
			      'menus' => $menus_arr[$menus_arr_key[0]],
			),
			array('name'  => '会员相关',
			      'icon'  => 'am-icon-shopping-cart',
			      'menus' => $menus_arr[$menus_arr_key[1]],
			),
			array('name'  => '分销相关',
			      'icon'  => 'am-icon-shopping-cart',
			      'menus' => $menus_arr[$menus_arr_key[2]],
			),

		);
	}

	protected function sp_render($params = array())
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$ret = Dba::readAllOne('select weixin_plugins_installed.dir from weixin_plugins_installed'.
								' left join weixin_public on weixin_public.uid = weixin_plugins_installed.public_uid'.
								' where weixin_public.sp_uid ='.$sp_uid.
								' and weixin_plugins_installed.dir in ("shop","old") ');
		$params['menu_array'] = $this->get_menu_array();
		if(!in_array('shop',$ret)) unset($params['menu_array']['2']);
		if(!in_array('old',$ret)) unset($params['menu_array']['3']);

		if(empty($_REQUEST['_admin']) || !(defined('DEBUG_WXPAY') && DEBUG_WXPAY) ||
			AccountMod::get_current_service_provider('name') != '刘路浩') {
			//array_pop($params['menu_array']);
		}

		render_sp_inner('', $params);
	}

	/*
	 * 主页 用于科普
	 * 1、只有认证公众号由此功能
	 * 2、需在微信后台开通
	 * 3、配置麻烦 保持耐心
	 */
	public function index()
	{
		$params = array();
		$this->sp_render($params);
	}

	/*
		小程序主动推送模板消息
	*/
	public function push() {
		if(!($public_uid = requestInt('public_uid')) || !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
			$public['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
			$public_uid = WeixinMod::get_current_weixin_public('uid');
		}

		$sendtemplatemsg_send_status = $GLOBALS['arraydb_job']['sendtemplatemsg_send'.$public_uid];

		$params = array(
			'public_uid'=>$public_uid,
			'sendtemplatemsg_send_status'=>$sendtemplatemsg_send_status,
		);
		$this->sp_render($params);
	}

	public function templatelist()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if (!($even = requestInt('even')) ||
			!(isset($_REQUEST['even']))
		)
		{
			$GLOBALS['_UCT']['ACT'] = 'index';

			return $this->index();
		}

		//获取认证的服务号 列表
		$option['sp_uid']      = $sp_uid;
		$option['public_type'] = 24;  //认证服务号
		$public                = WeixinMod::get_weixin_public_list($option);

		//获取该事件 模板消息配置列表
		$even_arr          =Templatexcx_Msg_WxPlugMod::get_even_arr();
		$even_arr          = $even_arr[floor($even / 1000)];
		$option['even']    = $even_arr[($even % 1000)]['key'];
		$option['title']   = $even_arr[($even % 1000)]['title'];
		$option['public_uid'] = WeixinMod::get_current_weixin_public('uid');
		$option['page']    = requestInt('page');
		$option['limit']   = requestInt('limit', -1);

		$template_user_set_list = Templatexcx_Msg_WxPlugMod::get_templatexcx_msg_set_list($option);
		$pagination        = uct_pagination($option['page'], ceil($template_user_set_list['count'] / $option['limit']),
			'?_a='.$GLOBALS['_UCT']['APP'].'&_u=sp.'.$GLOBALS['_UCT']['ACT'].'&limit=' . $option['limit'] . '&page=');


		$params = array('public'            => $public,
		                'template_user_set_list' => $template_user_set_list,
		                'option'            => $option,
		                'pagination'        => $pagination);
		$this->sp_render($params);
	}

	/*
		添加/编辑 模板消息通知
	*/
	public function templateset() {
		$template_user_set['sp_uid'] = AccountMod::get_current_service_provider('uid');
		if(!$template_user_set['public_uid'] = requestInt('public_uid')) {
			$template_user_set['public_uid'] = WeixinMod::get_current_weixin_public('uid');
		}

		if (!($even = requestInt('even')) || empty($template_user_set['public_uid'])) {
			redirectTo('?_a=templatexcxmsg&_u=sp.index');
		}
		if($template_user_set['uid'] = requestInt('uid')) {
			$template_user_set = Templatexcx_Msg_WxPlugMod::get_user_template_by_uid($template_user_set['uid']);
			if(!empty($template_user_set['template_data']))
			{
				$template_user_set['template_data'] = Templatexcx_Msg_WxPlugMod::get_template_data_back($template_user_set['template_data'],floor($even / 1000));
			}
		}

		$even_args_arr = Templatexcx_Msg_WxPlugMod::get_even_args_arr(floor($even / 1000));
		$even_arr = Templatexcx_Msg_WxPlugMod::get_even_arr();
		$even_arr          = $even_arr[floor($even / 1000)];
		$even_title   = $even_arr[($even % 1000)]['title'];
		$params = array('even' => $even,
		                'even_title'=>$even_title,
		                'even_args_arr' =>$even_args_arr,
		                'template_user_set' => $template_user_set,
		                );
		$this->sp_render($params);
	}

	/*
		发送记录
	*/
	public function record() {
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['page'] =requestInt('page');
		$option['limit'] = requestInt('limit',10);
		isset($_REQUEST['public_uid']) && $option['public_uid'] = requestInt('public_uid');
		isset($_REQUEST['even']) && $option['even'] = requestString('even');
		isset($_REQUEST['su_uid']) && $option['su_uid'] = requestInt('su_uid');
		isset($_REQUEST['status']) && $option['status'] = requestInt('status');

 		$templatexcx_msg_record  = Templatexcx_Msg_WxPlugMod::get_templatexcx_msg_record_list($option);
		$even_arrs = Templatexcx_Msg_WxPlugMod::get_even_arr();
		$even_arr =array();
		foreach($even_arrs as $ek=>$e_arr)
		{
			foreach($e_arr as $arr)
			{
				$select_arr[$ek][$arr['key']] = $arr['title'];
				$even_arr[$arr['key']] = $arr['title'];
			}
		}

        $pagination = uct_pagination($option['page'], ceil($templatexcx_msg_record['count']/$option['limit']),
            '?_a=templatexcxmsg&_u=sp.record&page=');


        $params = array('templatexcx_msg_record'=>$templatexcx_msg_record,'even_arr'=>$even_arr,'select_arr'=>$select_arr,'pagination' => $pagination);
		$this->sp_render($params);
	}

}

