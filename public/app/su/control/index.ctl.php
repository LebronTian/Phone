<?php

class IndexCtl {
	/*
		多模板渲染
	*/
	public function view_render($params = array()) {
		if(empty($GLOBALS['_UCT']['TPL'])) {
			$key = 'tplsu_'.AccountMod::require_sp_uid();
			if(!($GLOBALS['_UCT']['TPL'] = $GLOBALS['arraydb_sys'][$key])) {
				$this->site_tpl = $GLOBALS['arraydb_sys'][$key] = 'common';
			}
		}

		if(AccountMod::require_sp_uid() == 1049) {
		}
		render_fg('', $params);
	}

	/*
		首页个人中心
	*/
	public function index() {
		$sp_uid = AccountMod::require_sp_uid();
		$su = AccountMod::get_current_service_user();
		$params = array('sp_uid' => $sp_uid, 'su' => $su);
		if(!empty($su['uid'])) {
			$params['profile'] = SuMod::get_su_profile($su['uid']);
		}
		if(file_exists(UCT_PATH.'app/su/view/common/tpl/index/index_'.$sp_uid.'.tpl')) {
			uct_set_mirror_tpl('su', 'index', 'index_'.$sp_uid);
		}

		$this->view_render($params);
	}

	
	/*
		用户登陆
	*/
	public function login() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			$account = requestString('account', PATTERN_USER_NAME);
			$password = requestString('password', PATTERN_PASSWD);
			if(!$account || !$password) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			outRight(SuMod::do_su_login($account, $password));
		}

		$sp_uid = AccountMod::require_sp_uid();
		$su = AccountMod::get_current_service_user();

		$params = array('sp_uid' => $sp_uid, 'su' => $su);
		$this->view_render($params);
	}

	/*
		用户注册
	*/
	public function register() {
		$sp_uid = AccountMod::require_sp_uid();

		$params = array('sp_uid' => $sp_uid);
		$this->view_render($params);
	}
    /*
        参赛须知
    */
    public function notice() {
        $sp_uid = AccountMod::require_sp_uid();

        $params = array('sp_uid' => $sp_uid);
        $this->view_render($params);
    }
    /*
        参赛须知
    */
    public function selection() {
        $sp_uid = AccountMod::require_sp_uid();

        $params = array('sp_uid' => $sp_uid);
        $this->view_render($params);
    }

    /*
        承诺书
    */
    public function promise() {
        $sp_uid = AccountMod::require_sp_uid();

        $params = array('sp_uid' => $sp_uid);
        $this->view_render($params);
    }


    /*
        提交须知
    */
    public function uploadguide() {
        $sp_uid = AccountMod::require_sp_uid();

        $params = array('sp_uid' => $sp_uid);
        $this->view_render($params);
    }


    /*
        优惠信息
    */
    public function discount() {
        $sp_uid = AccountMod::require_sp_uid();

        $params = array('sp_uid' => $sp_uid);
        $this->view_render($params);
    }
    


    /*
        门店登录
    */
    public function storelogin() {
        $sp_uid = AccountMod::require_sp_uid();

        $params = array('sp_uid' => $sp_uid);
        $this->view_render($params);
    }


    /*
        信息核对
    */
    public function checknum() {
        $sp_uid = AccountMod::require_sp_uid();

        $params = array('sp_uid' => $sp_uid);
        $this->view_render($params);
    }


    /*
        领取奖励
    */
    public function receive() {
        $sp_uid = AccountMod::require_sp_uid();

        $params = array('sp_uid' => $sp_uid);
        $this->view_render($params);
    }



    /*
        报名成功
    */
    public function enroll() {
        $sp_uid = AccountMod::require_sp_uid();

        $params = array('sp_uid' => $sp_uid);
        $this->view_render($params);
    }

    /*
        个人中心
    */
    public function personcenter() {
        uct_use_app('su');      
        SuMod::require_su_uid();

		$su = AccountMod::get_current_service_user();

        $sp_uid = AccountMod::require_sp_uid();

        $params = array('sp_uid' => $sp_uid, 'su'=>$su);
        $this->view_render($params);
    }


    /*
    个人信息编辑
     */
    public function user_edit() {
        $sp_uid = AccountMod::require_sp_uid();

        uct_use_app('su');      
        SuMod::require_su_uid();
        $su = AccountMod::get_current_service_user();
        $profile = SuMod::get_su_profile();

        #var_export($profile);
        $this->view_render(array('su' => $su, 'profile' => $profile));
    }


    /*
        作品预览
    */
    public function preview() {
        $sp_uid = AccountMod::require_sp_uid();

		$record = array();
		if($sc = requestString('sign_code', PATTERN_NORMAL_STRING)) {
			if($su_uid = Dba::readOne('select su_uid from bigidea_mcdonald_user where sign_code = "'.$sc.'"')) {
				uct_use_app('form');
				$record =  Dba::readRowAssoc('select * from form_record where f_uid = 9 && su_uid = '.$su_uid, 'FormMod::func_get_form_record');
			}
		}

        $params = array('sp_uid' => $sp_uid, 'record' => $record);
        $this->view_render($params);
    }



    /*
        上传
    */
    public function upload() {
        $sp_uid = AccountMod::require_sp_uid();

        $params = array('sp_uid' => $sp_uid);
        $this->view_render($params);
    }



    /*
        
    */
    public function test() {
        $sp_uid = AccountMod::require_sp_uid();

        $params = array('sp_uid' => $sp_uid);
        $this->view_render($params);
    }


	/*
		找回密码
	*/
	public function forgetpassword() {
	}

	/*
		绑定用户
	*/
	public function bind() {
	}

	/*
		退出
	*/
	public function logout() {
		session_destroy();
		if(!$url = requestString('url', PATTERN_URL)) {
			$url = !empty($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] : '?_a=su&sp_uid='.AccountMod::require_sp_uid();
		}
		redirectTo($url);
	}

	/*
		微信授权登陆回调
	*/
	public function weixin_oauth2_login() {
		$public_uid = requestInt('public_uid');
		$code = requestString('code', PATTERN_TOKEN);
		if(!$public_uid || !$code) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$su_uid = SuMod::on_weixin_oauth2_ok($public_uid, $code);

		echo '<h1>'.$su_uid.'<a href="?_a=su&sp_uid='.AccountMod::require_sp_uid().'">点击返回</a></h1>';
		outRight($su_uid);
		/*
		$url = '?_a=su&sp_uid='.AccountMod::require_sp_uid();
		redirectTo($url);
		*/
	}

	/*
		充值订单详情
	*/
	public function chargedetail() {
		// echo 'todo 余额充值订单详情';
		$su_uid = AccountMod::has_su_login();
        $sp_uid = AccountMod::require_sp_uid();
		if((!$uid = requestInt('uid')) || (!$order = SuChargeMod::get_sucharge_order_by_uid($uid)) ||
			($order['sp_uid'] != $sp_uid) || ($order['su_uid'] != $su_uid)) {
			$order = array();
		}

		empty($GLOBALS['_UCT']['TPL']) && $GLOBALS['_UCT']['TPL'] = 'common';
        $params = array('sp_uid' => $sp_uid, 'order' => $order);
        $this->view_render($params);
	}

}

