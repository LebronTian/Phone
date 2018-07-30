<?php
/*
	前台ajax接口 
*/

class AjaxCtl {
	/*
		添加或编辑表单记录
	*/
	public function addformrecord() {
		//有的活动不设置任何信息。。。
		if(!$record['data'] = requestKvJson('data')) {
			//outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!($record['f_uid'] = requestInt('f_uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//编辑
		if(isset($_REQUEST['uid']) && !($record['uid'] = requestInt('uid'))) {
			unset($record['uid']);
		}
	
		$record['su_uid'] = AccountMod::has_su_login();
		$record['user_ip'] = requestClientIP();

		outRight(FormMod::add_or_edit_form_record($record['f_uid'], $record));
	}

	public function editformrecord(){
		if(!($f_uid = requestInt('f_uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		//编辑
		if(!($rids = requestInt('uid'))){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if($su_uid = AccountMod::has_su_login()) {
			$form = Dba::readRowAssoc('select * from form where uid = '.$f_uid,'FormMod::func_get_form');
			if((!in_array($su_uid,$form['admin_uids']))&&($su_uid != $form['su_uid'])){

					outError(ERROR_OBJ_NOT_EXIST);

			}

		}else{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$sp_remark = requestInt('sp_remark', -1);
		outRight(FormMod::remark_form_record($rids, $sp_remark, $f_uid));
	}

	public function get_form_by_uid() {
		if(!($option['f_uid'] = requestInt('f_uid')) || !($form = FormMod::get_form_by_uid($option['f_uid']))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight($form);
	}

	public function formlist() {
		$option['sp_uid'] =  AccountMod::require_sp_uid();
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

	public function form() {
		if(!$uid = requestInt('f_uid')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$form = FormMod::get_form_by_uid($uid);
		if(0&&!empty($_REQUEST['_d'])) {
			uct_use_app('su');
			$su_uid= AccountMod::has_su_login();
			echo WechatGroupMod::is_in_group($su_uid, array(8, 9, 16)) ? 'in' : 'not';
			unset($form['brief']);
			outRight($form);
		}

		if($su_uid = AccountMod::has_su_login()) {
			$record = Dba::readRowAssoc('select * from form_record where f_uid = '.$form['uid'].' && su_uid = '.$su_uid, 'FormMod::func_get_form_record');
			Dba::write('update form set click_cnt = click_cnt + 1 where uid = '.$form['uid']);
			$form['record'] = $record;
			if(in_array($su_uid,$form['admin_uids'])||$su_uid == $form['su_uid']){
				$form['is_admin'] = 1;
			}

		}

		outRight($form);
	}


	/*
		获取表单数据列表 
	*/
	public function recordlist() {
		if(!($option['f_uid'] = requestInt('f_uid')) || 
			!($form = FormMod::get_form_by_uid($option['f_uid']))) { 
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$option['f_uid'] =  $form['uid'];
		$option['sp_remark'] = requestInt('sp_remark', -1);
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$records = FormMod::get_form_record_list($option);
		
		outRight($records);
	}

	/*
	 * 表单数据详情
	 */
	public function record(){
		if(!($uid =  requestInt('uid'))){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$record = FormMod::get_form_record_by_uid($uid);

		outRight($record);
	}

	/*
	 * 表单回复
	 */
	public function add_form_reply(){

		if(!($reply['f_uid'] = requestInt('f_uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		if(!($reply['su_uid'] = AccountMod::has_su_login())){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$reply['sp_uid'] = AccountMod::get_current_service_provider('uid');
		//编辑
		$reply['p_uid'] = requestInt('p_uid');
		$reply['content'] = requestString('content');
		if(empty($reply['content'])){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$reply['status'] = requestInt('status');


		outRight(Form_ReplyMod::add_or_edit_form_reply($reply));
	}

	/*
	 * 获取表单回复列表
	 */
	public function replylist(){
		if(!($option['f_uid'] = requestInt('f_uid')) ||
			!($form = FormMod::get_form_by_uid($option['f_uid']))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$option['f_uid'] =  $form['uid'];
		$option['p_uid'] = requestInt('p_uid');
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['status'] = requestInt('status',1);

		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$reply = Form_ReplyMod::get_form_reply($option);

		outRight($reply);
	}

}

