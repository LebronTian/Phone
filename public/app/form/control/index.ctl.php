<?php
class IndexCtl {
	public function init_form() {
		if(!($f_uid = requestInt('f_uid')) ||
			!($form = FormMod::get_form_by_uid($f_uid))) {
				//试着取默认商户表单
				if(!($form = FormMod::get_default_form_by_sp_uid(AccountMod::require_sp_uid()))) {
					echo '参数错误! f_uid ';
					exit();
				}
		}
		if(($form['status'] > 0) ||
		   ((!empty($form['access_rule']['start_time']) && $form['access_rule']['start_time'] > $_SERVER['REQUEST_TIME']) ||
		   (!empty($form['access_rule']['end_time']) && $form['access_rule']['end_time'] < $_SERVER['REQUEST_TIME']))) {
			if($GLOBALS['_UCT']['ACT'] != 'offline') {
				redirectTo('?_a=form&_u=index.offline&f_uid='.$form['uid']);
			}
		}

		//设一下当前商户uid
		$_REQUEST['__sp_uid'] = $form['sp_uid'];

		//必须要登陆, 注意首页不检查
		if(!empty($form['access_rule']['must_login']) && !in_array($GLOBALS['_UCT']['ACT'], array('index'))) {
			uct_use_app('su');
			$su_uid = SuMod::require_su_uid();
		}

		!isset($GLOBALS['_UCT']['TPL']) && ($GLOBALS['_UCT']['TPL'] = $form['tpl'] ? $form['tpl'] : 'bigidea');
		return $form;
	}

	/*
		表单页
	*/
	public function index() {
		$form = $this->init_form();
		$su = AccountMod::get_current_service_user();
		$record = array();
		if(!$uid = requestInt('uid')) {
			$uid = requestInt('r_uid');
		}
		if($uid && ($record = FormMod::get_form_record_by_uid($uid))) {
			//todo 可以检查一下是否有权限查看
		}
		/*
		$option['f_uid'] = $uid;
		$option['su_uid'] = $su['uid'];
		$option['limit'] =requestInt('limit',-1);
		$option['page'] = requestInt('page',0);
		$recordlist = FormMod::get_form_record_list($option);
		*/
    	if(!$record && ($su_uid = AccountMod::has_su_login())) {
			$record = Dba::readRowAssoc('select * from form_record where f_uid = '.$form['uid'].' && su_uid = '.$su_uid
										, 'FormMod::func_get_form_record');
		}
		$params = array('form' => $form, 'su' => $su, 'record' => $record);
		render_fg('', $params);
	}


    public function formlist() {

	    $option['sp_uid'] = AccountMod::require_sp_uid();
        $option['page'] = requestInt('page');
        $option['uids'] = requestIntArray('uids');
        $option['limit'] = requestInt('limit', -1);
        $option['key'] = requestString('key',PATTERN_SEARCH_KEY);
		$option['status'] = 0; //只要启用的
        $forms = FormMod::get_form_list($option);

        $su = AccountMod::get_current_service_user();

        $params = array('su' => $su, 'forms' => $forms);

        render_fg('', $params);
    }

    public function forms() {
    	$form = $this->init_form();
		$su = AccountMod::get_current_service_user();
		if(!$uid = requestInt('uid')) {
			$uid = requestInt('r_uid');
		}

		$record = array();
		if($uid && ($record = FormMod::get_form_record_by_uid($uid))) {
			//todo 可以检查一下是否有权限查看
		}

    	if(empty($record) && ($su_uid = AccountMod::has_su_login())) {
			$record = Dba::readRowAssoc('select * from form_record where f_uid = '.$form['uid'].' && su_uid = '.$su_uid
										, 'FormMod::func_get_form_record');
		}
    	
		$params = array('form' => $form, 'su' => $su, 'record' => $record);
		render_fg('', $params);
    }

    public function details() {
    	$form = $this->init_form();
		$su = AccountMod::get_current_service_user();
		if(!$uid = requestInt('uid')) {
			$uid = requestInt('r_uid');
		}
		if($uid && ($record = FormMod::get_form_record_by_uid($uid))) {
			//todo 可以检查一下是否有权限查看
		}
    	
		$params = array('form' => $form, 'su' => $su);
		render_fg('', $params);
    }

    public function success() {
    	$form = $this->init_form();
		$su = AccountMod::get_current_service_user();
		if(!$uid = requestInt('uid')) {
			$uid = requestInt('r_uid');
		}
		if($uid && ($record = FormMod::get_form_record_by_uid($uid))) {
			//todo 可以检查一下是否有权限查看
		}
    	
		$params = array('form' => $form, 'su' => $su);
		render_fg('', $params);
    }

    public function attention() {
    	$form = $this->init_form();
		$su = AccountMod::get_current_service_user();
		if(!$uid = requestInt('uid')) {
			$uid = requestInt('r_uid');
		}
		if($uid && ($record = FormMod::get_form_record_by_uid($uid))) {
			//todo 可以检查一下是否有权限查看
		}
    	
		$params = array('form' => $form, 'su' => $su);
		render_fg('', $params);
    }

    public function invite() {
    	$form = $this->init_form();
		$su = AccountMod::get_current_service_user();
		if(!$uid = requestInt('uid')) {
			$uid = requestInt('r_uid');
		}
		if($uid && ($record = FormMod::get_form_record_by_uid($uid))) {
			//todo 可以检查一下是否有权限查看
		}
    	
		$params = array('form' => $form, 'su' => $su);
		render_fg('', $params);
    }

    public function userlist() {
    	$form = $this->init_form();
		$su = AccountMod::get_current_service_user();
		if(!$uid = requestInt('uid')) {
			$uid = requestInt('r_uid');
		}
		if($uid && ($record = FormMod::get_form_record_by_uid($uid))) {
			//todo 可以检查一下是否有权限查看
		}
    	
		$params = array('form' => $form, 'su' => $su);
		render_fg('', $params);
    }

    public function code() {
    	$form = $this->init_form();
		$su = AccountMod::get_current_service_user();
		if(!$uid = requestInt('uid')) {
			$uid = requestInt('r_uid');
		}
		if($uid && ($record = FormMod::get_form_record_by_uid($uid))) {
			//todo 可以检查一下是否有权限查看
		}
    	
		$params = array('form' => $form, 'su' => $su);
		render_fg('', $params);
    }


	/*
		活动下线 todo 应该也可以后台设置
	*/
	public function offline() {
		echo '该表单已经下线!';
		exit();
	}

	/*
		二维码
	*/
	public function qrcode() {

		$f_uid = requestInt('f_uid');
		//$url = 'http://'.$_SERVER['HTTP_HOST'].'?_a=reward&r_uid='.$r_uid;
		//$url = 'http://' . parse_url(DomainMod::get_app_url('form', ""), PHP_URL_HOST).'?_a=form&f_uid='.$f_uid;
		$url = DomainMod::get_app_url('form', 0, 'f_uid='.$f_uid);
		require_once UCT_PATH.'vendor/phpQrcode/PHPQRCode.php';
		\PHPQRCode\QRcode::png($url);
	}
}

