<?php


class indexCtl {
	/*
	*/
	public static function is_spider_agent() {
		$client = strtolower(isset($_REQUEST['_agent']) ? $_REQUEST['_agent'] : $_SERVER['HTTP_USER_AGENT']);
		$ua_arr = array(
			'baiduspider' => 'baidu',
			'360spider'   => '360',
			'sosospider'  => 'soso',
			'googlebot'   => 'google',
			'msnbot'      => 'bing',
		);	

		foreach($ua_arr as $k => $v) {
			if(false !== strpos($client, $k)) {
				return $v;
			}
		}

		return false;
	}

	public function index() {
		/*
		if(AccountMod::get_current_service_user()) {
			echo '您好 '.$GLOBALS['service_user']['name'].'！';

			echo '服务提供商 '.AccountMod::get_current_service_provider('name');
		}
		else {
			echo '您好 游客！';
		}

		echo '<a href="?_a=sp&_u=index.login">商户登陆</a>';
		*/

		#redirectTo('?_a=sp');
		if(1&&isMobileBrowser()) {
			#uct_set_mirror_tpl('', '', 'about');
			#return render();
			#render('index/index_mobile.tpl');
			//跳转到 展示页
			/*
				网盟    http://www.rabbitpre.com/m/riMvamF?cnl=babgyb
				关键字　http://www.rabbitpre.com/m/riMvamF?cnl=fhiylr
				信息流　http://www.rabbitpre.com/m/riMvamF?cnl=jcxngm
				知道　　http://www.rabbitpre.com/m/riMvamF?cnl=jhsfca
			*/
			$cnl = requestString('cnl');
			redirectTo('http://a2.rabbitpre.com/m/riMvamF?cnl='.$cnl);
			redirectTo('http://v6.rabbitpre.com/m/ABf22m5');
			redirectTo('http://d.eqxiu.com/s/X0nmLSEx?eqrcode=1');
			//redirectTo('http://a3.rabbitpre.com/m/JbIrAn1');
			//redirectTo('http://a2.rabbitpre.com/m/uibiz7IBM');
		}
		else {
			//首页跳转一下
			if(in_array(getDomainName(), array('uctphp.com', 'www.uctphp.com'))) {
				redirectTo((isHttps() ? 'https://' : 'http://').'weixin.uctphp.com');
			}

			if(self::is_spider_agent()) {
				uct_set_mirror_tpl('', '', 'about');
			}

			uct_set_mirror_tpl('', '', 'index2');

			render();
		}
	}

	/*
		生成二维码
	*/
	public function qrcode() {
		//304支持
		if (isset($_SERVER['HTTP_IF_MODIFIED_SINCE']))
		{
			header('Cache-Control: public');
			header('Last-Modified:' . $_SERVER['HTTP_IF_MODIFIED_SINCE'], true, 304);
			exit();
		}
		
		$url = requestString('url');
		require_once UCT_PATH.'vendor/phpQrcode/PHPQRCode.php';

		header('Cache-Control: public');
		header('Last-Modified: ' . $_SERVER['REQUEST_TIME']);
		\PHPQRCode\QRcode::png($url);
	}

	
	/*
		ip地址查询
		默认查询客户端ip
	*/
	public function ip2address() {
		if(!$ip = requestString('ip', PATTERN_IP)) {
			$ip = requestClientIP();
		}	

		require_once UCT_PATH.'vendor/ipip/IP.class.php';
		
		$ret = IP::find($ip);
		
		outRight($ret);
	}

	/*
		跳转url
	*/
	public function goto_url() {
		if(!$url = requestString('url', PATTERN_URL)) {
			echo 'do not know where to go';
			return;
		}
		else {
			if(!empty($_REQUEST['must_login'])) {
				uct_use_app('su');
				SuMod::require_su_uid();
			}
			if(!empty($_REQUEST['a'])) {
				header('Content-Type: text/html; charset=utf-8');
				echo '<a style="font-size:32px;" href="'.$url.'">点击前往</a>';
				#echo '<script>window.location.href="'.$url.'";</script>';
				exit();
			}

			echo '<head><meta http-equiv="refresh" content="0;url='.$url.'"> </head>';
			exit();
		}
	}
	
