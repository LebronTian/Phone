<?php
/*
	前端页面接口

	没有自动检查登陆权限, 需要自己检查
	AccountMod::has_su_login()
*/

class AjaxCtl {
	/*
		留言
	*/
	public function add_message() {
		if(!($site = SiteMod::get_site())) {
			outError();
		}

		$m['su_uid'] = AccountMod::has_su_login();
		if(!($m['name'] = requestString('name', PATTERN_USER_NAME))) {
			if(!$m['name'] =  AccountMod::get_current_service_user('name')) {
				$m['name'] =  AccountMod::get_current_service_user('account');
			}
		}
		if(!$m['name']) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		} 
		/*
			{brief: , imgs: , type: , title: }
		*/
		if(!($m['brief'] = requestString('brief'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$m['contact'] = requestStringLen('contact',64);

		
		$m['site_uid'] = $site['uid'];
		outRight(SiteMod::add_or_edit_message($m));
	}
	
	/*
		删除 ?
	*/
	public function del_message() {
			
	}

	/*
		留言列表 
	*/
	public function messages_list() {
		if(!($site = SiteMod::get_site())) {
			outError();
		}
		$option['su_uid'] = AccountMod::has_su_login();
		$option['site_uid'] = $site['uid'];
		$option['status'] = 0;
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		outRight(SiteMod::get_site_messages($option));
	}

	public function site() {
		if(!($site = SiteMod::get_site())) {
			outError();
		}
		outRight($site);
	}

	public function cats() {
		if(!($site = SiteMod::get_site())) {
			outError();
		}
		$option['site_uid'] = $site['uid'];
		$option['status'] = 0; //只取正常的

		outRight(SiteMod::get_site_cats($option));	
	}

	public function slides() {
		if(!($site = SiteMod::get_site())) {
			outError();
		}
		$option['site_uid'] = $site['uid'];
		$option['status'] = 0; //只取正常的

		outRight(SiteMod::get_site_slides($option));	
	}


	/*
		文章列表 
	*/
	public function article_list() {
		if(!($site = SiteMod::get_site())) {
			outError();
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
		获取文章详情 
	*/
	public function article() {
		if(!($site = SiteMod::get_site())) {
			outError();
		}
		if(!($uid = requestInt('uid')) || 
			!($a = SiteMod::get_site_article_by_uid($uid)) ||
			$a['site_uid'] != $site['uid']) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight($a);
	}

	/*
		文章留言
	*/
	public function add_article_reply() {
		if(!($site = SiteMod::get_site())) {
			outError();
		}

		if(!$ar['su_uid'] = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		
		if(!($ar['article_uid'] = requestInt('article_uid')) ||
			!($article = SiteMod::get_site_article_by_uid($ar['article_uid'])) ||
			$article['site_uid'] != $site['uid']) {
			$ar['article_uid'] = 0;
		}

		if(!($ar['brief'] = requestString('brief'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		$ar['site_uid'] = $site['uid'];
		outRight(SiteMod::add_or_edit_article_reply($ar));
	}
	
	/*
		删除 ?
	*/
	public function del_article_reply() {
			
	}

	/*
		留言列表 
	*/

	public function article_reply_list() {
		if(!($site = SiteMod::get_site())) {
			outError();
		}
		$option['article_uid'] = requestInt('article_uid');
		$option['site_uid'] = $site['uid'];
		$option['available'] = 1;
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		outRight(SiteMod::get_article_reply_list($option));
	}

	/*
		文章点赞
	*/
	public function like_article() {
		if(!($site = SiteMod::get_site())) {
			outError();
		}

		if(!($article_uid = requestInt('article_uid')) ||
			!($article = SiteMod::get_site_article_by_uid($article_uid)) ||
			$article['site_uid'] != $site['uid']) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		
		outRight(SiteMod::do_like_article($article));
	}
	
	/*
		客服服务列表 
	*/
	public function kefu_list() {
		if(!($site = SiteMod::get_site())) {
			outError();
		}
		$option['site_uid'] = $site['uid'];
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		outRight(SiteKefuMod::get_site_kefu_list($option));
	}

	/*
		获取客服服务详情 
	*/
	public function kefu() {
		if(!($site = SiteMod::get_site())) {
			outError();
		}
		if(!($uid = requestInt('uid')) || 
			!($a = SiteKefuMod::get_site_kefu_by_uid($uid)) ||
			$a['site_uid'] != $site['uid']) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight($a);
	}

	/*
		客服服务留言
	*/
	public function add_kefu_msg() {
		if(!($site = SiteMod::get_site())) {
			outError();
		}

		if(!$m['su_uid'] = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		//客服uid, 必填
		if(!($uid = requestInt('kf_uid')) || 
			!($kefu = SiteKefuMod::get_site_kefu_by_uid($uid)) ||
			$kefu['site_uid'] != $site['uid']) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$m['kf_uid'] = $kefu['uid'];

		$m['brief'] = requestString('brief');
		$m['contact'] = requestStringLen('contact',64);
		$m['time'] = requestInt('time');

		
		$m['site_uid'] = $site['uid'];
		outRight(SiteKefuMsgMod::add_or_edit_site_kefu_msg($m));
	}
	
}

