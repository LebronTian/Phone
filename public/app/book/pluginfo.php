<?php


return array(
	'name' => '门店预约',
	'processor' => 'Book_WxPlugMod',
	'type' => 'industry',
	'enabled' => 2, //0禁用插件， 2 启用插件
	'keywords' => '', //关键词列表,逗号分开
	'trigger_mode' => 1, //触发方式, 0 从不加载，1 始终加载, 10 关键词加载, 11 正则表达式加载

	'hide' => 0, //不在插件商城显示
	
	'author' => '官方',
	'version' => '1.0',
	'price' => 48800,

	'thumb' => '/app/sampleimg/200200/mendian.png',
	'brief' => '门店预约预订系统, 使用前请先安装 <a target="_blank" href="?_a=store&_u=sp">门店管理</a> 插件',
	'spv3_menu' => array(
		array('name' => '项目列表', 'link' => 'book.sp.itemlist'),
		array('name' => '预约记录', 'link' => 'book.sp.recordlist'),
	),

	'sku_table' => array(
		'info' => array('期限:6个月' => array('price' => 48800), 
						'期限:1年' => array('price' => 68800), 
		),
		'table' => array('期限' => array('6个月', '1年')),
	),

);