	public function open_url() {
		if(!$url = requestString('url', PATTERN_FULLURL)) {
			echo 'do not know where to open';
			return;
		}
		$ch = curl_init($url);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($ch, CURLOPT_HEADER, true);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

		curl_setopt($ch, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']);
		list($header, $contents) = preg_split('/([\r\n][\r\n])\\1/', curl_exec($ch), 2);
		$header_text = preg_split('/[\r\n]+/', $header);
		foreach($header_text as $h) {
		    if(preg_match('/^(?:Content-Type|Content-Language|Set-Cookie):/i', $h)){
		        header($h);
    		}
		}

		curl_close($ch);
		echo $contents;	
		exit();
	}

	/*
		拨打电话
	*/
	public function tel() {
		if(!$phone = requestString('phone', PATTERN_PHONE)) {
			echo 'do not know which to call';
			return;
		}
		else {
			echo '<head><meta http-equiv="refresh" content="0;url=tel:'.$phone.'"> </head>';
			exit();
		}
	}

	/*
		查看文章
	*/
	public function article() {
		uct_use_app('sp');
		if(!($uid = requestInt('uid')) || !($doc = SpMod::get_document_by_uid($uid))) {
			echo 'article not exist!';
			return;
		}

		$params = array('doc' => $doc);
		render_fg('', $params);
	}

	/*
		地图


		百度地图获取经纬度
		http://api.map.baidu.com/lbsapi/getpoint/

		高德地图获取经纬度
		http://lbs.amap.com/console/show/picker
	*/
	public function map() {
		$lat = requestFloat('lat'); //纬度
		$lng = requestFloat('lng'); //经度
		$name = requestString('name', '', '地图');

		//这个是高德地图
		$map = requestString('map', '', 'baidu');
		if($map == 'gaode') {
			redirectTo('http://m.amap.com/navi/?dest='.$lng.','.$lat.'&destName='.urlencode($name)
					.'&key=fe8d0e9cfe462f86662a359a0168d173');
		} else if($map == 'baidu') {
			redirectTo('http://api.map.baidu.com/marker?location='.$lat.','.$lng.
					'&title='.urlencode($name).'&content='.urlencode($name).'&output=html&src=');
		}

		//百度地图
		$params = array('lat' => $lat, 'lng' => $lng, 'name' => $name);
		render_fg('', $params);
	}


    /*  
        经纬度转地名    
        使用了腾讯地图api
        http://lbs.qq.com/webservice_v1/guide-gcoder.html

		@see app/web/tpl/common/common_get_location.tpl

		其他家的接口
		http://lbsyun.baidu.com/index.php?title=webapi/guide/webservice-geocoding
		http://api.map.baidu.com/geocoder/v2/?callback=renderReverse&location=39.983424,116.322987&output=json&pois=1&ak=
        http://gc.ditu.aliyun.com/regeocoding?l=39.938133,116.395739&type=001
    */
    public function geo2name() {
        $lat = requestFloat('lat'); //纬度
        $lng = requestFloat('lng'); //经度

        //(100代表道路，010代表POI，001代表门址，111可以同时显示前三项)
        //$type = requestString('type', '010'); 
        $map = requestString('map', 'tenxun');  //地图坐标类型
        $map_arr = array('baidu' => 3,  
                        'tenxun' => 5,
                        'gaode' => 5,
                        'google' => 5,
                        'gps' => 1,
                        'sougou' => 2,
                    );
        $map = isset($map_arr[$map]) ? $map_arr[$map] : $map_arr['tenxun'];
    

        //腾讯接口 http://apis.map.qq.com/ws/geocoder/v1/?location= 
        $key = '3ZEBZ-Y3U36-EPISL-MNUGJ-2OZ46-ZHF35';
        $url = 'http://apis.map.qq.com/ws/geocoder/v1/?location='.$lat.','.$lng.
                '&coord_type='.$map;

		//附近的地标 选填,具体参数请参考腾讯地图文档
        $get_poi = requestInt('get_poi');
		if($get_poi) {
        	$poi_option = requestString('poi_options');
        	$url .= '&get_poi='.$get_poi.'&poi_options='.$poi_option;
		}
        $url .= '&key='.$key;
    
        $ret2 = $ret = file_get_contents($url);
        if(!$ret || !($ret = @json_decode($ret, true)) || empty($ret['result'])) {
            outError(ERROR_DBG_STEP_1);
        }

        outRight($ret['result']);
    }


	//小程序能用吗
	public function frame() {
		// http://720yun.com/t/78djk5syza6?pano_id=3822734
		$url = requestString('url', PATTERN_FULLURL);
if($url) {
$html = '<head><meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests"></head>
<body style="margin:0;">
<iframe src="'.$url.'" style="width:100%;height:100%;border:0;margin:0;padding:0;"></iframe>
</body>';	
} else {
echo '<h2>under construction ... </h2>';
}
		echo $html;
	}

	//全景展示
	public function vr() {
			render();
	}

	//销控表
	public function table() {
			render();
	}

	//销控表统计
	public function table_chart() {
			render();
	}

	public function component(){
		$component=array('pre_auth_code'=>ComponentMod::get_pre_auth_code(),
						'sp_uid'=>accountMod::get_current_service_provider('uid')
						);
							// var_dump($component);exit;
		$params = array('component' => $component);
		render_fg('', $params);
	}


	/*
		使用手册
	*/
	public function help(){
	$cats = WeixinPlugMod::get_weixin_plugin_cats();

		$option['cat'] = requestString('cat');
		if($option['cat'] && !isset($cats[$option['cat']])) {
			$option['cat'] = '';
		}
		$option['page'] = requestInt('page', 0);
		if(!$option['limit'] = requestInt('limit', 8)) {
			$option['limit'] = 8;
		}
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$data = WeixinPlugMod::get_store_plugins_list(0, $option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']),
			'?_a=web&_u=index.help&cat='.$option['cat'].'&key='.$option['key'].'&limit='.$option['limit'].'&page=');

		$params = array('cats' => $cats, 'option' => $option, 'data' => $data, 'pagination' => $pagination);
		// var_dump($params);
		render('',$params);
	}

	
	/*
		表单
	*/
	public function form(){
		render();
	}	


	/*
	插件商城
*/
	public function pluginstore() {
		$cats = WeixinPlugMod::get_weixin_plugin_cats();

		$option['cat'] = requestString('cat');
		if($option['cat'] && !isset($cats[$option['cat']])) {
			$option['cat'] = '';
		}
		$option['page'] = requestInt('page', 0);
		if(!$option['limit'] = requestInt('limit', 8)) {
			$option['limit'] = 8;
		}
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$data = WeixinPlugMod::get_store_plugins_list(0, $option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']),
			'?_a=web&_u=index.pluginstore&cat='.$option['cat'].'&key='.$option['key'].'&limit='.$option['limit'].'&page=');

		$params = array('cats' => $cats, 'option' => $option, 'data' => $data, 'pagination' => $pagination);

		render('',$params);

	}

	public function plugindetail() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			if(!($dir = requestString('dir', PATTERN_APP_NAME)) ||
				!($plugin = WeixinPlugMod::get_plugin_by_dir($dir)) ||
				$plugin['has_installed']) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}

