<?php


return array(
	'name' => '自定义回复',
	'processor' => 'Keywords_WxPlugMod',
	'type' => 'basic',
	'enabled' => 2, //0禁用插件， 2 启用插件
	'keywords' => '', //关键词列表,逗号分开
	'trigger_mode' => 1, //触发方式, 0 从不加载，1 始终加载, 10 关键词加载, 11 正则表达式加载

	'author' => '官方',
	'version' => '1.0',
	'price' => 0,

	'thumb' => '/app/keywords/static/images/icon.png',
	'brief' => '自定义关键词回复',
);
