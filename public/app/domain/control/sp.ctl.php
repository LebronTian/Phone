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
			array('name' => '绑定域名', 'icon' => 'am-icon-list', 'link' => '?_a=domain&_u=sp', 'activeurl' => 'sp.index'),
		);
	}

	protected function sp_render($params = array()) {
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index() {
		$option = array(	
						'sp_uid' => AccountMod::get_current_service_provider('uid'),
						);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$ds = DomainMod::get_domain_list($option);
		$params = array('domains' => $ds);
		$this->sp_render($params);
	}

	/*
		添加或编辑域名
	*/
	public function adddomain() {
		$params = array();
		if(($uid= requestInt('uid')) && ($d = DomainMod::get_domain_by_uid($uid)) &&
			($d['sp_uid'] == AccountMod::get_current_service_provider('uid'))) {
			$params['domain'] = $d;
		}

		$this->sp_render($params);
	}


    /*
    二维码
*/
    public function qrcode() {

        $domain = requeststring('domain');
        $url = (isHttps() ? 'https://' : 'http://') . $domain;
        require_once UCT_PATH.'vendor/phpQrcode/PHPQRCode.php';
        \PHPQRCode\QRcode::png($url);
    }
	
}

