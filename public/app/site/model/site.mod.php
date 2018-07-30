<?php

class SiteMod {
	public static function func_get_site($item) {
		$item['title'] = htmlspecialchars($item['title']);
		$item['seo_words'] = htmlspecialchars($item['seo_words']);
		if(!empty($item['digest'])) $item['digest'] = htmlspecialchars($item['digest']);
		if(!empty($item['brief'])) $item['brief'] = XssHtml::clean_xss($item['brief']);
		if(!empty($item['more_info'])) $item['more_info'] = json_decode($item['more_info'], true);
		return $item;
	}

	public static function func_get_cat($item) {
		$item['title'] = htmlspecialchars($item['title']);
		$item['title_en'] = htmlspecialchars($item['title_en']);
		!empty($item['brief']) && $item['brief'] = htmlspecialchars($item['brief']);
		return $item;
	}

	public static function func_get_article($item) {
		$item['title'] = htmlspecialchars($item['title']);
		if(!empty($item['seo_words'])) $item['seo_words'] = htmlspecialchars($item['seo_words']);
		if(!empty($item['content'])) $item['content'] = XssHtml::clean_xss($item['content']);
		if(!empty($item['cat_uid'])) $item['cat'] = self::get_site_cat_by_uid($item['cat_uid']);

		return $item;
	}

	public static function func_get_message($item) {
		$item['name'] = htmlspecialchars($item['name']);
		$item['contact'] = htmlspecialchars($item['contact']);
		//$item['brief'] = XssHtml::clean_xss($item['brief']);
		if ($item['brief']) {
			if($brief = @json_decode($item['brief'], true)) {
				$item = array_merge($item, $brief);
			}
		}

		if($item['uid']) {
			$item['reply'] = Dba::readAllAssoc('select * from site_messages_reply where msg_uid = '.$item['uid']);
		}

		return $item;
	}

	public static function func_get_video($item){

		if(!empty($item['describle'])) $item['describle'] = htmlspecialchars($item['describle']);
		if(!empty($item['address'])) $item['address'] = htmlspecialchars($item['address']);

		return $item;
	}

	public static function func_get_article_reply($item) {
		if(!empty($item['brief'])) $item['brief'] = htmlspecialchars($item['brief']);
		if(!empty($item['su_uid'])) $item['su'] = AccountMod::get_service_user_by_uid($item['su_uid']);

		return $item;
	}

	/*
		确定站点模板	
				1. url参数指定 __tpl
				2. cookie中 __tpl_site
				3. 根据 用户设置和客户端浏览器 判断
	*/
	public static function decide_site_tpl($site) {
		if(isset($_REQUEST['__tpl']) && $tpl = checkString($_REQUEST['__tpl'], PATTERN_NORMAL_STRING)) {
			setcookie('__tpl_site', $tpl, 0, '/');
		}
		else if(isset($_COOKIE['__tpl_site']) && $tpl = checkString($_COOKIE['__tpl_site'], PATTERN_NORMAL_STRING)) {
		}
		else {
			if(isMobileBrowser() && $site['tpl_mobile']) {
				$tpl = $site['tpl_mobile'];	
			}	
			else {
				$tpl = $site['tpl'] ? $site['tpl'] : 'eyeis';
			}
		}

		return $tpl;
	}

	/*
		获取站点信息
		
		如果网站不存在或已经下线,将返回false

		通过$_GET['site_uid'] 或 $_GET['sp_uid']来确定
	*/
	public static function get_site() {
		if($site_uid = requestInt('site_uid')) {
			$site = Dba::readRowAssoc('select * from site where uid = '.$site_uid, 'SiteMod::func_get_site');
		}
		else if($sp_uid = AccountMod::require_sp_uid()) {
			$site = self::get_site_by_sp_uid($sp_uid);
		}
		else {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}

		if($site['status']) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		return $site;
	}

	/*
		获取微官网信息
	*/
	public static function get_site_by_sp_uid($sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}

		$sql = 'select * from site where sp_uid = '.$sp_uid;
		if(!($site = Dba::readRowAssoc($sql, 'SiteMod::func_get_site'))) {
			//todo 创建一个官网，添加一些数据进去
			$site = array('sp_uid' => $sp_uid,
						  'title' => AccountMod::get_current_service_provider('name').'',
		            	  'create_time' => $_SERVER['REQUEST_TIME'],
					);
			Dba::insert('site', $site);
			$site = Dba::readRowAssoc($sql, 'SiteMod::func_get_site');
		}
	
