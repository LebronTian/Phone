<?php
/*
	微官网 示例数据
*/

class SiteSampleMod {
	protected static $sample_default = array(
		'site' => array(
			'logo' => '/app/site/static/images/icon.png',
			'brief' => '这里是公司介绍',
			'location' => '这里是公司地址',
			'phone' => '400-000-000',
		),

		'site_cats' => array(
			array('title' => '关于我们', 'image' => ''),	
			array('title' => '企业文化', 'parent' => '关于我们', 'image' => ''),	//parent 多级分类的写法 
			array('title' => '产品介绍', 'image' => ''),	
			array('title' => '最新动态', 'image' => ''),	
			array('title' => '人才招聘', 'image' => ''),	
			array('title' => '联系我们', 'image' => ''),	
		),

		'site_articles' => array(
			array('cat' => '关于我们', 'title' => '关于我们', 'content' => '我们的介绍'),	//cat 指定文章分类，可不填
			array('cat' => '产品介绍', 'title' => '产品1', 'content' => '产品1的介绍'),	
			array('cat' => '产品介绍', 'title' => '产品2', 'content' => '产品2的介绍'),	
			array('cat' => '最新动态', 'title' => '产品1发布', 'content' => '在大家的共同努力下我们的产品发布啦'),	
			array('cat' => '最新动态', 'title' => '公司网站上线', 'content' => '我们公司官网上线啦'),	
			array('cat' => '人才招聘', 'title' => '诚聘英才', 'content' => '我们在招聘人才请联系客服'),	
			array('cat' => '联系我们', 'title' => '联系我们', 'content' => '我们的地址在这里，欢迎前来交流'),	
		),

		'site_slides' => array(
			array('image' => ''),
			array('image' => ''),
			array('image' => ''),
		),
	);	
	
	/*
		使用示例数据 建立一个站点
	*/
	public static function make_site_from_sample_data($site_uid, $sample='') {
		if(!$sample) $sample = self::$sample_default;

		if(!empty($sample['site'])) {
			$old_site = Dba::readRowAssoc('select * from site where uid = '.$site_uid);
			$update = array();
			foreach($sample['site'] as $k => $v) {
				if(empty($old_site[$k])) {
					$update[$k] = $v;
				}
			}
			if($update) {
				Dba::update('site', $update, 'uid = '.$site_uid);
			}
		}

		$cats = array();
		if(!empty($sample['site_cats'])) {
			foreach($sample['site_cats'] as $c) {
				if(empty($c['title'])) continue;
				$c['site_uid'] = $site_uid;
				$c['create_time'] = $_SERVER['REQUEST_TIME'];
				if(isset($c['parent'])) {
					$c['parent_uid'] = isset($cats[$c['parent']]) ? $cats[$c['parent']] : 0;
					unset($c['parent']);
				}
				Dba::insert('site_cats', $c);
				$cats[$c['title']] = Dba::insertID();	
			}
		}

		if(!empty($sample['site_articles'])) {
			foreach($sample['site_articles'] as $a) {
				$a['site_uid'] = $site_uid;
				$a['create_time'] = $a['modify_time'] = $_SERVER['REQUEST_TIME'];
				if(isset($a['cat'])) {
					$a['cat_uid'] = isset($cats[$a['cat']]) ? $cats[$a['cat']] : 0;
					unset($a['cat']);
				}
				Dba::insert('site_articles', $a);
			}
		}
		
		if(!empty($sample['site_slides'])) {
			foreach($sample['site_slides'] as $s) {
				$s['site_uid'] = $site_uid;
				$s['create_time'] = $_SERVER['REQUEST_TIME'];
				Dba::insert('site_slides', $s);
			}
		}
		
		return true;
	}

	/*
		todo 从某个站点复制出一个新站点
	*/
	public static function make_site_from_exist_site($site_uid, $from_site_uid) {
	}

	
	/*
		根据选择的模板，行业 建立一个示例网站
	*/
	public static function make_sample_site($site_uid, $tpl = '', $industry = '消费品') {
		$sample = self::$sample_default;

		return self::make_site_from_sample_data($site_uid, $sample);
	}

	/*
		清空网站数据
	*/
	public static function clear_site_data($site_uid) {
		$sqls = array(
			'update site set tpl = "", tpl_mobile = "" where uid = '.$site_uid,
			'delete from site_cats where site_uid = '.$site_uid,
			'delete from site_articles where site_uid = '.$site_uid,
			'delete from site_slides where site_uid = '.$site_uid,
		);

		foreach($sqls as $s) {
			Dba::write($s);
		}

		return true;
	}

}


