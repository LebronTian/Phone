<?php

/*
	粉丝管理
*/

class SpCtl {
	/*
		获取左侧菜单项
	*/
	public function get_menu_array()
	{
		/*
			activeurl 确定是否为选中状态
		*/
		return array(
			array('name' => '欢迎页', 'icon' => 'am-icon-home', 'link' => '?_a=su&_u=sp', 'activeurl' => 'sp.index'),
			array('name'  => '粉丝管理',
			      'icon'  => 'am-icon-weixin',
			      'menus' => array(
				      array('name'      => '粉丝列表',
				            'icon'      => 'am-icon-user',
				            'link'      => '?_a=su&_u=sp.fanslist',
				            'activeurl' => 'sp.fanslist'),
				      array('name'      => '粉丝分组',
				            'icon'      => 'am-icon-cog',
				            'link'      => '?_a=su&_u=sp.fansgroups',
				            'activeurl' => 'sp.fansgroups'),
				      array('name'      => '微信群',
				            'icon'      => 'am-icon-wechat',
				            'link'      => '?_a=su&_u=sp.wechatgroups',
				            'activeurl' => 'sp.wechatgroups'),
			      )),

//			array('name' => '配送员管理', 'icon' => 'am-icon-user', 'link' => '?_a=su&_u=sp.delivery', 'activeurl' => 'sp.delivery'),

			#array('name' => '绑定手机', 'icon' => 'am-icon-mobile', 'link' => '?_a=su&_u=sp.mobilelist', 'activeurl' => 'sp.mobilelist'),
			#array('name' => '公众号代理授权登录', 'icon' => 'am-icon-sign-in', 'link' => '?_a=su&_u=sp.wxlogin', 'activeurl' => 'sp.wxlogin'),
			array('name' => '开放注册功能', 'icon' => 'am-icon-user', 'link' => '?_a=su&_u=sp.register', 'activeurl' => 'sp.register'),
			array('name' => '批量注册账号', 'icon' => 'am-icon-android', 'link' => '?_a=su&_u=sp.batregister', 'activeurl' => 'sp.batregister'),
			array('name' => '余额变更通知', 'icon' => 'am-icon-bullhorn', 'link' => '?_a=su&_u=sp.cashnotice', 'activeurl' => 'sp.cashnotice'),
			array('name' => '充值优惠设置','icon'=> 'am-icon-cog','link' =>'?_a=su&_u=sp.cashset','activeurl' => 'sp.cashset'),
			array('name' => '用户账单列表', 'icon' => 'am-icon-list-alt', 'link' => '?_a=su&_u=sp.sucashlist', 'activeurl' => 'sp.sucashlist'),
		);
	}

