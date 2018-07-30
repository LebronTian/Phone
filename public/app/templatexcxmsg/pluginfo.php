<?php


return array(
	'name' => '模板推送',
	'processor' => 'Templatexcx_Msg_WxPlugMod',
	'type' => 'basic',
	'enabled' => 2,
	'keywords' => '',
	'trigger_mode' => 1,

	'author' => '官方',
	'version' => '1.0',
	'price' => 0,

	'hide' => false, //不在插件商城显示

	'thumb' => '/app/templatexcxmsg/static/images/icon.png',
	'brief' => '小程序模板消息统一编辑与设置',

	'spv3_menu' => array(
		//array('name' => '介绍', 'link' => 'templatexcxmsg.sp.index'),
		array('name' => '推送消息', 'link' => 'templatexcxmsg.sp.push'),
	),

);
