<?php

/*
	后台ajax接口 
*/

class ApiCtl {
	public function formlist() {
		$option['sp_uid'] =  AccountMod::get_current_service_provider('uid');
		$option['status'] = requestInt('status');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['key'] = requestString('key',PATTERN_SEARCH_KEY);
		$option['cat'] = requestString('cat',PATTERN_SEARCH_KEY);

		//activity 活动
		$option['type'] = requestString('type');
		$option['status'] = 0;

		if(requestBool('no_brief'))$GLOBALS['_TMP']['LESS'] = 1;

		$data = FormMod::get_form_list($option);

//		header('Content-Type:text/html;charset=utf-8');
//		var_dump($data);
		outRight($data);
	}
	/*
		添加或编辑表单 
	*/
	public function addform()
	{
		if (isset($_REQUEST['title']) && !($form['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		setcookie('__tpl_form', '', time() - 3600, '/');
		isset($_REQUEST['brief']) && $form['brief'] = requestString('brief');
		isset($_REQUEST['status']) && $form['status'] = requestInt('status');
		isset($_REQUEST['type']) && $form['type'] = requestString('type');
		isset($_REQUEST['su_uid']) && $form['su_uid'] = requestInt('su_uid');
		$form['admin_uids'] = requestStringArray('admin_uids');
		isset($_REQUEST['tpl']) && $form['tpl'] = requestString('tpl', PATTERN_NORMAL_STRING);
		isset($_REQUEST['img']) && $form['img'] = requestString('img', PATTERN_URL);
		if (isset($_REQUEST['access_rule']) && !($form['access_rule'] = requestKvJson('access_rule', array(
				array('must_login', 'Bool', true),
				array('can_edit', 'Bool', true),
				array('start_time', 'Int'),
				array('end_time', 'Int'),
				array('total_cnt', 'Int'),
				array('max_cnt', 'Int', 1),
				array('max_cnt_day', 'Int', 1),
				//array('unique_field', 'String', PATTERN_NORMAL_STRING),
			)))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (isset($_REQUEST['data']) && !($form['data'] = requestKvJson('data')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		if (empty($form))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		isset($_REQUEST['uid']) && $form['uid'] = requestInt('uid');
		$form['sp_uid'] = AccountMod::get_current_service_provider('uid');
		
		if(empty($form['uid']) && !empty($form['tpl'])) {
			if ($form['tpl'] == 'appointment') {
				Event::addHandler('AfterAddForm', array('FormMod', 'onInitAddAppointmentForm'));
			}
			else if ($form['tpl'] == 'signup') {
				Event::addHandler('AfterAddForm', array('FormMod', 'onInitAddSignupForm'));
			}
		}

		outRight(FormMod::add_or_edit_form($form));
		
	}
	
	/*
		编辑表单项
	
	*/
	public function editformitem()
	{
		
		isset($_REQUEST['uid']) && $form['uid'] = requestInt('uid');
		$form['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$form           = FormMod::get_form_by_uid($form['uid']);
		if (isset($_REQUEST['data']))
		{

			if (!($form['data'] = requestKvJson('data')))
			{
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			foreach ($form['data'] as $d)
			{
//				var_dump(__file__.' line:'.__line__,);exit;
				checkKvJson($d, array(
									array('id', 'Int'),
									array('type', 'string', PATTERN_NORMAL_STRING),
									array('required', 'Bool', false),
									array('desc', 'string', PATTERN_NORMAL_STRING),
									      ))
				||outError(ERROR_INVALID_REQUEST_PARAM);
			}
		}

		if (isset($_REQUEST['access_rule']) && !($access_rule = requestKvJson('access_rule')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		$form['access_rule']['unique_field'] = $access_rule['unique_field'];
		
		outRight(FormMod::add_or_edit_form($form));
		
	}
	
	
	/*
		删除表单	
	*/
	public function delform()
	{
		if (!($fids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(FormMod::delete_form($fids, AccountMod::get_current_service_provider('uid')));
	}

	/*
		删除表单记录
	*/
	public function delformrecord()
	{
		if (!($f_uid = requestInt('f_uid')) ||
			!($form = FormMod::get_form_by_uid($f_uid)) ||
			($form['sp_uid'] != AccountMod::get_current_service_provider('uid'))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($rids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(FormMod::delete_form_record($rids, $f_uid));
	}

	/*
		标记表单记录
	*/
	public function markformrecord()
	{
		if (!($f_uid = requestInt('f_uid')) ||
			!($form = FormMod::get_form_by_uid($f_uid)) ||
			($form['sp_uid'] != AccountMod::get_current_service_provider('uid'))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($rids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$remark = requestInt('sp_remark');

		outRight(FormMod::remark_form_record($rids, $remark, $f_uid));
	}


	public function get_tpls()
	{
		$option['key']   = requestString('key', PATTERN_SEARCH_KEY);
		$option['type']  = requestString('type');
		$option['page']  = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		outRight(SptplMod::get_tpls_list($option));
	}

	/*
	 * 表单回复
	 */
	public function add_form_reply(){

		//编辑
		isset($_REQUEST['f_uid']) && $reply['f_uid'] = requestInt('f_uid');
		isset($_REQUEST['p_uid']) && $reply['p_uid'] = requestInt('p_uid');
		isset($_REQUEST['content']) && $reply['content'] = requestString('content');
		isset($_REQUEST['status']) && $reply['status'] = requestInt('status');

		if(empty($reply)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $reply['uid'] = requestInt('uid');
//		$reply['su_uid'] = AccountMod::has_su_login();
		$reply['sp_uid'] = AccountMod::get_current_service_provider('uid');

		outRight(Form_ReplyMod::add_or_edit_form_reply($reply));
	}

	/*
    删除表单记录
*/
	public function del_form_reply()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if (!($rids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(Form_ReplyMod::delete_form_reply($rids, $sp_uid));
	}


}


