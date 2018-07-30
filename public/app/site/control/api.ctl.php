<?php

class ApiCtl {
	/*
		文章列表 
	*/
	public function article_list() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		$option['site_uid'] = $site['uid'];
		if($option['cat_uid'] = requestInt('cat_uid')) {
			//把子分类的文章也返回一下
			$cats = Dba::readAllOne('select uid from site_cats where site_uid = '.$site['uid'].
									' && parent_uid = '.$option['cat_uid']);
			if($cats) {
				array_push($cats, $option['cat_uid']);
				$option['cat_uid'] = $cats;
			}
		}

		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		outRight(SiteMod::get_site_articles($option));
	}

	/*
		添加编辑分类
	*/
	public function addcat() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(isset($_REQUEST['title']) && !($cat['title'] = requestStringLen('title', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}

		isset($_REQUEST['title_en']) && $cat['title_en'] = requestStringLen('title_en', 128);
		isset($_REQUEST['image']) && $cat['image'] = requestString('image', PATTERN_URL);
		isset($_REQUEST['image_icon']) && $cat['image_icon'] = requestString('image_icon', PATTERN_URL);
		isset($_REQUEST['brief']) && $cat['brief'] = requestString('brief');
		isset($_REQUEST['sort']) && $cat['sort'] = requestInt('sort');
		isset($_REQUEST['status']) && $cat['status'] = requestInt('status');
		isset($_REQUEST['parent_uid']) && $cat['parent_uid'] = requestInt('parent_uid');

		if(empty($cat)) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}
		isset($_REQUEST['uid']) && $cat['uid'] = requestInt('uid');
		$cat['site_uid'] = $site['uid'];

		outRight(SiteMod::add_or_edit_cat($cat));
	}

	/*
		删除分类
	*/
	public function delcat() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(!($cids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SiteMod::delete_cat($cids, $site['uid']));
	}

	/*
		添加编辑文章
	*/
	public function addarticle() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(isset($_REQUEST['title']) && !($article['title'] = requestStringLen('title', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}

		isset($_REQUEST['seo_words']) && $article['seo_words'] = requestStringLen('seo_words', 255);
		isset($_REQUEST['content']) && $article['content'] = requestString('content');
		isset($_REQUEST['digest']) && $article['digest'] = requestStringLen('digest', 255);
		isset($_REQUEST['image']) && $article['image'] = requestString('image', PATTERN_URL);
		isset($_REQUEST['image_icon']) && $article['image_icon'] = requestString('image_icon', PATTERN_URL);
		isset($_REQUEST['sort']) && $article['sort'] = requestInt('sort');
		isset($_REQUEST['status']) && $article['status'] = requestInt('status');
		isset($_REQUEST['cat_uid']) && $article['cat_uid'] = requestInt('cat_uid');
		if(isset($_REQUEST['create_time'])) {
			$article['create_time'] = strtotime(requestString('create_time', PATTERN_DATETIME));
		}
		isset($_REQUEST['author']) && $article['author'] = requestString('author', PATTERN_ACCOUNT);

		if(empty($article)) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}
		isset($_REQUEST['uid']) && $article['uid'] = requestInt('uid');
		$article['site_uid'] = $site['uid'];

		outRight(SiteMod::add_or_edit_article($article));
	}

	/*
		删除文章
	*/
	public function delarticle() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(!($aids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SiteMod::delete_articles($aids, $site['uid']));
	}

	/*
		添加编辑幻灯片
	*/
	public function addslide() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(isset($_REQUEST['title']) && !($slide['title'] = requestStringLen('title', 64))) {
			//outError(ERROR_INVALID_REQUEST_PARAM);	
		}

		isset($_REQUEST['link']) && $slide['link'] = requestString('link', PATTERN_URL);
		isset($_REQUEST['image']) && $slide['image'] = requestString('image', PATTERN_URL);
		isset($_REQUEST['sort']) && $slide['sort'] = requestInt('sort');
		isset($_REQUEST['status']) && $slide['status'] = requestInt('status');

		if(empty($slide)) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}
		isset($_REQUEST['uid']) && $slide['uid'] = requestInt('uid');
		$slide['site_uid'] = $site['uid'];

		outRight(SiteMod::add_or_edit_slide($slide));
	}

	/*
		删除幻灯片
	*/
	public function delslide() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(!($sids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SiteMod::delete_slides($sids, $site['uid']));
	}

	/*
		网站设置
	*/
	public function set() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(isset($_REQUEST['title']) && !($new_site['title'] = requestStringLen('title', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}

		//设置时删除模板cookie
		setcookie('__tpl_site', '', time()-3600, '/');

		isset($_REQUEST['tpl']) && $new_site['tpl'] = requestString('tpl', PATTERN_NORMAL_STRING);
		isset($_REQUEST['tpl_mobile']) && $new_site['tpl_mobile'] = requestString('tpl_mobile', PATTERN_NORMAL_STRING);
		isset($_REQUEST['seo_words']) && $new_site['seo_words'] = requestStringLen('seo_words', 255);
		isset($_REQUEST['stat_code']) && $new_site['stat_code'] = requestStringLen('stat_code', 512);
		isset($_REQUEST['logo']) && $new_site['logo'] = requestString('logo', PATTERN_URL);
		isset($_REQUEST['status']) && $new_site['status'] = requestInt('status');

		isset($_REQUEST['qr_code']) && $new_site['qr_code'] = requestString('qr_code', PATTERN_URL);
		isset($_REQUEST['qq_code']) && $new_site['qq_code'] = requestStringLen('qq_code', 512);
		isset($_REQUEST['phone']) && $new_site['phone'] = requestString('phone', PATTERN_PHONE);
		isset($_REQUEST['location']) && $new_site['location'] = requestStringLen('location', 255);
		isset($_REQUEST['brief']) && $new_site['brief'] = requestString('brief');
		if(isset($_REQUEST['more_info'])) {
			 $new_site['more_info'] = json_decode(requestString('more_info'), true);
		}
		if(isset($_REQUEST['language'])) {
			$new_site['language'] = requestString('language');
			if(!in_array($new_site['language'], array('zh_cn', 'en'))) {
				$new_site['language'] = 'zh_cn';
			}
		}

		if(empty($new_site)) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}
		$new_site['uid'] = $site['uid'];

		outRight(SiteMod::set($new_site));
	}

	/*
		删除留言
	*/
	public function delmessage() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(!($mids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SiteMod::delete_message($mids, $site['uid']));
	}

	/*
		留言审核
	*/
	public function reviewmessage() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(!($mids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$status = requestInt('status');

		outRight(SiteMod::review_message($mids, $status, $site['uid']));
	}

	/*
		留言回复
	*/
	public function replymessage() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(!($uid = requestInt('uid')) ||
			!($msg = SiteMod::get_site_message_by_uid($uid)) ||
			$msg['site_uid'] != $site['uid']) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		if(!$reply['brief'] = requestString('brief')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$reply['msg_uid'] = $uid;

		outRight(SiteMod::add_or_edit_message_reply($reply));
	}


	/*
		添加视频
	*/
	public function add_video(){
		if(!($site = SiteMod::get_site_by_sp_uid())){
			outError(ERROR_DBG_STEP_1);
		}


		isset($_REQUEST['address']) && $video['address'] = requestString('address',PATTERN_URL);
		isset($_REQUEST['describle']) && $video['describle'] = requestStringLen('describle',512);
		isset($_REQUEST['image']) && $video['image'] = requestString('image',PATTERN_URL);
		isset($_REQUEST['sort']) && $video['sort'] = requestInt('sort');
		isset($_REQUEST['status']) && $video['status'] = requestInt('status');
		isset($_REQUEST['create_time']) && $video['create_time'] = requestInt('create_time');	

		
		if(empty($video)){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $video['uid'] = requestInt('uid');
		$video['site_uid'] = $site['uid'];
		

		outRight(SiteMod::add_or_edit_video($video));
	}

	
	/*
		删除视频
	*/
	public function delete_video(){
		if(!($site = SiteMod::get_site_by_sp_uid())){
			outError(ERROR_DBG_STEP_1);
		}

		if(!($cids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SiteMod::delete_video($cids, $site['uid']));
	}

	public function clear_site_data() {
		if(!($site = SiteMod::get_site_by_sp_uid())){
			outError(ERROR_DBG_STEP_1);
		}

		outRight(SiteSampleMod::clear_site_data($site['uid']));
	}

	/*
		删除文章评论
	*/
	public function delreply() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(!($mids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SiteMod::delete_article_reply($mids, $site['uid']));
	}

	/*
		评论审核
	*/
	public function reviewreply() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(!($mids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$status = requestInt('status');

		outRight(SiteMod::review_article_reply($mids, $status, $site['uid']));
	}

	/*
		添加编辑文章评论
	*/
	public function addreply() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 

		isset($_REQUEST['brief']) && $r['brief'] = requestString('brief');
		isset($_REQUEST['sort']) && $r['sort'] = requestInt('sort');
		isset($_REQUEST['status']) && $r['status'] = requestInt('status');
		isset($_REQUEST['su_uid']) && $r['su_uid'] = requestInt('su_uid');
		isset($_REQUEST['article_uid']) && $r['article_uid'] = requestInt('article_uid');

		if(empty($r)) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}
		isset($_REQUEST['uid']) && $r['uid'] = requestInt('uid');
		$r['site_uid'] = $site['uid'];

		outRight(SiteMod::add_or_edit_article_reply($r));
	}

	public function addkefu() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(isset($_REQUEST['title']) && !($kefu['title'] = requestStringLen('title', 64))) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}

		isset($_REQUEST['brief']) && $kefu['brief'] = requestString('brief');
		isset($_REQUEST['tags']) && $kefu['tags'] = requestStringLen('tags', 512);
		isset($_REQUEST['image']) && $kefu['image'] = requestString('image', PATTERN_URL);
		isset($_REQUEST['phone']) && $kefu['phone'] = requestString('phone', PATTERN_URL);
		isset($_REQUEST['sort']) && $kefu['sort'] = requestInt('sort');
		isset($_REQUEST['status']) && $kefu['status'] = requestInt('status');
		isset($_REQUEST['type']) && $kefu['type'] = requestStringLen('type',32);
		if(isset($_REQUEST['create_time'])) {
			$article['create_time'] = strtotime(requestString('create_time', PATTERN_DATETIME));
		}
		isset($_REQUEST['serve_point']) && $kefu['serve_point'] = requestStringLen('serve_point', 32);
		isset($_REQUEST['serve_count']) && $kefu['serve_count'] = requestStringLen('serve_count', 32);
		isset($_REQUEST['serve_level']) && $kefu['serve_level'] = requestStringLen('serve_level', 32);

		if(empty($kefu)) {
			outError(ERROR_INVALID_REQUEST_PARAM);	
		}
		isset($_REQUEST['uid']) && $kefu['uid'] = requestInt('uid');
		$kefu['site_uid'] = $site['uid'];

		outRight(SiteKefuMod::add_or_edit_site_kefu($kefu));
	}

	/*
		删除客服服务
	*/
	public function delkefu() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(!($uids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SiteKefuMod::delete_site_kefu($uids, $site['uid']));
	}

	/*
		删除客服留言
	*/
	public function delkefumsg() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		if(!($uids = requestIntArray('uids'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		//$kf_uid = requestInt('kf_uid');

		outRight(SiteKefuMsgMod::delete_site_kefu_msg($uids, $site['uid']));
	}

	/*
		做颜色标记
	*/
	public function markkefumsg()
	{
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			outError(ERROR_DBG_STEP_1);
		} 
		isset($_REQUEST['uids']) && $uids = requestStringArray('uids');
		isset($_REQUEST['sp_remark']) && $sp_remark= requestInt('sp_remark');
		//$kf_uid = requestInt('kf_uid');
		if(empty($uids)||empty($sp_remark)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SiteKefuMsgMod::remark_site_kefu_msg($uids, $sp_remark,$site['uid']));
	}

}

