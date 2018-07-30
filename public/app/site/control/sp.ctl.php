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
			array('name' => '欢迎页', 'icon' => 'am-icon-home', 'link' => '?_a=site&_u=sp', 'activeurl' => 'sp.index'),
			array('name' => '内容管理', 'icon' => 'am-icon-file', 'menus' => array(
				array('name' => '分类列表', 'icon' => 'am-icon-th-large', 'link' => '?_a=site&_u=sp.catlist', 
						'activeurl' => 'sp.catlist'),
				array('name' => '文章列表', 'icon' => 'am-icon-file', 'link' => '?_a=site&_u=sp.articlelist', 
						'activeurl' => 'sp.articlelist'),
				array('name' => '首页幻灯片', 'icon' => 'am-icon-image', 'link' => '?_a=site&_u=sp.slidelist', 
						'activeurl' => 'sp.slidelist'),
				//array('name' => '视频管理', 'icon' => 'am-icon-home', 'link' => '?_a=site&_u=sp.videolist', 'activeurl' => 'sp.videolist'),
				)),

			array('name' => '网站设置', 'icon' => 'am-icon-gears', 'menus' => array(
				array('name' => '基本设置', 'icon' => 'am-icon-gear', 'link' => '?_a=site&_u=sp.set', 'activeurl' => 'sp.set'),
				array('name' => '地图设置', 'icon' => 'am-icon-map-marker', 'link' => '?_a=site&_u=sp.map', 'activeurl' => 'sp.map'),
				array('name' => '模板选择', 'icon' => 'am-icon-copy', 'link' => '?_a=site&_u=sp.tpls', 'activeurl' => 'sp.tpls')
				)),
			array('name' => '网站留言', 'icon' => 'am-icon-edit', 'link' => '?_a=site&_u=sp.messagelist', 'activeurl' => 'sp.messagelist'),
			array('name' => '客服服务', 'icon' => 'am-icon-user', 'link' => '?_a=site&_u=sp.kefulist', 'activeurl' => 'sp.kefulist'),

			/*
			array('name' => '网站设置', 'icon' => 'am-icon-weixin', 'menus' => array(
				array('name' => 'SEO设置', 'icon' => 'am-icon-th-large', 'link' => '?_a=site&_u=sp.setset', 
						'activeurl' => 'sp.seoset'),
				array('name' => '统计代码', 'icon' => 'am-icon-cubes', 'link' => '?_a=site&_u=sp.statset', 
						'activeurl' => 'sp.statset'),
				)),
			*/
		);
	}
	protected function sp_render($params = array()) {
		if(!empty($params['site']) && empty($GLOBALS['_UCT']['TPL'])) {
			//后台模板选择
			unset($_REQUEST['__tpl']);
			unset($_COOKIE['__tpl_site']);
			$GLOBALS['_UCT']['TPL'] = SiteMod::decide_site_tpl($params['site']);
		}
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	

		$cnts = Dba::readRowAssoc('select count(*) as total_article_cnt, sum(click_cnt) as total_click_cnt from site_articles where site_uid = '.$site['uid']);
		if(!$cnts['total_click_cnt']) $cnts['total_click_cnt'] = 0;
		$cnts['total_msg_cnt'] = Dba::readOne('select count(*) from site_messages where site_uid = '.$site['uid']);

		$sp_uid  = AccountMod::get_current_service_provider('uid');
		$visit = json_decode($GLOBALS['arraydb_sys']['visit_'.$sp_uid],true);
		$visit =(isset($visit[$GLOBALS['_UCT']['APP']])?$visit[$GLOBALS['_UCT']['APP']]:0);
		$params = array('site' => $site, 'cnts' => $cnts,'visit'=>$visit);
		$this->sp_render($params);
	}

	public function error() {
		echo '内部错误! '.getErrorString();
	}

	/*
		分类列表	
	*/
	public function catlist() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	
		$option['site_uid'] = $site['uid'];
		$option['with_parent_info'] = true;
		$option['parent_uid'] = requestInt('parent_uid');

		$option2['site_uid'] = $site['uid'];
		$option2['with_parent_info'] = true;
		$option2['parent_uid'] = -1;

		$catsAll = SiteMod::get_site_cats($option2);

		$cats = SiteMod::get_site_cats($option);
		$parents = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
		
		$params = array('site' => $site, 'option' => $option, 'cats' => $cats, 'parents' => $parents, 'catsAll' => $catsAll);
		$this->sp_render($params);
	}

	/*
		添加编辑分类
	*/
	public function addcat() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	
		$cat_uid = requestInt('uid');
		$cat = array();
		if($cat_uid) {
			$cat = SiteMod::get_site_cat_by_uid($cat_uid);
			if(!$cat || ($cat['site_uid'] != $site['uid'])) {
				$cat = array();
			}
		}
		$parents = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
		$params = array('site' => $site, 'cat' => $cat, 'parents' => $parents);
		$this->sp_render($params);
	}

	/*
		文章列表	
	*/
	public function articlelist() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	
		$option['site_uid'] = $site['uid'];
		$option['cat_uid'] = requestInt('cat_uid');
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$articles = SiteMod::get_site_articles($option);
		$cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => -1));
		$pagination = uct_pagination($option['page'], ceil($articles['count']/$option['limit']), 
						'?_a=site&_u=sp.articlelist&cat_uid='.$option['cat_uid'].'&key='.$option['key'].'&limit='.$option['limit'].'&page=');
		
		$params = array('site' => $site, 'option' => $option, 'articles' => $articles, 'cats' => $cats, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		添加编辑文章
	*/
	public function addarticle() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	
		$article_uid = requestInt('uid');
		$article = array();
		if($article_uid) {
			$article = SiteMod::get_site_article_by_uid($article_uid);
			if(!$article || ($article['site_uid'] != $site['uid'])) {
				$article = array();
			}
		}
		$parents = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => -1));
		$params = array('site' => $site, 'article' => $article, 'parents' => $parents);
		$this->sp_render($params);
	}

	/*
		幻灯片列表	
	*/
	public function slidelist() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	
		$option['site_uid'] = $site['uid'];

		$slides = SiteMod::get_site_slides($option);
		
		$params = array('site' => $site, 'option' => $option, 'slides' => $slides);
		$this->sp_render($params);
	}

	/*
		添加编辑幻灯片
	*/
	public function addslide() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	
		$slide_uid = requestInt('uid');
		$slide = array();
		if($slide_uid) {
			$slide = SiteMod::get_site_slide_by_uid($slide_uid);
			if(!$slide || ($slide['site_uid'] != $site['uid'])) {
				$slide = array();
			}
		}
		$params = array('site' => $site, 'slide' => $slide);
		$this->sp_render($params);
	}

	/*
		设置
	*/
	public function set() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	

		$language = array(
							array('uid' => 'zh_cn', 'title' => '中文'),
							array('uid' => 'en', 'title' => '英文'),
						);
		$params = array('site' => $site, 'language' => $language);
		$this->sp_render($params);
	}

	/*
		视频
	*/
	public function videolist(){
		if(!($site = SiteMod::get_site_by_sp_uid())){
			return $this->error();
		}
		$option['site_uid'] = $site['uid'];
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit',8);

		$videos = SiteMod::get_video($option);
		$pagination = uct_pagination($option['page'], ceil($videos['count']/$option['limit']),'?_a=site&_u=sp.videolist&limit='.$option['limit'].'&page=');

		$params = array('site' => $site, 'option' => $option, 'videos' => $videos, 'pagination'=>$pagination);
		
		$this->sp_render($params);
	}
	
	/*
		添加或者编辑视频
	*/
	public function addvideo(){
		if(!($site = SiteMod::get_site_by_sp_uid())){
			return $this->error();
		}
		$video_uid = requestInt('uid');
		$video = array();
		if($video_uid){
			$video = SiteMod::get_site_video_by_uid($video_uid);
			if(!$video || ($video['site_uid'] !== $site['uid'])){
				$video = array();
			}
		}

		$params = array('site' => $site, 'video' => $video);
		$this->sp_render($params);
	}


	public function map(){
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	

		$params = array('site' => $site);
		$this->sp_render($params);
	}

	/*
		选择模板
	*/
	public function tpls(){
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['type'] = requestString('type');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 8);


		$tpls = SiteMod::get_tpls_list($option);
		$pagination = uct_pagination($option['page'], ceil($tpls['count']/$option['limit']), 
						'?_a=site&_u=sp.tpls&type='.$option['type'].'&key='.$option['key'].'&limit='.$option['limit'].'&page=');
		
		$params = array('site' => $site, 'tpls' => $tpls, 'option' => $option, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	public function showdemo(){
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	
		$params = array('site' => $site);
		$this->sp_render($params);
	}
	public function demo(){
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	
		$params = array('site' => $site);
		$this->sp_render($params);
	}

	/*
		留言列表	
	*/
	public function messagelist() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			$this->error(); 
		}	
		$option['site_uid'] = $site['uid'];
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$messages = SiteMod::get_site_messages($option);
		$pagination = uct_pagination($option['page'], ceil($messages['count']/$option['limit']), 
						'?_a=site&_u=sp.messagelist&key='.$option['key'].'&limit='.$option['limit'].'&page=');
		
		$params = array('site' => $site, 'option' => $option, 'messages' => $messages, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		留言详情	
	*/
	public function messagedetail() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			$this->error(); 
		}	

		if(!($uid = requestInt('uid')) ||
			!($message = SiteMod::get_site_message_by_uid($uid)) ||
			$message['site_uid'] != $site['uid']) {
			redirectTo('?_a=site&_u=sp.messagelist');
		}
		
		
		$params = array('site' => $site, 'message' => $message);
		$this->sp_render($params);
	}

	/*
		文章评论列表	
	*/
	public function replylist() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			$this->error(); 
		}	
		$option['site_uid'] = $site['uid'];
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['article_uid'] = requestInt('article_uid', -1);

		$data = SiteMod::get_article_reply_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=site&_u=sp.replylist&key='.$option['key'].'&limit='.$option['limit'].'&page=');
		
		$params = array('site' => $site, 'option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		评论详情	
	*/
	public function replydetail() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			$this->error(); 
		}	

		if(!($uid = requestInt('uid')) ||
			!($r = SiteMod::get_article_reply_by_uid($uid)) ||
			$r['site_uid'] != $site['uid']) {
			redirectTo('?_a=site&_u=sp.replylist');
		}
		
		
		$params = array('site' => $site, 'reply' => $r);
		$this->sp_render($params);
	}

	public function addkefu() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			$this->error(); 
		}	

		$uid = requestInt('uid');
		$kf = array();
		if($uid) {
			$kf = SiteKefuMod::get_site_kefu_by_uid($uid);
			if(!$kf || ($kf['site_uid'] != $site['uid'])) {
				$kf = array();
			}
		}

		$params = array('item' => $kf);
		$this->sp_render($params);
	}

	/*
		客服服务列表	
	*/
	public function kefulist() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			$this->error(); 
		}	
		$option['site_uid'] = $site['uid'];
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$data = SiteKefuMod::get_site_kefu_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=site&_u=sp.kefulist&key='.$option['key'].'&limit='.$option['limit'].'&page=');
		
		$params = array('site' => $site, 'option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		客服服务留言列表	
	*/
	public function kefumsglist() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			$this->error(); 
		}	
		$option['site_uid'] = $site['uid'];
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$kefu = array();
		if($option['kf_uid'] = requestInt('kf_uid')) {
			$kefu = SiteKefuMod::get_site_kefu_by_uid($option['kf_uid']);
			if(!$kefu || ($kefu['site_uid'] != $site['uid'])) {
				$kefu = array();
			}
		}

		$option['sp_remark'] = requestInt('sp_remark', -1);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$data = SiteKefuMsgMod::get_site_kefu_msg_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=site&_u=sp.kefumsglist&key='.$option['key'].'&limit='.$option['limit'].'&page=');
		
		$params = array('site' => $site, 'option' => $option, 'data' => $data, 'pagination' => $pagination, 'kefu' => $kefu);
		$this->sp_render($params);
	}

	public function __construct() {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			$this->error(); exit(1);
		}	
		//todo 做一个步骤流程 第一次进入选择模板页面
		if(empty($site['tpl']) && empty($site['tpl_mobile'])) {
			if(!in_array($GLOBALS['_UCT']['ACT'], array('tpls'))) {
				redirectTo('?_a=site&_u=sp.tpls');
			}
		}
	}

	//后台模板设置
	public function __call($act, $args) {
		if(!($site = SiteMod::get_site_by_sp_uid())) {
			return $this->error();
		}	
		#echo 'hehe '.$act.PHP_EOL;
		#var_export($args);
		$params = array('site' => $site);
		$this->sp_render($params);
	}
}

