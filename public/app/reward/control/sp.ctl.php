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
			array(
				'name' => '抽奖活动',
				'icon' => 'am-icon-gift',
				'link' => '?_a=reward&_u=sp',
				'activeurl' => 'sp.index'
			),
			/*array(
			'name' => '奖项列表',
			'icon' => 'am-icon-plus',
			'link' => '?_a=reward&_u=sp.itemlist',
			'activeurl' => 'sp.itemlist'
			),*/
			/*
			array(
			'name' => '创建抽奖',
			'icon' => 'am-icon-plus',
			'link' => '?_a=reward&_u=sp.addreward',
			'activeurl' => 'sp.addreward'
			)
			*/
			/*
			array(
			'name' => '抽奖数据',
			'icon' => 'am-icon-list',
			'link' => '?_a=reward&_u=sp.recordlist',
			'activeurl' => 'sp.recordlist'
			)*/
			
			array(
				'name' => '活动数据',
				'icon' => 'am-icon-line-chart',
				'link' => '?_a=reward&_u=sp.activitydata',
				'activeurl' => 'sp.activitydata'
			)
		);
	}
	protected function sp_render($params = array()) {
		$params[ 'menu_array' ] = $this->get_menu_array();
		render_sp_inner('', $params);
	}
	
	public function index() {
		$option[ 'sp_uid' ] = AccountMod::get_current_service_provider('uid');
		$option[ 'page' ] = requestInt('page');
		$option[ 'limit' ] = requestInt('limit', 10);
		
		$rewards = RewardMod::get_reward_list($option);
		$pagination = uct_pagination($option[ 'page' ], ceil($rewards[ 'count' ] / $option[ 'limit' ]), '?_a=reward&_u=sp&limit=' . $option[ 'limit' ] . '&page=');
		
		$params = array(
			'option' => $option,
			'rewards' => $rewards,
			'pagination' => $pagination
		);
		$this->sp_render($params);
	}
	
	/*
	添加编辑抽奖
	*/
	/*public function addreward_new() {
		$params = array();
		
		//编辑模式
		if (($uid = requestInt('uid')) && ($reward = RewardMod::get_reward_by_uid($uid)) && ($reward[ 'sp_uid' ] == AccountMod::get_current_service_provider('uid'))) {
			$params[ 'reward' ] = $reward;
		}
		$this->sp_render($params);
	}*/
	public function addreward() {
		$params = array();
		
		//编辑模式
		if (($uid = requestInt('uid')) && ($reward = RewardMod::get_reward_by_uid($uid)) && ($reward[ 'sp_uid' ] == AccountMod::get_current_service_provider('uid'))) {
			$params[ 'reward' ] = $reward;
		}
		$this->sp_render($params);
	}

	public function addreward_1() {
		$params = array();
		//编辑模式
		if (($uid = requestInt('uid')) && ($reward = RewardMod::get_reward_by_uid($uid)) && ($reward[ 'sp_uid' ] == AccountMod::get_current_service_provider('uid'))) {
			$params[ 'reward' ] = $reward;
		}
		$this->sp_render($params);
	}

	public function addreward_2() {
		$params = array();
		
		$this->sp_render($params);
	}

	public function addreward_3() {
		if (!($option[ 'r_uid' ] = requestInt('r_uid')) || !($reward = RewardMod::get_reward_by_uid($option[ 'r_uid' ])) || !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			//没有指定一个表单,跳转到表单列表
			$GLOBALS[ '_UCT' ][ 'ACT' ] = 'index';
			return $this->index();
		}
		$option[ 'sp_uid' ] = AccountMod::get_current_service_provider('uid');
		$option[ 'key' ] = requestString('key', PATTERN_SEARCH_KEY);
		$option[ 'page' ] = requestInt('page');
		$option[ 'limit' ] = requestInt('limit', -1);
		
		$item = RewardMod::get_reward_item_list($option);
		$pagination = uct_pagination($option[ 'page' ], ceil($item[ 'count' ] / $option[ 'limit' ]), '?_a=reward&_u=sp.itemlist&r_uid=' . $option[ 'r_uid' ] . '&key=' . $option[ 'key' ] . '&limit=' . $option[ 'limit' ] . '&page=');
		
		$params = array(
			'reward' => $reward,
			'option' => $option,
			'item' => $item,
			'pagination' => $pagination
		);
		
		$this->sp_render($params);
	}

	/*public function addreward_4() {
		$params = array();
		
		$this->sp_render($params);
	}*/

	public function addreward_5() {
		$params = array();
		//编辑模式
		if (($uid = requestInt('uid')) && ($reward = RewardMod::get_reward_by_uid($uid)) && ($reward[ 'sp_uid' ] == AccountMod::get_current_service_provider('uid'))) {
			$params[ 'reward' ] = $reward;
		}
		$this->sp_render($params);
	}
	
	/*
	抽奖数据列表 
	*/
	public function recordlist() {
		if (!($option[ 'r_uid' ] = requestInt('r_uid')) || !($reward = RewardMod::get_reward_by_uid($option[ 'r_uid' ])) || !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			//没有指定一个表单,跳转到表单列表
			$GLOBALS[ '_UCT' ][ 'ACT' ] = 'index';
			return $this->index();
		}
		$option[ 'sp_uid' ] = AccountMod::get_current_service_provider('uid');
		$option[ 'key' ] = requestString('key', PATTERN_SEARCH_KEY);
		$option[ 'page' ] = requestInt('page');
		$option[ 'limit' ] = requestInt('limit', 10);
		$option[ 'sp_remark' ] = requestInt('sp_remark');
		$records = RewardMod::get_reward_record_list($option);
		$pagination = uct_pagination($option[ 'page' ], ceil($records[ 'count' ] / $option[ 'limit' ]), '?_a=reward&_u=sp.recordlist&r_uid=' . $option[ 'r_uid' ] . '&key=' . $option[ 'key' ] . '&limit=' . $option[ 'limit' ] . '&page=');
		$params = array(
			'reward' => $reward,
			'option' => $option,
			'records' => $records,
			'pagination' => $pagination
		);
		// var_dump($records);
		// exit;
		$this->sp_render($params);
	}
	
	/*
	添加编辑奖品设置
	*/
	public function addrewarditem() {
		$params = array();
		
		//编辑模式
		if (($r_uid = requestInt('r_uid')) && ($rewarditem = RewardMod::get_reward_item_by_uid($r_uid))) {
			$params[ 'rewarditem' ] = $rewarditem;
		}
		
		$this->sp_render($params);
	}
	
	/*
	取奖品数据列表 
	*/
	public function itemlist() {
		if (!($option[ 'r_uid' ] = requestInt('r_uid')) || !($reward = RewardMod::get_reward_by_uid($option[ 'r_uid' ])) || !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			//没有指定一个表单,跳转到表单列表
			$GLOBALS[ '_UCT' ][ 'ACT' ] = 'index';
			return $this->index();
		}
		$option[ 'sp_uid' ] = AccountMod::get_current_service_provider('uid');
		$option[ 'key' ] = requestString('key', PATTERN_SEARCH_KEY);
		$option[ 'page' ] = requestInt('page');
		$option[ 'limit' ] = requestInt('limit', 10);
		
		$item = RewardMod::get_reward_item_list($option);
		$pagination = uct_pagination($option[ 'page' ], ceil($item[ 'count' ] / $option[ 'limit' ]), '?_a=reward&_u=sp.itemlist&r_uid=' . $option[ 'r_uid' ] . '&key=' . $option[ 'key' ] . '&limit=' . $option[ 'limit' ] . '&page=');
		
		$params = array(
			'reward' => $reward,
			'option' => $option,
			'item' => $item,
			'pagination' => $pagination
		);
		
		$this->sp_render($params);
	}
	
	public function additem() {
		$params = array();
		if ($r_uid = requestInt('r_uid')) {
			$reward = RewardMod::get_reward_by_uid($r_uid);
		}
		if ($i_uid = requestInt('i_uid')) {
			$item = RewardMod::get_reward_item_by_uid($i_uid);
		}
		$item[ 'r_uid' ] = $r_uid;
		$params[ 'item' ] = $item;
		$params[ 'reward' ] = $reward;
		$this->sp_render($params);
	}
	
	
	public function activitydata() {
		$option[ 'sp_uid' ] = AccountMod::get_current_service_provider('uid');
		$option[ 'page' ] = requestInt('page');
		$option[ 'limit' ] = requestInt('limit', -1);
		$rewards = RewardMod::get_reward_list($option);
		$count = $rewards[ 'count' ];
		if ($count == 0) {
			$params[ 'rewards' ] = $rewards;
			$this->sp_render($params);
		}
		//判断是否选中某个抽奖
		$where_arr = '';
		if (!$r_uid = requestInt('r_uid')) {
			$where_arr = 'where ';
			$option[ 'r_uid' ] = $r_uid = $rewards[ 'list' ][ 0 ][ 'uid' ];
			$where_arr = 'where r_uid=' . $r_uid;
		} else {
			$option[ 'r_uid' ] = $r_uid;
			if (($reward = RewardMod::get_reward_by_uid($r_uid)) && ($reward[ 'sp_uid' ] == AccountMod::get_current_service_provider('uid'))) {
				$where_arr = 'where r_uid=' . $r_uid;
				$params[ 'reward' ] = $reward;
			} else {
				$GLOBALS[ '_UCT' ][ 'ACT' ] = 'index';
				return $this->index();
			}
		}
		
		
		$today = strtotime('today');
		//参与总人数 有登陆的用户 su_uid去重
		$sql = 'select count(distinct su_uid) from reward_record ';
		$sql .= $where_arr . ' and su_uid>0';
		$cnts[ 'total_users_cnt' ] = Dba::readOne($sql);
		
		//参与总人数 无登陆用户 ip 去重
		$sql = 'select count(distinct user_ip) from reward_record ';
		$sql .= $where_arr . ' and su_uid=0';
		$cnts[ 'total_users_cnt' ] += Dba::readOne($sql);
		
		//今日参与增加人数 有登陆的用户 su_uid去重
		$sql = 'select count(distinct su_uid) from reward_record ';
		$sql .= $where_arr . ' and su_uid>0';
		$sql .= ' and create_time >= ' . $today;
		$cnts[ 'today_users_cnt' ] = Dba::readOne($sql);
		
		//今日参与增加人数 无登陆用户 ip 去重
		$sql = 'select count(distinct user_ip) from reward_record ';
		$sql .= $where_arr . ' and su_uid=0';
		$sql .= ' and create_time >= ' . $today;
		$cnts[ 'today_users_cnt' ] += Dba::readOne($sql);
		
		//中奖总数
		$sql = 'select count(item_uid) from reward_record ';
		$sql .= $where_arr . ' and item_uid >0 ';
		$cnts[ 'today_reward_cnt' ] = Dba::readOne($sql);
		
		//今日中奖增加数
		$sql .= ' and reward_record.create_time >= ' . $today;
		$cnts[ 'today_rewards_cnt' ] = Dba::readOne($sql);
		
		//'今日参与人数','历史参与人数', '今日中奖数', '历史中奖数'
		
		$option[ 'sp_uid' ] = AccountMod::get_current_service_provider('uid');
		$option[ 'page' ] = requestInt('page');
		$option[ 'limit' ] = requestInt('limit', -1);
		$item = RewardMod::get_reward_item_list($option);
		
		//su_uid 统计人数
		$sql = 'select from_unixtime(create_time,"%Y-%m-%d") as days,count(distinct su_uid) as count,count(item_uid) as item ';
		$sql .= ' from reward_record where r_uid = "' . $r_uid . '" and su_uid>0 group by days;';
		$ret = Dba::readAllAssoc($sql);
		foreach ($ret as $rets) {
			$suret[ $rets[ 'days' ] ][ 'count' ] = $rets[ 'count' ];
			$suret[ $rets[ 'days' ] ][ 'item' ] = $rets[ 'item' ];
		}
		
		//ip 统计人数
		$sql = 'select from_unixtime(create_time,"%Y-%m-%d") as days,count(distinct user_ip) as count,count(item_uid) as item  ';
		$sql .= ' from reward_record where r_uid = "' . $r_uid . '" and su_uid=0 group by days;';
		$ret2 = Dba::readAllAssoc($sql);
		foreach ($ret2 as $ret2s) {
			$ipret[ $ret2s[ 'days' ] ][ 'count' ] = $ret2s[ 'count' ];
			$ipret[ $ret2s[ 'days' ] ][ 'item' ] = $ret2s[ 'item' ];
		}
		//奖品分布情况
		$sql = 'select from_unixtime(create_time,"%Y-%m-%d") as days ';
		foreach ($item[ 'list' ] as $it) {
			$sql .= ',count( case item_uid when ' . $it[ 'uid' ] . ' then ' . $it[ 'uid' ] . ' end) as "' . $it[ 'uid' ] . '"';
		}
		$sql .= ' from reward_record where r_uid = "' . $r_uid . '" group by days;';
		$ret3 = Dba::readAllAssoc($sql);
		
		$count = count($ret3);
		if ($count == 0) {
			$echarts2 = '';
			$echarts = '';
		}
		//传递json数据
		for ($i = 0; $i < $count; $i++) {
			$echarts2[ 'xAxis' ][ 'data' ][] = date("m-d", strtotime($ret3[ $i ][ 'days' ]));
			$echarts[ 'xAxis' ][ 'data' ][] = $ret3[ $i ][ 'days' ];
			$echarts[ 'series' ][ 1 ][ 'data' ][ $i ] = (!isset($suret[ $ret3[ $i ][ 'days' ] ]) ? 0 : $suret[ $ret3[ $i ][ 'days' ] ][ 'count' ]) + (!isset($ipret[ $ret3[ $i ][ 'days' ] ]) ? 0 : $ipret[ $ret3[ $i ][ 'days' ] ][ 'count' ]);
			$echarts[ 'series' ][ 3 ][ 'data' ][ $i ] = (!isset($suret[ $ret3[ $i ][ 'days' ] ]) ? 0 : $suret[ $ret3[ $i ][ 'days' ] ][ 'item' ]) + (!isset($ipret[ $ret3[ $i ][ 'days' ] ]) ? 0 : $ipret[ $ret3[ $i ][ 'days' ] ][ 'item' ]);
			
			if ($item[ 'count' ] > 0) {
				$j = 0;
				foreach ($item[ 'list' ] as $it) {
					if ($i == 0) {
						$echarts2[ 'count' ] = $count;
						$echarts2[ 'options' ][ 'legend' ][ 'data' ][] = $it[ 'title' ];
						$echarts2[ 'options' ][ 'series' ][ 0 ][ 'name' ] = '中奖数据';
						$echarts2[ 'options' ][ 'series' ][ 0 ][ 'type' ] = 'pie';
						$echarts2[ 'options' ][ 'series' ][ 0 ][ 'center' ] = array(
							'50%',
							'45%'
						);
						$echarts2[ 'options' ][ 'series' ][ 0 ][ 'radius' ] = '50%';
					}
					$echarts2[ 'options' ][ 'series' ][ 0 ][ 'data' ][ $j ][ 'value' ] = $ret3[ $i ][ $it[ 'uid' ] ];
					$echarts2[ 'options' ][ 'series' ][ 0 ][ 'data' ][ $j ][ 'name' ] = $it[ 'title' ];
					
					$echarts2[ 'options' ][ $i ][ 'series' ][ 0 ][ 'name' ] = '中奖数据';
					$echarts2[ 'options' ][ $i ][ 'series' ][ 0 ][ 'type' ] = 'pie';
					$echarts2[ 'options' ][ $i ][ 'series' ][ 0 ][ 'data' ][ $j ][ 'value' ] = $ret3[ $i ][ $it[ 'uid' ] ];
					$echarts2[ 'options' ][ $i ][ 'series' ][ 0 ][ 'data' ][ $j ][ 'name' ] = $it[ 'title' ];
					
					$j++;
				}
			}
			
			$echarts[ 'series' ][ 1 ][ 'data' ] = array_values($echarts[ 'series' ][ 1 ][ 'data' ]);
			$echarts[ 'series' ][ 3 ][ 'data' ] = array_values($echarts[ 'series' ][ 3 ][ 'data' ]);
			$echarts[ 'series' ][ 2 ][ 'data' ] = '';
			$echarts[ 'series' ][ 0 ][ 'data' ] = '';
			
		}
		
		$params = array(
			'cnts' => $cnts,
			'echarts' => $echarts,
			'rewards' => $rewards,
			'echarts2' => $echarts2,
			'option' => $option
		);
		
		$this->sp_render($params);
		
	}
	
	/*
	导出某天的数据
	*/
	public function excel() {
		ini_set('memory_limit', '15M');
		ini_set("max_execution_time", "0");
		// $t=time();
		
		if (!($r_uid = requestInt('r_uid')) || (!$reward = RewardMod::get_reward_by_uid($r_uid)) || (!$reward[ 'sp_uid' ] == AccountMod::get_current_service_provider('uid'))) {
			$GLOBALS[ '_UCT' ][ 'ACT' ] = 'index';
			return $this->index();
		}

		if (!($day = requestString('date', PATTERN_DATE))) {
			echo '请选择时间!';
			return;
		}
		
		$begin_time = strtotime($day);
		$end_time = $begin_time + 86400 - 1;
		
		
		// 取数据条数 2000条 分段读取 减少内存消耗
		$sql_cnt = 'select count(*) from reward_record where create_time>=' . $begin_time . ' and create_time<=' . $end_time . ' and r_uid=' . $r_uid;
		$count = Dba::readOne($sql_cnt);
		if($count==0)
		{
			echo '选中日期并无数据';
			exit;
		}
		$limit = 2000;
		$countsize = ceil($count / $limit);
		for ($i = 0; $i < $countsize; $i++) {
			$page = $i;
			
			$option = array(
				'create_time' => $begin_time,
				'create_time_max' => $end_time,
				'page' => $page,
				'limit' => $limit,
				'r_uid' => $r_uid
			);
			
			$reward_record = RewardMod::get_reward_record_list($option);
			if (!$reward_record[ 'list' ]) {
				echo $day . ' 没有数据!';
				return;
			}
			$header = array(
				'流水号',
				'参与用户微信名',
				'性别',
				'抽奖时间          ',
				'用户ip  ',
				'中奖情况',
				'领取情况',
				"表单"
			);
			$data = array();
			foreach ($reward_record[ 'list' ] as $u) {
				$item = array(
					$u[ 'uid' ],
					(isset($u[ 'user' ]) ? $u[ 'user' ][ 'name' ] : ''),
					
					(isset($u[ 'user' ]) ? ($u[ 'user' ][ 'gender' ] == 1 ? '男' : '女') : ''),
					date('Y-m-d H:i:s', $u[ 'create_time' ]),
					$u[ 'user_ip' ],
					isset($u[ 'item' ]) ? $u[ 'item' ][ "title" ] : "未中奖",
					$u[ 'sp_remark' ] == 0 ? '未领取' : '已领取',
					(($reward[ 'win_rule' ][ 'type' ] == 'form') ? (empty($u[ 'data' ]) ? '' : json_encode($u[ 'data' ], true)) : '')
				);
				
				$data[] = $item;
				unset($item);
				$item = null;
			}
			unset($reward_record);
			$reward_record = null;
			$option = array(
				'header' => $header,
				'download' => true,
				'title' => $reward[ 'title' ] . '-' . $day,
				'i' => $i
			);
			//处理文件名 中文避免中文名时失败
			$option[ 'title' ] = iconv("UTF-8", "GBK", $option[ 'title' ]);
			//	require_once UCT_PATH.'vendor/phpExcel/export.php';
			//export_to_excel($data, $option);
			//写入 csv文件中
			$file_path = $option[ 'title' ] . ".csv ";
			if(file_exists($file_path))
			{
				unlink($file_path);
			}
			self::csv($data, $option);
			unset($data);
			$data = null;
			
		}
	}
	public function play(){
	
	render_fg('', $params);
	}
	
	//download 为true 时 即写即输出
	public function csv($data, $option) {
		if ($option[ 'download' ] == true) {
			$ret = '';
			if ($option[ 'i' ] == 0)
			{

				foreach ($option[ 'header' ] as $h) {
					$ret .= '"' . $h . '",';
				}
				$ret .= "\r\n";
				header("Content-Type: application/vnd.ms-excel; charset=GB2312");
				header("Content-Disposition: attachment;filename=" . $option[ 'title' ] . ".csv ");
			}

			
			foreach ($data as $item) {
				foreach ($item as $it) {
					$ret .= '"' . $it . '",';
				}
				$ret .= "\r\n";
			}
//				echo $ret;
			echo iconv("UTF-8", "GBK//IGNORE", $ret);
//			exit;
		} else {
			$fp = fopen($option[ 'title' ] . ".csv ", 'a+');
			// var_dump($option[ 'i' ] );
			if ($option[ 'i' ] == 0)
			{	
				
				fputcsv($fp, $option[ 'header' ]);
			}
			foreach ($data as $it) {
				fputcsv($fp, $it, ',', '"');
			}
			fclose($fp);
		}
	}
}