		return $site;
	}


	/*
		文章分类
		不需要分页
	*/
	public static function get_site_cats($option) {
		$sql = 'select * from site_cats';	
		if(!empty($option['site_uid'])) {
			$where_arr[] = 'site_uid = '.$option['site_uid'];
		}
		if(isset($option['parent_uid']) && $option['parent_uid'] >= 0) {
			$where_arr[] = 'parent_uid = '.$option['parent_uid'];
		}
		if(isset($option['status'])) {
			$where_arr[] = 'status = '.$option['status'];
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .= ' order by sort desc, create_time';

		$cats = Dba::readAllAssoc($sql, 'SiteMod::func_get_cat');

		//获取父级分类信息
		if(!empty($option['with_parent_info']) && $cats) {
			foreach($cats as $k => $c) {
				if($c['parent_uid']) {
					$cats[$k]['parent_cat'] = self::get_site_cat_by_uid($c['parent_uid']);
				}
			}
		}

		return $cats;
	}

	/*
		文章列表, 不包含content 和 seo_words
	*/
	public static function get_site_articles($option) {
		$sql = 'select uid,site_uid,cat_uid,title,digest,image,image_icon,create_time,modify_time,sort,
				status,click_cnt,reply_cnt from site_articles';	
		if(!empty($option['site_uid'])) {
			$where_arr[] = 'site_uid = '.$option['site_uid'];
		}
		if(!empty($option['cat_uid'])) {
			if(is_array($option['cat_uid'])) {
				$where_arr[] = 'cat_uid in '.Dba::makeIn($option['cat_uid']);
			} else {
				$where_arr[] = 'cat_uid = '.$option['cat_uid'];
			}
		}
		if(isset($option['status'])) {
			$where_arr[] = 'status = '.$option['status'];
		}
		//搜索
		if(!empty($option['key'])) {
			$where_arr[] = '(title like "%'.addslashes($option['key']).'%" or content like "%'.addslashes($option['key']).'%")';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		empty($option['sort']) && $option['sort'] = SORT_CREATE_TIME_DESC;
		switch($option['sort']) {
			case SORT_CLICK_COUNT_DESC:
				$sort = 'sort desc, click_cnt desc';
				break;	
			default:
				$sort = 'sort desc, create_time desc';
		}

		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SiteMod::func_get_article');
	}

	/*
		文章详情
	*/
	public static function get_site_article_by_uid($uid) {
		$sql = 'select * from site_articles where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'SiteMod::func_get_article');
	}

	
	/*
		根据标题获取文案内容；
	*/
	public static function get_article_by_title($title, $site_uid){
		$sql = 'select * from site_articles where site_uid = '.$site_uid.' && title like "%'.addslashes($title).'%"';
		return Dba::readRowAssoc($sql, 'SiteMod::func_get_article');
	}
	
	/*
		分类详情
	*/
	public static function get_site_cat_by_uid($uid) {
		$sql = 'select * from site_cats where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'SiteMod::func_get_cat');
	}

	/*
		幻灯片
		不需要分页
	*/
	public static function get_site_slides($option) {
		$sql = 'select * from site_slides';	
		if(!empty($option['site_uid'])) {
			$where_arr[] = 'site_uid = '.$option['site_uid'];
		}
		if(isset($option['status']) && ($option['status'] >= 0)) {
			$where_arr[] = 'status = '.$option['status'];
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .= ' order by sort desc, create_time';

		return Dba::readAllAssoc($sql);
	}

	/*
		幻灯片详情
	*/
	public static function get_site_slide_by_uid($uid) {
		$sql = 'select * from site_slides where uid = '.$uid;
		return Dba::readRowAssoc($sql);
	}

	public static function add_or_edit_cat($cat) {
		//如果设置父级目录必须为同一个site_uid
		if(!empty($cat['parent_uid'])) {
			$su = Dba::readOne('select site_uid from site_cats where uid = '.$cat['parent_uid']);
			if($su != $cat['site_uid']) {
				setLastError(ERROR_PERMISSION_DENIED);
				return false;
			}
		}

		if(!empty($cat['uid'])) {
			Dba::update('site_cats', $cat, 'uid = '.$cat['uid'].' and site_uid = '.$cat['site_uid']);
		}
		else {
			$cat['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('site_cats', $cat);
			$cat['uid'] = Dba::insertID();
		}

		return $cat['uid'];
	}

	/*
		删除分类
		返回删除的条数
	*/
	public static function delete_cat($cids, $site_uid) {
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'delete from site_cats where uid in ('.implode(',',$cids).') and site_uid = '.$site_uid;
		Dba::beginTransaction(); {
			$ret = Dba::write($sql);
			if($ret) {
				//更新父级分类, 文章分类
				$sql = 'update site_cats set parent_uid = 0 where parent_uid in ('.implode(',',$cids).') and site_uid = '.$site_uid;
				Dba::write($sql);
				$sql = 'update site_articles set cat_uid = 0 where cat_uid in ('.implode(',',$cids).') and site_uid = '.$site_uid;
				Dba::write($sql);
			}
		} Dba::commit();

		return $ret;
	}

	public static function add_or_edit_article($article) {
		//保证cat_uid存在
		if(!empty($article['cat_uid'])) {
			$su = Dba::readOne('select site_uid from site_cats where uid = '.$article['cat_uid']);
			if($su != $article['site_uid']) {
				setLastError(ERROR_PERMISSION_DENIED);
				return false;
			}
		}

		$article['modify_time'] = $_SERVER['REQUEST_TIME'];
		if(!empty($article['uid'])) {
			Dba::update('site_articles', $article, 'uid = '.$article['uid'].' and site_uid = '.$article['site_uid']);
		}
		else {
			if(empty($article['create_time'])) $article['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('site_articles', $article);
			$article['uid'] = Dba::insertID();
		}

		return $article['uid'];
	}

	/*
		删除文章
		返回删除的条数
	*/
	public static function delete_articles($aids, $site_uid) {
		if(!is_array($aids)) {
			$aids = array($aids);
		}
		$sql = 'delete from site_articles where uid in ('.implode(',',$aids).') and site_uid = '.$site_uid;
		$ret = Dba::write($sql);
		return $ret;
	}

	public static function add_or_edit_slide($slide) {
		if(!empty($slide['uid'])) {
			Dba::update('site_slides', $slide, 'uid = '.$slide['uid']);
		}
		else {
			$slide['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('site_slides', $slide);
			$slide['uid'] = Dba::insertID();
		}

		return $slide['uid'];
	}

	/*
		删除分类
		返回删除的条数
	*/
	public static function delete_slides($sids, $site_uid) {
		if(!is_array($sids)) {
			$sids = array($sids);
		}
		$sql = 'delete from site_slides where uid in ('.implode(',',$sids).') and site_uid = '.$site_uid;
		$ret = Dba::write($sql);

		return $ret;
	}

	/*
		网站设置
	*/
	public static function set($site) {
		Dba::update('site', $site, 'uid = '.$site['uid']);

		//如果是选择模板， 试着生成样例数据
		if(!empty($site['tpl']) || !empty($site['tpl_mobile'])) {
			if(!Dba::readOne('select count(*) from site_cats where site_uid = '.$site['uid'])) {
				SiteSampleMod::make_sample_site($site['uid']);	
			}	
		}

		return $site['uid'];
	}

	public static function get_site_message_by_uid ($uid) {
		return Dba::readRowAssoc('select * from site_messages where uid = '.$uid, 
														'SiteMod::func_get_message');
	}

	/*
		评论列表
	*/
	public static function get_site_messages($option) {
		$sql = 'select * from site_messages';	
				
		if(!empty($option['site_uid'])) {
			$where_arr[] = 'site_uid = '.$option['site_uid'];
		}
		if(!empty($option['su_uid'])) {
			$where_arr[] = 'su_uid = '.$option['su_uid'];
		}
		if(isset($option['status'])) {
			$where_arr[] = 'status = '.$option['status'];
		}
		//搜索
		if(!empty($option['key'])) {
			$where_arr[] = '(brief like "%'.$option['key'].'%")';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		$sql .= ' order by create_time desc';

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SiteMod::func_get_message');
	}

	/*
		微官网留言 
	*/
	public static function add_or_edit_message($m) {
		if(!empty($m['uid'])) {
			Dba::update('site_messages', $m, 'uid = '.$m['uid'].' and site_uid = '.$m['site_uid']);
		}
		else {
			$m['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('site_messages', $m);
			$m['uid'] = Dba::insertID();
		
			//微官网留言提醒
			$site = self::get_site();
			$sp_uid = $site['sp_uid'];
			$msg = array(
						'title'   => '微官网 用户留言提醒',
						'content' => '您的微官网收到了新的留言, 快去看看吧. <a href="?_a=site&_u=sp.messagelist">点击查看</a>',
						'sp_uid'  => $sp_uid, 
			);
			uct_use_app('sp');
			SpMsgMod::add_sp_msg($msg);
		}

		return $m['uid'];
	}

	/*
		删除评论
		返回删除的条数
	*/
	public static function delete_message($cids, $site_uid) {
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'delete from site_messages where uid in ('.implode(',',$cids).') and site_uid = '.$site_uid;
		$ret = Dba::write($sql);

		$sql = 'delete from site_messages_reply where msg_uid in ('.implode(',',$cids).')';
		Dba::write($sql);

		return $ret;
	}

	/*
		微官网留言 
	*/
	public static function add_or_edit_message_reply($m) {
		if(!empty($m['uid'])) {
			Dba::update('site_messages_reply', $m, 'uid = '.$m['uid']);
		}
		else {
			$m['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('site_messages_reply', $m);
			$m['uid'] = Dba::insertID();
		}

		return $m['uid'];
	}

	/*
		评论审核,支持批量
		返回影响的条数
	*/
	public static function review_message($cids, $status, $site_uid) {
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'update site_messages set status = '.$status.' where uid in ('.implode(',',$cids).') and site_uid = '.$site_uid;
		$ret = Dba::write($sql);

		return $ret;
	}

	/*
		获取模板列表

		从本地目录获取
	*/
	public static function get_tpls_list($option = array()) {
		$dir = UCT_PATH.'app'.DS.'site'.DS.'view'.DS;
		$ds = scandir($dir);
		$ds = array_diff($ds, array('.', '..'));
		$all = array();
		foreach($ds as $d) {
			if(!is_dir($dir.$d) || !file_exists($dir.$d.DS.'tplinfo.php')) {
				continue;
			}
			$p = include $dir.$d.DS.'tplinfo.php';
			$p['dir'] = $d;
			$all[] = $p;
		}
		//var_export($ds);
		//var_export($all);


		if(!empty($option['type']) && $all) {
			$all = array_filter($all, function($i) use($option) {
				return $i['type'] == $option['type'];	
			});	
		}
		if(!empty($option['industry']) && $all) {
			$all = array_filter($all, function($i) use($option) {
				return $i['industry'] == $option['industry'];	
			});	
		}
		if(!empty($option['key']) && $all) {
			$all = array_filter($all, function($i) use($option) {
				return stripos($i['name'], $option['key']) !== false;	
			});	
		}

		$cnt = count($all);
		if($option['limit'] >= 0) {
			$all = array_slice($all, $option['page']*$option['limit'], $option['limit']);
		}
		/*
		array_walk($all, function(&$i){
			$i['has_installed'] = WeixinPlugMod::is_plugin_installed($i);
		});
		*/
		return array('count' => $cnt, 'list' => $all);
	}

	/*
		根据目录名获取模板信息
	*/
	public static function get_tpl_by_dir($dir) {
		$fd = UCT_PATH.'app'.DS.'site'.DS.'view'.DS.$dir;
		if(!is_dir($fd) || !file_exists($fd.DS.'pluginfo.php')) {
			return false;
		}

		$p = include $fd.DS.'tplinfo.php';

		return $p;
	}


	/*
		获取视频相关详情信息
		取得所有的视频数据
	*/
	public static function get_video($option){
		$sql = 'select * from site_video';
		if(isset($option['status'])){
			$where_arr[] = 'status = '.$option['status'];
		}
		if(!empty($option['site_uid'])){
			$where_arr[] = 'site_uid ='.$option['site_uid'];
		}

		if(!empty($where_arr)){
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		empty($option['sort']) && $option['sort'] = SORT_CREATE_TIME_DESC;
		switch($option['sort']){
			case SORT_CLICK_COUNT_DESC:
				$sort = 'sort desc, click_cnt desc';
				break;
			default:
				$sort = 'sort desc, create_time desc';
		}
		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SiteMod::func_get_video');
	}
	
	/*
		删除视频
		返回删除的条数
	*/
	public static function delete_video($cids, $site_uid){
		if(!is_array($cids)){
			$cids = array($cids);
		}
		$sql = 'delete from site_video where uid in ('.implode(',', $cids).') and site_uid = '.$site_uid;
		$ret = Dba::write($sql);

		return $ret;
	}


	/*
		增加或者编辑视频
	*/
	public static function add_or_edit_video($video){
		if(!empty($video['uid'])){
			Dba::update('site_video' , $video, 'uid = '.$video['uid'].' and site_uid = '.$video['site_uid']);
		}
		else{
			 $video['create_time'] = $_SERVER['REQUEST_TIME'];
			 Dba::insert('site_video', $video);
			 $video['uid'] = Dba::insertID();
		}

		return $video['uid'];
	}

	/*
		根据uid来获取视频
	*/
	public static function get_site_video_by_uid($uid){
		$sql = 'select * from site_video where uid = '.$uid;
		return Dba::readRowAssoc($sql,'SiteMod::func_get_video');
	}

	public static function get_article_reply_list($option) {
		$sql = 'select * from site_article_reply';	
		if(!empty($option['site_uid'])) {
			$where_arr[] = 'site_uid = '.$option['site_uid'];
		}
		if(isset($option['article_uid']) && $option['article_uid'] >= 0) {
			$where_arr[] = 'article_uid = '.$option['article_uid'];
		}
		if(isset($option['status']) && $option['status'] >= 0) {
			$where_arr[] = 'status = '.$option['status'];
		}
		if(isset($option['available'])) {
			$where_arr[] = 'status < 2';
		}

		//搜索
		if(!empty($option['key'])) {
			$where_arr[] = '(brief like "%'.addslashes($option['key']).'%")';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		empty($option['sort']) && $option['sort'] = 0;
		switch($option['sort']) {
			case SORT_CREATE_TIME_DESC:
				$sort = 'sort desc, create_time desc';
				break;	
			default:
				$sort = 'create_time desc';
		}

		$sql .= ' order by '.$sort;

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SiteMod::func_get_article_reply');
	}

	/*
		文章留言详情
	*/
	public static function get_article_reply_by_uid($uid) {
		$sql = 'select * from site_article_reply where uid = '.$uid;
		return Dba::readRowAssoc($sql, 'SiteMod::func_get_article_reply');
	}

	public static function add_or_edit_article_reply($ar) {
		if(!empty($ar['uid'])) {
			Dba::update('site_article_reply', $ar, 'uid = '.$ar['uid'].' && site_uid = '.$ar['site_uid']);
		}
		else {
			Dba::beginTransaction(); {
			$ar['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('site_article_reply', $ar);
			$ar['uid'] = Dba::insertID();
			if(!empty($ar['article_uid'])) {
				Dba::write('update site_articles set reply_cnt = reply_cnt + 1 where uid = '.$ar['article_uid']);
			}
			} Dba::commit();
			
		}

		return $ar['uid'];
	}

	/*
		删除文章留言
		返回删除的条数
	*/
	public static function delete_article_reply($aids, $site_uid) {
		if(!is_array($aids)) {
			$aids = array($aids);
		}

		$cnt = 0;
		foreach($aids as $uid) {
			if($r = Dba::readRowAssoc('select uid, article_uid from site_article_reply where uid = '.
										$uid.' && site_uid = '.$site_uid)) {
				Dba::beginTransaction(); {
					Dba::write('delete from site_article_reply where uid = '.$uid);
					if($r['article_uid']) {
						Dba::write('update site_articles set reply_cnt = reply_cnt - 1 where uid = '.$r['article_uid']);
					}
					$cnt++;
				} Dba::commit();
			}
		}
		return $cnt;
	}

	/*
		评论审核,支持批量
		返回影响的条数
	*/
	public static function review_article_reply($cids, $status, $site_uid) {
		if(!is_array($cids)) {
			$cids = array($cids);
		}
		$sql = 'update site_article_reply set status = '.$status.' where uid in ('.implode(',',$cids).') and site_uid = '.$site_uid;
		$ret = Dba::write($sql);

		return $ret;
	}

	/*
		点赞
		session 内一篇文章只能点一次赞
	*/
	public static function do_like_article($a) {
		is_numeric($a) && $a = SiteMod::get_site_article_by_uid($a);
		if(!$a) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		$key = 'site_article_like_'.$a['uid'];
		if(!empty($_SESSION[$key])) {
			setLastError(ERROR_OUT_OF_LIMIT);
			return false;
		}
		$_SESSION[$key] = 1;

		return Dba::write('update site_articles set like_cnt = like_cnt + 1 where uid = '.$a['uid']);
	}

}


