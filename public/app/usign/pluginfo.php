<?php


return array(
	'name' => '每日签到',
	'processor' => 'Usign_WxPlugMod',
	'type' => 'activity',
	'enabled' => 2, //0禁用插件， 2 启用插件
	'keywords' => '签到', //关键词列表,逗号分开
	'trigger_mode' => 1, //触发方式, 0 从不加载，1 始终加载, 10 关键词加载, 11 正则表达式加载

	'hide' => false, //不在插件商城显示
	
	'author' => '官方',
	'version' => '1.0',
	'price' => 48800,

	'thumb' => '/app/sampleimg/200200/qiandao.png',
	'brief' => '简单好用的签到活动',
);