			$plugin['dir'] = $dir;
			outRight(WeixinPlugMod::install_a_plugin($plugin));
		}

		if(!($dir = requestString('dir', PATTERN_APP_NAME)) ||
			!($plugin = WeixinPlugMod::get_plugin_by_dir($dir))) {
			redirectTo('?_a=web&_u=index.pluginstore');
		}

		$params = array('plugin' => $plugin);
		render('',$params);

	}

	public static function get_plugins_explain_by_dir()
	{
		$option['dir'] = requestString('dir',PATTERN_NORMAL_STRING);
		$option['limit'] = 1;
		$option['page'] = 0;
		outRight(WeixinPlugMod::get_weixin_plugins_explain_list($option));
	}

	public static function problemlist()
	{
		$option['type'] = requestString('type');
		$option['key'] = requestString('key');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
//		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');

		uct_use_app('sp');
		$types = SpMod::get_all_type();
		$documents = SpMod::get_problems($option);
		$pagination = uct_pagination($option['page'], ceil($documents['count']/$option['limit']),
			'?_a=web&_u=index.problemlist&type='.$option['type'].'&key='.$option['key'].'&limit='.$option['limit'].'&page=');

		$params = array('data' => $documents,'types' => $types,'option' => $option, 'pagination' => $pagination);

		render('',$params);
	}

	public static function problem()
	{
		uct_use_app('sp');
		if(!($uid = requestInt('uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$data = SpMod::get_problem_by_uid($uid);

		Dba::write('update service_problem set read_cnt=read_cnt+1 where uid = '.$uid);
		$params = array('data' => $data);

		render('',$params);
	}

}

