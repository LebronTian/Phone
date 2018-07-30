<?php

class IndexCtl {
	/*
		海报小程序码图片
		接收2个参数

		qp_uid 海报uid
		uid 用户uid
	*/
	public function image() {
		$qp_uid= requestInt('qp_uid');
		if(!empty($qp_uid)){
			$qp = XcxposterMod::get_xcxposter_by_uid($qp_uid);
		}else{
			$sp_uid	 = AccountMod::require_sp_uid();
			$qp = XcxposterMod::get_default_xcxposter_by_sp_uid($sp_uid);
		}

		if(!$qp) {
			header('Content-Type:text/xml; charset=utf-8');
			echo '<h2>未开启小程序码海报功能！</h2>';
			return;
		}
		if(!($su_uid = requestInt('uid')) && !($su_uid = AccountMod::has_su_login())) {
			header('Content-Type:text/xml; charset=utf-8');
			echo '<h2>su_uid 参数错误！</h2>';
			return;
		}
		$etag = md5($su_uid.json_encode($qp['photo_info']));
		if(isset($_SERVER['HTTP_IF_NONE_MATCH']) && $_SERVER['HTTP_IF_NONE_MATCH'] == $etag) {
			header('Cache-Control: public');
			header('Etag: '.$etag);
			header("HTTP/1.1 304 Not Modified");
			exit();
    	}

		if(empty($qp['photo_info']['xcxpath'])) {
			$qp['photo_info']['xcxpath'] = 'page/index/index';
		}
		$public_uid = $qp['public_uid'];
		//带参数的路径, 最多10万个
		if(strpos($qp['photo_info']['xcxpath'], '?')) {
			$qp['photo_info']['xcxpath'] .= '&fromsu='.$su_uid;
			$url = DomainMod::get_app_url('qrxcx', $qp['sp_uid'], '_u=xiaochengxu.qrcode&path='.
					urlencode($qp['photo_info']['xcxpath']).'&public_uid='.$public_uid);
		} else {
			$scene = 'fromsu-'.$su_uid;
			$url = DomainMod::get_app_url('qrxcx', $qp['sp_uid'],'_u=xiaochengxu.qrcode&page='.
					$qp['photo_info']['xcxpath'].'&scene='.urlencode($scene).'&public_uid='.$public_uid);
		}
		#echo $url;die;

		if(!empty($qp['photo_info']['img_url'])) {
			uct_use_app('upload');
			$bg_path = UploadMod::get_file_dst_by_url($qp['photo_info']['img_url']);

			$option = array('back_ground' => array('path' => $bg_path), 
							'image' => array(array(
							'data'  => curl_file_get_contents($url),
							'circle' => 1,
							'size'  => array(!empty($qp['photo_info']['xcxcode']['w']) ? $qp['photo_info']['xcxcode']['w'] : 0,
											 !empty($qp['photo_info']['xcxcode']['h']) ? $qp['photo_info']['xcxcode']['h'] : 0),
							'point' => array(!empty($qp['photo_info']['xcxcode']['x']) ? $qp['photo_info']['xcxcode']['x'] : 0,
											 !empty($qp['photo_info']['xcxcode']['y']) ? $qp['photo_info']['xcxcode']['y'] : 0),
							),),
						);

			$su = AccountMod::get_service_user_by_uid($su_uid);
			if(!empty($qp['photo_info']['avatar']) && !empty($su['avatar'])) {
				$option['image'][1] = array(
						'data' => curl_file_get_contents(UploadMod::get_file_dst_by_url($su['avatar'])),
						'size'=> array(!empty($qp['photo_info']['avatar']['w']) ? $qp['photo_info']['avatar']['w'] : 0, 
									 !empty($qp['photo_info']['avatar']['h']) ? $qp['photo_info']['avatar']['h'] : 0),
						'point' => array(!empty($qp['photo_info']['avatar']['x']) ? $qp['photo_info']['avatar']['x'] : 0, 
									 !empty($qp['photo_info']['avatar']['y']) ? $qp['photo_info']['avatar']['y'] : 0),
									);
				//圆形头像
				if(!empty($qp['photo_info']['avatar_round'])) {
					$option['image'][1]['l'] = min($qp['photo_info']['avatar']['w'], 
								$qp['photo_info']['avatar']['h']) - 1;
				}
				
			}
			if(!empty($qp['photo_info']['nickname']) && !empty($su['name'])) {
				$option['string'][0] = array(
					'content' => $su['name'],
					'size' => !empty($qp['photo_info']['nickname']['h']) ? $qp['photo_info']['nickname']['h'] : 18,
					'point' => array(!empty($qp['photo_info']['nickname']['x']) ? $qp['photo_info']['nickname']['x'] : 0, 
									 !empty($qp['photo_info']['nickname']['y']) ? $qp['photo_info']['nickname']['y'] : 0),
					'color' => !empty($qp['photo_info']['nickcolor']) ? '#'.$qp['photo_info']['nickcolor'] : '000000',
				);
				//居中昵称
				if(!empty($qp['photo_info']['nickname_center'])) {
					#echo 'old point is -> '.$option['string'][0]['point']['0'].PHP_EOL;
					#echo $option['string'][0]['content'].' length is '.mb_strlen($option['string'][0]['content'], 'utf-8').PHP_EOL;
					#$option['string'][0]['content'] = 'gary';
					$option['string'][0]['point']['0'] = max($qp['photo_info']['nickname']['x'] - ($option['string'][0]['size'] * mb_strlen($option['string'][0]['content'], 'utf-8'))/2, 0);
					#echo 'new point is -> '.$option['string'][0]['point']['0'].PHP_EOL;
					$option['string'][0]['bold'] = 1;
				}
			}

			#include_once UCT_PATH . 'vendor/images/image.php';
			#$ii = getImageineInstance();
			#$img = $ii->create_vip_card($option);
			include_once UCT_PATH . 'vendor/images/my_gd.php';
			header('Etag: '.$etag);
			uct_gd_draw_poster($option);	
		}
		else { //未设置海报，直接返回二维码
			$img = file_get_contents($url);
		}

		if(!empty($_REQUEST['_d'])&&$_REQUEST['_d']==1) {
			echo $url;
			die();
		}elseif(!empty($_REQUEST['_d'])&&$_REQUEST['_d']==2){
			echo $img;
			die();
		}

		header('Content-Type: image/png');
		header('Cache-Control: public');
		header('Etag: '.$etag);
		echo $img;
		return;
	}
}

