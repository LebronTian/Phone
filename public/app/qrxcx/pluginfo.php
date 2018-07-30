<?php


return array(
	'name' => '推广海报',
	'processor' => '',
	'type' => 'tool',
	'enabled' => 2, //0禁用插件， 2 启用插件
	'keywords' => '小程序,二维码', //关键词列表,逗号分开
	'trigger_mode' => 1, //触发方式, 0 从不加载，1 始终加载, 10 关键词加载, 11 正则表达式加载

	'hide' => 0, //不在插件商城显示
	
	'author' => '官方',
	'version' => '1.0',
	'price' => 0,

	'thumb' => '/app/sampleimg/200200/erweima.png',
	'brief' => '生成小程序二维码',

	'spv3_menu' => array(
		array('name' => '小程序码', 'link' => 'qrxcx.sp.index'),
		array('name' => '海报码', 'link' => 'qrxcx.sp.photolist'),
	),

	'sku_table' => array(
		'info' => array('期限:6个月' => array('price' => 48800), 
						'期限:1年' => array('price' => 68800), 
		),
		'table' => array('期限' => array('6个月', '1年')),
	),
);
