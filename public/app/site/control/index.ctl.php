<?php

	class IndexCtl {
		public function init_site() {
			if(!($site = SiteMod::get_site())) {
				if(getLastError() == ERROR_BAD_STATUS) {
					echo '该网站已经下线!';	
				}
				else {
					echo '微官网内部错误! '.getErrorString();
				}
				exit();
			}

			//强制带上__sp_uid, 防止用户分享时出错
			if(0 && !isset($_GET['__sp_uid'])) {
				$url = getCurrentUrl();
				$url .= (strrpos($url, '?') ? '&' : '?').'__sp_uid='.$site['sp_uid'];
				redirectTo($url);
			}

			!isset($GLOBALS['_UCT']['TPL']) && ($GLOBALS['_UCT']['TPL'] = SiteMod::decide_site_tpl($site));
			return $site;
		}

		/*
			首页
		*/
		public function index() {
			$site = $this->init_site();

			if($cid = requestInt('cid')) {
				$cat = SiteMod::get_site_cat_by_uid($cid);
			}
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$children_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => $cid));
			
			$option['site_uid'] = $site['uid'];
			$slides = SiteMod::get_site_slides($option);
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$option['cat_uid'] = $cid;
			$option['page'] = requestInt('page');
			$option['limit'] = requestInt('limit', 10);
			$option['key'] = requestString('key');
			$articles = SiteMod::get_site_articles($option);
			$pagination = uct_pagination($option['page'], ceil($articles['count']/$option['limit']), 
							'?_a=site&_u=index.cats&site_uid='.$site['uid'].'&limit='.$option['limit'].'&page=');

			$params = array('site' => $site, 'slides' => $slides, 'parent_cats' => $parent_cats , 'children_cats' => $children_cats, 'articles' => $articles, 'option' => $option, 'pagination' => $pagination);
			
			render_fg('', $params);
		}

		/*
			分类页
		*/
		public function cats() {
			$site = $this->init_site();

			if($cid = requestInt('cid')) {
				$cat = SiteMod::get_site_cat_by_uid($cid);
			}
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			//二级分类
			$children_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => $cid));

			//文章列表
			$option['site_uid'] = $site['uid'];
			$option['cat_uid'] = $cid;
			$option['page'] = requestInt('page');
			$option['limit'] = requestInt('limit', 10);
			$option['key'] = requestString('key');
			$articles = SiteMod::get_site_articles($option);
			$pagination = uct_pagination($option['page'], ceil($articles['count']/$option['limit']), 
							'?_a=site&_u=index.cats&site_uid='.$site['uid'].'&limit='.$option['limit'].'&page=');

			$params = array('site' => $site, 'cat' => $cat, 'children_cats' => $children_cats, 'articles' => $articles, 
							'option' => $option, 'pagination' => $pagination,'parent_cats'=>$parent_cats);
			render_fg('', $params);
		}
		/*联系方式页*/

		public function contact(){
			$site = $this->init_site();
			
			$option['site_uid'] = $site['uid'];
			$slides = SiteMod::get_site_slides($option);
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));

			$params = array('site' => $site, 'slides' => $slides, 'parent_cats' => $parent_cats);

			render_fg('', $params);	
		}

		/*文章列表页*/
		public function articlelist(){
			$site = $this->init_site();

			if($cid = requestInt('cid')) {
				$cat = SiteMod::get_site_cat_by_uid($cid);
			}
			//文章列表
			$option['site_uid'] = $site['uid'];
			$option['cat_uid'] = $cid;
			$option['page'] = requestInt('page');
			$option['limit'] = requestInt('limit', 10);
			$option['key'] = requestString('key');
			$articles = SiteMod::get_site_articles($option);
			//var_dump($articles);exit;
			$pagination = uct_pagination($option['page'], ceil($articles['count']/$option['limit']), 
							'?_a=site&_u=index.cats&site_uid='.$site['uid'].'&limit='.$option['limit'].'&page=');
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$params = array('site' => $site, 'cat' => $cat,'articles' => $articles, 
							'option' => $option, 'pagination' => $pagination,'parent_cats'=>$parent_cats);
			render_fg('', $params);
		}


		public function search(){
			$site = $this->init_site();
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$option['site_uid'] = $site['uid'];
			$option['page'] = requestInt('page',0);
			$option['limit'] = requestInt('limit', 10);
			$option['key'] = requestString('key',PATTERN_SEARCH_KEY);
			$articles = SiteMod::get_site_articles($option);
			$pagination = uct_pagination($option['page'], ceil($articles['count']/$option['limit']), 
						'?_a=site&_u=index.search&key='.$option['key'].'&site_uid='.$site['uid'].'&limit='.$option['limit'].'&page=');
			$params = array('site' => $site,'articles' => $articles, 'pagination'=>$pagination,
						'option' => $option,'parent_cats'=>$parent_cats);
			render_fg('', $params);
		}


		/*
			文章页
		*/
		public function article() {
			$site = $this->init_site();
			if(!$uid = requestInt('cid')) {
				$uid = requestInt('uid');
			}
			
			$article = SiteMod::get_site_article_by_uid($uid);
			if(!$article || ($article['site_uid'] != $site['uid'])) {
				echo '文章不存在!'; 
				return;	
			}
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			//阅读数+1
			Dba::write('update site_articles set click_cnt = click_cnt + 1 where uid = '.$uid);		

			$params = array('site' => $site,'article'=>$article,'parent_cats'=>$parent_cats);
			render_fg('', $params);
		}

		/*
			文章页带留言功能
		*/
		public function article_with_reply() {
			$site = $this->init_site();
			$uid = requestInt('uid');
			$article = SiteMod::get_site_article_by_uid($uid);
			if(!$article || ($article['site_uid'] != $site['uid'])) {
				$article = array();
				//如果没有文章，则是只评论
				//return;
			}
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			//阅读数+1
			if(!empty($article['uid'])) {
				Dba::write('update site_articles set click_cnt = click_cnt + 1 where uid = '.$uid);		
			}

			$params = array('site' => $site,'article'=>$article,'parent_cats'=>$parent_cats);
			render_fg('', $params);
		}

		/*一级分类下的文章页*/
		public function mainarticle(){
			$site = $this->init_site();
			$uid = requestInt('cid');
			$article = SiteMod::get_site_article_by_uid($uid);
			if(!$article || ($article['site_uid'] != $site['uid'])) {
				echo '文章不存在!'; 
				return;	
			}
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			//阅读数+1
			Dba::write('update site_articles set click_cnt = click_cnt + 1 where uid = '.$uid);		

			$params = array('site' => $site,'article'=>$article,'parent_cats'=>$parent_cats);
			render_fg('', $params);		
		}

		/*
			公司地址
		*/
		public function map(){
			$site = $this->init_site();
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$params = array('site' => $site,'parent_cats'=>$parent_cats);
			render_fg('', $params);
		}

		public function media(){
			$site = $this->init_site();
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$params = array('site' => $site,'parent_cats'=>$parent_cats);
			render_fg('', $params);
		}




		public function tpldetail(){
			$site = $this->init_site();
			$params = array('site' => $site);
			render_fg('', $params);
		}

		/*
			用户留言 
		*/
		public function message(){
			$site = $this->init_site();
			$option['site_uid'] = $site['uid'];
			$option['status'] = 0;
			$option['page'] = requestInt('page');
			$option['limit'] = requestInt('limit', 10);
			$messages = SiteMod::get_site_messages($option);
			$su = AccountMod::get_current_service_user();
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$params = array('site' => $site,'parent_cats'=>$parent_cats, 'option' => $option, 'messages' => $messages, 'su' => $su);
			render_fg('', $params);
		}

		/*
			手机网站二维码
		*/
		public function qrcode() {
			$site = $this->init_site();

			//$url = 'http://'.$_SERVER['HTTP_HOST'].'?_a=site&site_uid='.$site['uid'];
			$url = DomainMod::get_app_url('site', $site['sp_uid']);
			require_once UCT_PATH.'vendor/phpQrcode/PHPQRCode.php';
			\PHPQRCode\QRcode::png($url);
		}

		public function contactus() {
			$site = $this->init_site();

			if($cid = requestInt('cid')) {
				$cat = SiteMod::get_site_cat_by_uid($cid);
			}
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$children_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => $cid));
			
			$option['site_uid'] = $site['uid'];
			$slides = SiteMod::get_site_slides($option);
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$option['cat_uid'] = $cid;
			$option['page'] = requestInt('page');
			$option['limit'] = requestInt('limit', 10);
			$option['key'] = requestString('key');
			$articles = SiteMod::get_site_articles($option);
			$pagination = uct_pagination($option['page'], ceil($articles['count']/$option['limit']), 
							'?_a=site&_u=index.cats&site_uid='.$site['uid'].'&limit='.$option['limit'].'&page=');

			$params = array('site' => $site, 'slides' => $slides, 'parent_cats' => $parent_cats , 'children_cats' => $children_cats, 'articles' => $articles, 'option' => $option, 'pagination' => $pagination);
			
			render_fg('', $params);
		}

		public function product() {
			$site = $this->init_site();

			if($cid = requestInt('cid')) {
				$cat = SiteMod::get_site_cat_by_uid($cid);
			}
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$children_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => $cid));
			
			$option['site_uid'] = $site['uid'];
			$slides = SiteMod::get_site_slides($option);
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$option['cat_uid'] = $cid;
			$option['page'] = requestInt('page');
			$option['limit'] = requestInt('limit', 10);
			$option['key'] = requestString('key');
			$articles = SiteMod::get_site_articles($option);
			$pagination = uct_pagination($option['page'], ceil($articles['count']/$option['limit']), 
							'?_a=site&_u=index.cats&site_uid='.$site['uid'].'&limit='.$option['limit'].'&page=');

			$params = array('site' => $site, 'slides' => $slides, 'parent_cats' => $parent_cats , 'children_cats' => $children_cats, 'articles' => $articles, 'option' => $option, 'pagination' => $pagination);
			
			render_fg('', $params);
		}
		public function industry() {
			$site = $this->init_site();

			if($cid = requestInt('cid')) {
				$cat = SiteMod::get_site_cat_by_uid($cid);
			}
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$children_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => $cid));
			
			$option['site_uid'] = $site['uid'];
			$slides = SiteMod::get_site_slides($option);
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$option['cat_uid'] = $cid;
			$option['page'] = requestInt('page');
			$option['limit'] = requestInt('limit', 10);
			$option['key'] = requestString('key');
			$articles = SiteMod::get_site_articles($option);
			$pagination = uct_pagination($option['page'], ceil($articles['count']/$option['limit']), 
							'?_a=site&_u=index.cats&site_uid='.$site['uid'].'&limit='.$option['limit'].'&page=');

			$params = array('site' => $site, 'slides' => $slides, 'parent_cats' => $parent_cats , 'children_cats' => $children_cats, 'articles' => $articles, 'option' => $option, 'pagination' => $pagination);
			
			render_fg('', $params);
		}
		public function news() {
			$site = $this->init_site();

			if($cid = requestInt('cid')) {
				$cat = SiteMod::get_site_cat_by_uid($cid);
			}
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$children_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => $cid));
			
			$option['site_uid'] = $site['uid'];
			$slides = SiteMod::get_site_slides($option);
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$option['cat_uid'] = $cid;
			$option['page'] = requestInt('page');
			$option['limit'] = requestInt('limit', 10);
			$option['key'] = requestString('key');
			$articles = SiteMod::get_site_articles($option);
			$pagination = uct_pagination($option['page'], ceil($articles['count']/$option['limit']), 
							'?_a=site&_u=index.cats&site_uid='.$site['uid'].'&limit='.$option['limit'].'&page=');

			$params = array('site' => $site, 'slides' => $slides, 'parent_cats' => $parent_cats , 'children_cats' => $children_cats, 'articles' => $articles, 'option' => $option, 'pagination' => $pagination);
			
			render_fg('', $params);
		}
		public function cooperation() {
			$site = $this->init_site();

			if($cid = requestInt('cid')) {
				$cat = SiteMod::get_site_cat_by_uid($cid);
			}
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$children_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => $cid));
			
			$option['site_uid'] = $site['uid'];
			$slides = SiteMod::get_site_slides($option);
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$option['cat_uid'] = $cid;
			$option['page'] = requestInt('page');
			$option['limit'] = requestInt('limit', 10);
			$option['key'] = requestString('key');
			$articles = SiteMod::get_site_articles($option);
			$pagination = uct_pagination($option['page'], ceil($articles['count']/$option['limit']), 
							'?_a=site&_u=index.cats&site_uid='.$site['uid'].'&limit='.$option['limit'].'&page=');

			$params = array('site' => $site, 'slides' => $slides, 'parent_cats' => $parent_cats , 'children_cats' => $children_cats, 'articles' => $articles, 'option' => $option, 'pagination' => $pagination);
			
			render_fg('', $params);
		}
		public function solution() {
			$site = $this->init_site();

			if($cid = requestInt('cid')) {
				$cat = SiteMod::get_site_cat_by_uid($cid);
			}
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$children_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => $cid));
			
			$option['site_uid'] = $site['uid'];
			$slides = SiteMod::get_site_slides($option);
			$parent_cats = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
			$option['cat_uid'] = $cid;
			$option['page'] = requestInt('page');
			$option['limit'] = requestInt('limit', 10);
			$option['key'] = requestString('key');
			$articles = SiteMod::get_site_articles($option);
			$pagination = uct_pagination($option['page'], ceil($articles['count']/$option['limit']), 
							'?_a=site&_u=index.cats&site_uid='.$site['uid'].'&limit='.$option['limit'].'&page=');

			$params = array('site' => $site, 'slides' => $slides, 'parent_cats' => $parent_cats , 'children_cats' => $children_cats, 'articles' => $articles, 'option' => $option, 'pagination' => $pagination);
			
			render_fg('', $params);
		}
	}

