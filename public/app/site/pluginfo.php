<?php


return array(
	'name' => '微网站',
	'processor' => 'Site_WxPlugMod',
	'type' => 'industry',
	'enabled' => 2,
	'trigger_mode' => 10,
	'keywords' => '微官网',

	'author' => '官方',
	'version' => '1.0',
	'price' => 0,

	'spv3_menu' => array(
		array('name' => '文章分类', 'link' => 'site.sp.catlist'),
		array('name' => '文章列表', 'link' => 'site.sp.articlelist'),
	),

	'thumb' => '/app/sampleimg/200200/weiguanwang.png',
	'brief' => '微官网',
);
