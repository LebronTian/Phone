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
			array('name' => '全部表单', 'icon' => 'am-icon-files-o', 'link' => '?_a=form&_u=sp', 'activeurl' => 'sp.index'),
			array('name' => '活动报名', 'icon' => 'am-icon-files-o', 'link' => '?_a=form&_u=sp&type=activity', 'activeurl' => 'sp.index2'),
			array('name' => '提问回复', 'icon' => 'am-icon-file', 'link' => '?_a=form&_u=sp.form_reply', 'activeurl' => 'sp.form_reply'),

//			array('name' => '网站设置', 'icon' => 'am-icon-home', 'menus' => array(
//				array('name' => '基本设置', 'icon' => 'am-icon-home', 'link' => '?_a=site&_u=sp.set', 'activeurl' => 'sp.set'),
//				array('name' => '地图设置', 'icon' => 'am-icon-home', 'link' => '?_a=site&_u=sp.map', 'activeurl' => 'sp.map'),
//				array('name' => '模板选择', 'icon' => 'am-icon-home', 'link' => '?_a=site&_u=sp.tpls', 'activeurl' => 'sp.tpls'),
//				)),

//			array('name' => '创建表单', 'icon' => 'am-icon-plus', 'link' => '?_a=form&_u=sp.addform', 'activeurl' => 'sp.addform'),
//			array('name' => '表单数据', 'icon' => 'am-icon-list', 'link' => '?_a=form&_u=sp.recordlist', 'activeurl' => 'sp.recordlist'),

		);
	}
	protected function sp_render($params = array()) {

		if(!empty($params['form']) && empty($GLOBALS['_UCT']['TPL'])) {
			//后台模板选择
			unset($_REQUEST['__tpl']);
			unset($_COOKIE['__tpl_form']);
			$GLOBALS['_UCT']['TPL'] = $params['form']['tpl']?$params['form']['tpl'] : 'eyeis';
		}

		$params['menu_array'] = $this->get_menu_array();

		render_sp_inner('', $params);
	}

	public function index() {
		$option['sp_uid'] =  AccountMod::get_current_service_provider('uid');	
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
        $option['key'] = requestString('key',PATTERN_SEARCH_KEY);
		$option['type'] = requestString('type',PATTERN_SEARCH_KEY);

		$forms = FormMod::get_form_list($option);
		$pagination = uct_pagination($option['page'], ceil($forms['count']/$option['limit']),
			'?_a=form&_u=sp&limit='.$option['limit'].'&page=');
//		$pagination = uct_pagination($option['page'], ceil($forms['count']/$option['limit']),
//			'?_a=form&_u=sp&type='.$option['type'].'&limit='.$option['limit'].'&page=');
		
		$params = array('option' => $option, 'forms' => $forms, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		添加编辑表单
	*/
	public function addform() {
		$params = array();

		$option['type'] = requestString('type');
		//编辑模式
		if(($uid = requestInt('uid')) &&
			($form = FormMod::get_form_by_uid($uid)) &&
			($form['sp_uid'] == AccountMod::get_current_service_provider('uid'))) {
			$params['form'] = $form;
			$option['type'] = $form['type'];
		}

        $option['key'] = requestString('key', PATTERN_SEARCH_KEY);
        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', 10);
        $tpls = FormMod::get_tpls_list($option);
        $params['tpls'] = $tpls;


		if($option['type'] == 'activity' || !empty($_REQUEST['_d'])) {
			uct_set_mirror_tpl('','', 'addform_activity');
		}
		$this->sp_render($params);
	}

	/*
	 * 提问列表
	 */
	public function form_reply(){
		uct_check_mirror_tpl_access(); //搜索框可能会有需要

		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');

		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['f_uid']     = requestInt('f_uid');
		$option['msg_uid']     = requestInt('msg_uid');
		$option['p_uid']     = requestInt('p_uid');
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$comment   = Form_ReplyMod::get_form_reply($option);
		$pagination = uct_pagination($option['page'], ceil($comment['count'] / $option['limit']),
			'?_a=form&_u=sp.form_reply&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');
//		var_dump($comment);
		$params = array( 'option' => $option, 'comment' => $comment, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
	 * 回复
	 */
	public function add_reply(){

		if(!($uid = requestInt('uid'))){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$reply = Form_ReplyMod::get_form_reply_by_uid($uid);

		$params = array( 'reply' => $reply);
		$this->sp_render($params);
	}

	/*
		表单项列表
	*/
	public function itemlist() {
		
		/*
		$option['sp_uid'] =  AccountMod::get_current_service_provider('uid');	
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$forms = FormMod::get_form_list($option);
		$pagination = uct_pagination($option['page'], ceil($forms['count']/$option['limit']), 
						'?_a=form&_u=sp&limit='.$option['limit'].'&page=');
		
		$params = array('option' => $option, 'forms' => $forms, 'pagination' => $pagination);
		*/
		if(($uid = requestInt('f_uid')) &&
			($form = FormMod::get_form_by_uid($uid)) &&
			($form['sp_uid'] == AccountMod::get_current_service_provider('uid'))) {
			$params['form'] = $form;
		}
		
			
		// var_dump($params);
		// exit;
		$this->sp_render($params);
	}
	
	/*
		表单数据列表 
	*/
	public function recordlist() {
		if(!($option['f_uid'] = requestInt('f_uid')) || 
			!($form = FormMod::get_form_by_uid($option['f_uid'])) ||
			!($form['sp_uid'] == AccountMod::get_current_service_provider('uid'))) {
			//没有指定一个表单,跳转到表单列表
			$GLOBALS['_UCT']['ACT'] = 'index';
			return $this->index();
		}
		$form_field = $this->get_form_show_field($form);

		$option['sp_uid'] =  AccountMod::get_current_service_provider('uid');	
		$option['sp_remark'] = requestInt('sp_remark', -1);
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$records = FormMod::get_form_record_list($option);
		$pagination = uct_pagination($option['page'], ceil($records['count']/$option['limit']), 
				'?_a=form&_u=sp.recordlist&f_uid='.$option['f_uid'].'&key='.$option['key']
				.'&sp_remark='.$option['sp_remark'].'&limit='.$option['limit'].'&page=');
		
		$params = array('form' => $form, 'form_field' => $form_field, 'option' => $option, 'records' => $records, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		选择表单中几行字段显示到后台记录列表中, 不完全显示
		选择优先级 1. unique_field, 2. file_img,  3. text[required] 4. 其他
	*/
	public static function get_form_show_field($form, $max_cnt = 3) {
		$ret = array();
		while($form['data']) {
			if(!empty($form['access_rule']['unique_field']) &&
				!empty($form['data'][$form['access_rule']['unique_field']])) {
				$ret[$form['access_rule']['unique_field']] = $form['data'][$form['access_rule']['unique_field']];
				unset( $form['data'][$form['access_rule']['unique_field']]);
			}
			if(!$form['data'] || count($ret) >= $max_cnt) {
				break;
			}

			foreach($form['data'] as $k => $f) {
				if($f['type'] == 'file_img') {
					$ret[$f['id']] = $f;
					unset($form['data'][$k]);
					break;
				}
			}
			if(!$form['data'] || count($ret) >= $max_cnt) {
				break;
			}

			foreach($form['data'] as $k => $f) {
				if($f['type'] == 'text' && !empty($f['required'])) {
					$ret[$f['id']] = $f;
					unset($form['data'][$k]);
					break;
				}
			}
			if(!$form['data'] || count($ret) >= $max_cnt) {
				break;
			}

			foreach($form['data'] as $k => $f) {
				$ret[$f['id']] = $f;
				unset($form['data'][$k]);
				break;
			}

			if(!$form['data'] || count($ret) >= $max_cnt) {
				break;
			}
		}

		return $ret;	
	}

	//导出excel
	public function recordlist_excel()  {
		if(!($option['f_uid'] = requestInt('f_uid')) || 
			!($form = FormMod::get_form_by_uid($option['f_uid'])) ||
			!($form['sp_uid'] == AccountMod::get_current_service_provider('uid'))) {
			//没有指定一个表单,跳转到表单列表
			$GLOBALS['_UCT']['ACT'] = 'index';
			return $this->index();
		}
		$form_field = $this->get_form_show_field($form);

		$option['sp_uid'] =  AccountMod::get_current_service_provider('uid');	
		$option['sp_remark'] = requestInt('sp_remark', -1);
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', -1);

		$records = FormMod::get_form_record_list($option);
		if(empty($records['list'])) {
			echo '没有数据！';
			return;
		}
		#var_export($form_field);
		#var_export($records);

		$header = array_column($form_field, 'name');
		#$data = array_column($records['list'], 'data');
		array_unshift($header, '时间    ', '用户      ', '推荐人   ');
		$data = array();
		foreach($records['list'] as $r) {
			$rr = $r['data'];
			$name = $r['user_ip'];
			$name2 = '-';
			if($r['su_uid']) {
				$su = AccountMod::get_service_user_by_uid($r['su_uid']);
				$name = $su['name'] ? $su['name'] : $su['account'];
				if($su['from_su_uid']) {
				$su = AccountMod::get_service_user_by_uid($su['from_su_uid']);
				$name2 = $su['name'] ? $su['name'] : $su['account'];
				}
			}
			array_unshift($rr, date('Y-m-d H:i:s', $r['create_time']), $name, $name2);
			$data[] = $rr;
		}
		$option = array('header' => $header, 'download' => true, 'title' => $form['title'].'-表单数据');
		require_once UCT_PATH.'vendor/phpExcel/export.php';
		export_to_excel($data, $option);	
		exit();
	}

	//后台模板设置
	public function __call($act, $args) {
		if((!($f_uid = requestInt('uid')) && !($f_uid = requestInt('f_uid'))) ||
			!($form = FormMod::get_form_by_uid($f_uid)) ) {
			return $this->error();
		}
		#echo 'hehe '.$act.PHP_EOL;
		#var_export($args);
		$params = array('form' => $form, '_this' => $this);
		$this->sp_render($params);
	}

	public function error() {
		echo '内部错误! '.getErrorString();
	}
}

