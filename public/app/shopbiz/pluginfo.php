<?php


return array(
	'name' => '商家入驻',
	'processor' => '',
	'type' => 'industry',
	'enabled' => 0, //0禁用插件， 2 启用插件
	'keywords' => '', //关键词列表,逗号分开
	'trigger_mode' => 0, //触发方式, 0 从不加载，1 始终加载, 10 关键词加载, 11 正则表达式加载

	'hide' => 1, //不在插件商城显示
	
	'author' => '官方',
	'version' => '1.0',
	'price' => 48800,

	'thumb' => '/app/sampleimg/200200/pintuan.png',
	'brief' => '商家入驻',
	
	'spv3_menu' => array(
		array('name' => '全部商家', 'link' => 'shopbiz.sp.bizlist'),
		array('name' => '行业分类', 'link' => 'shopbiz.sp.bizcatlist'),
		array('name' => '基本设置', 'link' => 'shopbiz.sp.biz_set'),
		array('name' => '入驻协议', 'link' => 'shopbiz.sp.biz_know'),
	),

	'sku_table' => array(
		'info' => array('期限:6个月' => array('price' => 48800), 
						'期限:1年' => array('price' => 68800), 
		),
		'table' => array('期限' => array('6个月', '1年')),
	),

);
