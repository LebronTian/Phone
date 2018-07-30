<?php


return array(
	'name' => '微信验证码',
	'processor' => 'Wxcode_WxPlugMod',
	'type' => 'advance',
	'enabled' => 2, //0禁用插件， 2 启用插件
	'keywords' => '验证码', //关键词列表,逗号分开
	'trigger_mode' => 1, //触发方式, 0 从不加载，1 始终加载, 10 关键词加载, 11 正则表达式加载

	'hide' => false, //不在插件商城显示
	
	'author' => '官方',
	'version' => '1.0',
	'price' => 0,

	'thumb' => '/app/wxcode/static/images/icon.png',
	'brief' => '微信验证码, 扫一扫获取微信验证码, 关注公众号后可以收到',
);