	protected function sp_render($params = array())
	{
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index()
	{
		//		$fans_total = Dba::readOne('select count(*) from service_user where sp_uid = '.AccountMod::get_current_service_provider('uid'));
		//		$fans_yesterday= Dba::readOne('select count(*) from service_user where sp_uid = '.AccountMod::get_current_service_provider('uid')
		//										.' && create_time > '.strtotime('yesterday'));

		$public_uid     = WeixinMod::get_current_weixin_public('uid');
		$sp_uid         = AccountMod::get_current_service_provider('uid');
//		echo $public_uid;
		$fans_total     = Dba::readOne('select count(*) from service_user as su '
			. ' join  weixin_fans as wf on wf.su_uid=su.uid where su.sp_uid = ' . $sp_uid . ' and wf.public_uid=' . $public_uid);
		$fans_yesterday = Dba::readOne('select count(*) from service_user as su '
			. ' join  weixin_fans as wf on wf.su_uid=su.uid where wf.public_uid= ' . $public_uid . ' && su.create_time > ' . strtotime('yesterday') . ' && su.sp_uid = ' . $sp_uid);

		//统计粉丝量和增量------------
		//开始日期
		//结束日期
		//默认查询天数 10 $days
		$days     = 30;
		$today    = time();
		$beginday = time() - $days * 86400;
		$sql      = 'select from_unixtime(su.create_time,"%Y-%m-%d") as days,count(*) as count from service_user as su  join  weixin_fans as wf on wf.su_uid=su.uid' .
			' where wf.public_uid= ' . $public_uid . ' and su.create_time > ' .
			$beginday . ' and su.sp_uid = ' . AccountMod::get_current_service_provider('uid') . ' group by days';
		// $sql='select from_unixtime(create_time,"%Y-%m-%d") as days,count(*) as count from service_user where create_time > '.
		// $beginday.' and sp_uid=2 group by days';
		// var_dump($today-1*86400);exit;

		$ret      = Dba::readAllAssoc($sql);
		$addtotal = 0;
		$adds     = 0;
		if ($ret)
		{
			foreach ($ret as $r)
			{
				$addret[$r['days']]['count'] = $r['count'];
				$addtotal += $r['count'];

			}
			for ($i = $days; $i > 0; $i--)
			{
				$todaydate                  = date('Y-m-d', $today - $i * 86400);
				$echarts['xAxis']['data'][] = $todaydate;
				$addtoday                   = isset($addret[$todaydate]) ? $addret[$todaydate]['count'] : 0;
				$adds += $addtoday;
				$echarts['series'][1]['data'][]             = $addtoday;
				$echarts['series'][0]['data'][($days - $i)] = $fans_total - $addtotal + $adds;
			}
		}
		else
		{
			$echarts = '';
		}
		//男女比例-----------------
		$sql = 'select count(case su.gender when su.gender=0 then su.gender end) as unknow,' .
			'count(case su.gender when su.gender=1 then su.gender end) as man,' .
			'count(case su.gender when su.gender=2 then su.gender end) as weman ' .
			' from service_user as su join  weixin_fans as wf on wf.su_uid=su.uid' .
			' where wf.public_uid= ' . $public_uid . ' and su.sp_uid = ' . AccountMod::get_current_service_provider('uid');
		$ret = Dba::readAllAssoc($sql);

		if ($ret)
		{

			$echarts2['series'][0]['data'][] = array('value' => $ret[0]['man'], 'name' => '男生');
			$echarts2['series'][0]['data'][] = array('value' => $ret[0]['weman'], 'name' => '女生');
			$echarts2['series'][0]['data'][] = array('value' => $ret[0]['unknow'], 'name' => '未知');

		}
		else
		{
			$echarts2 = "";
		}

		//取各个省市的人数 
		$sql = 'select distinct sup.province, count(sup.province) as count from service_user as su ' .
			' left join  weixin_fans as wf on wf.su_uid=su.uid' .
			' left join service_user_profile as sup  on su.uid=sup.uid' .
			' where su.sp_uid=' . AccountMod::get_current_service_provider('uid') .
			' and wf.public_uid= ' . $public_uid .
			'  group by province';

		// $sql='select distinct province, count(province) as count from service_user_profile '.
		// 'right join service_user on service_user.uid=service_user_profile.uid group by province';
		$ret = Dba::readAllAssoc($sql);
		//				var_dump($sql,$ret);
		if (!$ret)
		{
			$echarts3 = "";
		}
		else
		{
			$echarts3['dataRange']['max'] = 0;
			foreach ($ret as $r)
			{
				if ($r['count'] > $echarts3['dataRange']['max'])
				{
					$echarts3['dataRange']['max'] = $r['count'];
				}
				$echarts3['series'][0]['data'][] = array('value' => $r['count'],
				                                         'name'  => str_replace('省', '', $r['province']));
			}
		}
		
		$params = array('fans_total'     => $fans_total,
		                'fans_yesterday' => $fans_yesterday,
		                'echarts'        => $echarts,
		                'echarts2'       => $echarts2,
		                'echarts3'       => $echarts3,

		);
		$this->sp_render($params);
	}

	/*
		粉丝列表	
	*/
	public function fanslist()
	{
		$all_public = WeixinMod::get_all_weixin_public_by_sp_uid();

		$option['sp_uid']     = AccountMod::get_current_service_provider('uid');
		$option['public_uid'] = requestInt('public_uid');
		$option['from_su_uid']= requestInt('from_su_uid');
		$option['from_su_uid2']= requestInt('from_su_uid2');
		$option['from_su_uid3']= requestInt('from_su_uid3');
		$option['uid']        = requestInt('uid');
		$option['g_uid']      = requestInt('g_uid'); //某个分组下的用户
		$option['wechat_g_uid'] = requestInt('wechat_g_uid'); //某个微信群的用户
		$option['key']        = requestString('key', PATTERN_SEARCH_KEY);
		$option['valid_account'] = requestInt('valid_account');
		$option['page']       = requestInt('page');
		$option['limit']      = requestInt('limit', 10);
		$fans                 = AccountMod::get_service_user_list($option);
		$groups               = SuGroupMod::get_sp_groups($option['sp_uid']);
        $syn_fans             = $GLOBALS['arraydb_job']['syn_fans_'.$option['sp_uid']];
		$pagination           = uct_pagination($option['page'], ceil($fans['count'] / $option['limit']),
			'?_a=su&_u=sp.fanslist&g_uid=' . $option['g_uid'] . '&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');
		$params               = array('option'     => $option,
		                              'fans'       => $fans,
		                              'groups'     => $groups,
                                      'syn_fans' =>$syn_fans,
		                              'pagination' => $pagination,
		                              'all_public' => $all_public);
		$this->sp_render($params);
	}

	public function fansdetail()
	{
		$_REQUEST['_d'] = 1;
		$uid          = requestInt('uid');
		$user         = AccountMod::get_service_user_by_uid($uid);

		if(!$user || ($user['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
			#var_export($user);die;
			redirectTo('?_a=su&_u=sp.fanslist');
		}
		$user_profile = SuMod::get_su_profile($uid);
		$user_public  = Dba::readRowAssoc('select * from weixin_fans where su_uid =' . $uid);
		$params       = array(
			'user'         => $user,
			'user_profile' => $user_profile,
			'user_public'  => $user_public,
		);
//		var_dump(__file__.' line:'.__line__,$params);exit;
//		var_dump($user['from_su_uid']);
		$this->sp_render($params);
	}


	/*
		分组列表
	*/
	public function fansgroups()
	{
		$groups = SuGroupMod::get_sp_groups(AccountMod::get_current_service_provider('uid'));
		$params = array('groups' => $groups);
		$this->sp_render($params);
	}
	
	public function addgroup()
	{
		$groups = SuGroupMod::get_sp_groups(AccountMod::get_current_service_provider('uid'));
		
		$group_uid = requestInt('uid');
		$group     = array();
		if ($group_uid)
		{
			$group = SuGroupMod::get_group_by_uid($group_uid);
		}

		$params = array('groups' => $groups, 'group' => $group);
		$this->sp_render($params);
	}

	/*
		微信群列表
	*/
	public function wechatgroups()
	{
		$groups = WechatGroupMod::get_sp_groups(AccountMod::get_current_service_provider('uid'));
		$params = array('groups' => $groups);
		$this->sp_render($params);
	}
	
	public function addwechatgroup()
	{
		$groups = WechatGroupMod::get_sp_groups(AccountMod::get_current_service_provider('uid'));
		
		$group_uid = requestInt('uid');
		$group     = array();
		if ($group_uid)
		{
			$group = WechatGroupMod::get_group_by_uid($group_uid);
		}

		$params = array('groups' => $groups, 'group' => $group);
		$this->sp_render($params);
	}


	/*
		绑定手机
	*/
	public function mobilelist()
	{
		$option['sp_uid']    = AccountMod::get_current_service_provider('uid');
		$option['sp_remark'] = requestInt('sp_remark');
		$option['page']      = requestInt('page');
		$option['limit']     = requestInt('limit', 10);

		$mobiles    = SuGroupMod::get_oauth_mobile_list($option);
		$pagination = uct_pagination($option['page'], ceil($mobiles['count'] / $option['limit']),
			'?_a=su&_u=sp.mobilelist&sp_remark=' . $option['sp_remark'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('option' => $option, 'mobiles' => $mobiles, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
	 * 赠送设置
	 */
	public function cashset()
	{
		$sp_uid  = AccountMod::get_current_service_provider('uid');

		$data = SuPointMod::get_cash_rule($sp_uid);

		$groups = SuGroupMod::get_sp_groups(AccountMod::get_current_service_provider('uid'));

		$params = array('data' => $data,'groups'=>$groups);
		$this->sp_render($params);
	}

	/*
		用户账户收支明细
	*/
	public function sucashlist() {
		$option['type'] = requestInt('type');
		$option['page'] = requestInt('page', 0);
		$option['limit'] = requestInt('limit', 10);
		$option['su_uid'] = requestInt('su_uid');
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$data = SuPointMod::get_user_cash_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=su&_u=sp.sucashlist&su_uid='.$option['su_uid'].'&type='.$option['type'].'&limit='.$option['limit'].'&page=');

		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		用户积分变动明细
	*/
	public function supointlist() {
		$option['type'] = requestInt('type');
		$option['page'] = requestInt('page', 0);
		$option['limit'] = requestInt('limit', 10);
		$option['su_uid'] = requestInt('su_uid');
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$data = SuPointMod::get_user_point_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=su&_u=sp.supointlist&su_uid='.$option['su_uid'].'&type='.$option['type'].'&limit='.$option['limit'].'&page=');

		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		微信代理授权登录
	*/
	public function wxlogin() {
		$cfg = SuWxLoginMod::get_proxy_wxlogin_cfg();

		$params = array('cfg' => $cfg);
		$this->sp_render($params);
	}

	/*
		开启/关闭注册功能
	*/
	public function register() {
		$open = SuMod::is_register_open(AccountMod::get_current_service_provider('uid'));

		$params = array('open' => $open);
		$this->sp_render($params);
	}

	/*
		批量注册账号
	*/
	public function batregister() {
		$this->sp_render();
	}

	/*
		余额变更通知提醒
	*/
	public function cashnotice() {
		$cfg = SuPointMod::get_cashnotice_cfg();

		$params = array('cfg' => $cfg);
		$this->sp_render($params);
	}
	
	/*
		用户关系图
	*/
	public function fansgraph() {
		$uid  = requestInt('su_uid');
		$user = AccountMod::get_service_user_by_uid($uid);
		if(!$user || ($user['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
			redirectTo('?_a=su&_u=sp.fanslist');
		}
		$option = array(
			'page' => 0,
			'limit' => requestInt('limit', 10),
			'from_su_uid' => $user['uid'],
		);
		$depth = requestInt('depth', 3);

		$echarts = array();
		$width = 800;
		$i = 0;
		$x = $width/2; $y = 0;
		$user['iid'] = $i;
		$echarts['data'][$i++] = array('name' => $user['name'], 'symbol' => 'image://'.($user['avatar'] ? $user['avatar'] : '/static/images/null_avatar.png'),
										'x' => $x, 'y' => $y, 'uid' => $user['uid'], 
										'label' => array('normal' => array('show' => true)));
		$option['from_su_uid'] = $user['uid'];
		$children = AccountMod::get_service_user_list($option);
		$y += 60;
		$x = 0;
		if($children['list'])  {
			foreach($children['list'] as $u) {
				$u['iid'] = $i;
				$x += $width/(count($children['list']) + 1);
				$echarts['data'][$i++] = array('name' => $u['name'], 'symbol' => 'image://'.($u['avatar'] ? $u['avatar'] : '/static/images/null_avatar.png'),
										'x' => $x, 'y' => $y, 'uid' => $u['uid'],
										'label' => array('normal' => array('show' => true)));
				$echarts['links'][] = array('source' => $user['iid'], 'target' => $u['iid']);
			}
		}

		$params = array('user' => $user, 'echarts' => $echarts);
		
		$this->sp_render($params);
	}

    /*
      导出用户列表
      */
    public function fanslist_excel() {
        ini_set('memory_limit', '15M');
        ini_set("max_execution_time", "0");
        $sp_uid = AccountMod::get_current_service_provider('uid');
        $option = array(
            'header' => array(
                '编号',
                '上级编号',
                '微信称呼',
                '真实姓名',
                '电话',
            ),
            'title' => iconv("UTF-8", "GBK", '用户列表'),
        );
        $sql = 'select su.uid,su.from_su_uid,su.name,';
        $sql .= 'sup.realname,sup.phone';
        $sql .= ' from service_user as su left join service_user_profile as sup on su.uid =sup.uid ';
        $sql .= ' where su.sp_uid = '.$sp_uid;
        $page = 0;
        while(1){
            $data = Dba::readCountAndLimit($sql,$page,1000);
            if(!empty($data['list'])){
                $option['i'] = $page;
                $this->csv($data['list'], $option);
                unset($data);
                $data = null;
                $page++;
            }
            else{
                break;
            }
        }
        exit;

    }

    //download 为true 时 即写即输出
    protected function csv($data, $option) {
        $ret = '';
        if ($option[ 'i' ] == 0) {
            foreach ($option['header'] as $h) {
                $ret .= '"' . $h . '",';
            }
            $ret .= "\r\n";
            header("Content-Type: application/text/plain; charset=UTF-8");
//        header("Content-Type: application/vnd.ms-excel; charset=GB2312");
            header("Content-Disposition: attachment;filename=" . $option['title'] . ".csv ");
        }
        foreach ($data as $item) {
            foreach ($item as $it) {
                $ret .= '"' . $it . '",';
            }
            $ret .= "\r\n";
        }
        //转码 不然excel 打开 中文是乱码
        echo iconv("UTF-8", "GBK//IGNORE", $ret);
    }




}


