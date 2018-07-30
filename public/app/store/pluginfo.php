<?php


return array(
	'name' => '门店管理',
	'processor' => 'Store_WxPlugMod',
	'type' => 'activity',
	'enabled' => 2, //0禁用插件， 2 启用插件
	'keywords' => '', //关键词列表,逗号分开
	'trigger_mode' => 1, //触发方式, 0 从不加载，1 始终加载, 10 关键词加载, 11 正则表达式加载

	'hide' => false, //不在插件商城显示
	
	'author' => '官方',
	'version' => '1.0',
	'price' => 48800,

	'thumb' => '/app/sampleimg/200200/mendian.png',
	'brief' => '门店功能，是公众平台向商户提供的对其线下实体门店数据的基础管理能力. 整合了线下卡券功能',
	'spv3_menu' => array(
		array('name' => '门店列表', 'link' => 'store.sp.storelist'),
	),


	'sku_table' => array(
		'info' => array('期限:6个月' => array('price' => 48800), 
						'期限:1年' => array('price' => 68800), 
		),
		'table' => array('期限' => array('6个月', '1年')),
	),

);
