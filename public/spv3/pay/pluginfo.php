<?php


return array(
	'name' => '支付插件',
	'processor' => '',
	'type' => 'advance',
	'enabled' => 2, //0禁用插件， 2 启用插件
	'keywords' => '', //关键词列表,逗号分开
	'trigger_mode' => 0, //触发方式, 0 从不加载，1 始终加载, 10 关键词加载, 11 正则表达式加载

	'author' => '官方',
	'version' => '1.0',
	'price' => 0,

	'thumb' => '/app/pay/static/images/icon.png',
	'brief' => '让您的站点获取收款功能,支持微信支付,支付宝等多种支付方式',
);
