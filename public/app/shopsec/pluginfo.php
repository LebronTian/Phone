<?php


return array(
	'name' => '秒杀',
	'processor' => '',
	'type' => 'industry',
	'enabled' => 0, //0禁用插件， 2 启用插件
	'keywords' => '', //关键词列表,逗号分开
	'trigger_mode' => 0, //触发方式, 0 从不加载，1 始终加载, 10 关键词加载, 11 正则表达式加载

	'hide' => 1, //不在插件商城显示
	
	'author' => '官方',
	'version' => '1.0',
	'price' => 488,

	'thumb' => '/app/sampleimg/200200/miaosha.png',
	'brief' => '引导客户快速成交',

	'sku_table' => array(
		'info' => array('期限:6个月' => array('price' => 48800), 
						'期限:1年' => array('price' => 68800), 
		),
		'table' => array('期限' => array('6个月', '1年')),
	),
);
