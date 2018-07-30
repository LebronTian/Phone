<?php


return array(
	'name' => '分销',
	'processor' => '',
	'type' => 'industry',
	'enabled' => 0, //0禁用插件， 2 启用插件
	'keywords' => '', //关键词列表,逗号分开
	'trigger_mode' => 0, //触发方式, 0 从不加载，1 始终加载, 10 关键词加载, 11 正则表达式加载

	'hide' => 1, //不在插件商城显示
	
	'author' => '官方',
	'version' => '1.0',
	'price' => 48800,

	'thumb' => '/app/sampleimg/200200/fenxiao.png',
	'brief' => '让客户来推广产品，赚佣金',
	'brief_short' => '让客户来推广产品，赚佣金',
	'sku_table' => array(
		'info' => array('期限:6个月' => array('price' => 48800), 
						'期限:1年' => array('price' => 68800), 
		),
		'table' => array('期限' => array('6个月', '1年')),
	),

	'spv3_menu' => array(
		array('name' => '分销设置', 'link' => 'shopdist.sp.distribution'),
		array('name' => '分销商品 ', 'link' => 'shopdist.sp.distribution_productlist'),
		array('name' => '分销记录', 'link' => 'shopdist.sp.orderlist'),
		array('name' => '分销团队', 'link' => 'shopdist.sp.distribution_user_list'),
		array('name' => '分销协议', 'link' => 'shopdist.sp.user_agreement'),
	),
);
