<?php


return array(
	'name' => '会员卡',
	'processor' => 'Vipcard_WxPlugMod',
	'type' => 'activity',
	'enabled' => 2, //0禁用插件， 2 启用插件
	'keywords' => '会员卡', //关键词列表,逗号分开
	'trigger_mode' => 1, //触发方式, 0 从不加载，1 始终加载, 10 关键词加载, 11 正则表达式加载

	'hide' => false, //不在插件商城显示
	
	'author' => '官方',
	'version' => '1.0',
	'price' => 0,

	'thumb' => '/app/vipcard/static/images/icon.png',
	'brief' => ' 会员卡',
);
