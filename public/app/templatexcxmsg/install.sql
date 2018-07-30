create table `templatexcx_msg_record`(
	`uid` int unsigned not null auto_increment comment '模板消息发送记录uid',
	`sp_uid` int unsigned not null default '0' comment '商户uid',
	`public_uid` int unsigned not null default '0' comment '微信号public_uid',
	`create_time` int unsigned not null default '0' comment '时间',
	`template_id` varchar(225) not null default '' comment '模板id',
	`template_id_short` varchar(225) not null default '' comment '模板短id',
	`even` varchar(63) not null default '' comment '事件',
	`su_uid` varchar(64) not null default '' comment '用户uid',
	`url` varchar(255) not null default '' comment '模板消息详情页',
	`data` text not null default '' comment '模板消息数据data{}',
	`msg_id` int unsigned not null default '0' comment '消息数据id',
	`event_callback` text not null default '' comment '群发推送结果json',
	`status` tinyint not null default '0' comment '0 发送中， 1 失败[用户拒收] ,2 失败[非用户拒绝] ，3成功',
	primary key (`uid`),
	key `public_uid`(public_uid)
)engine=innodb default charset=utf8 auto_increment=1;

create table `templatexcx_library`(
	`uid` int unsigned not null auto_increment comment '模板库uid',
	`ts_id` varchar(225) not null default '' comment '模板短id',
	`title` varchar(64) not null default '' comment '标题',
	`industry` tinyint not null default '0' comment '行业',
	`details` text not null default '' comment '模板详情',
	`template_data` text not null default '' comment '模板详情数组',
	`check` tinyint(3) unsigned not null default '0' comment '验证',
	`last_check_time` int unsigned not null default '0' comment '最后验证时间',
	`create_time` int unsigned not null default '0' comment '生成时间',
	`use_cnt` int unsigned not null default '0' comment '使用商户数量',
	primary key(`uid`),
	key `ts_id`(`ts_id`)
)engine=innodb default charset=utf8 auto_increment=1;


create table `templatexcx_msg_set`
(
	`uid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '模板消息设置uid',
	`sp_uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户uid',
	`public_uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '微信号public_uid',
	`status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否启用 0 开启，1 关闭',
	`even` varchar(63) NOT NULL DEFAULT '' COMMENT '事件',
	`details` text NOT NULL COMMENT '模板详情',
	`template_id` varchar(225) NOT NULL DEFAULT '' COMMENT '模板id',
	`template_data` text NOT NULL COMMENT '模板配置数据 json',
	`create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '生成时间',
	`page` varchar(255) NOT NULL DEFAULT '' COMMENT '模板消息跳转链接',
	`su_uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户uid，不为空是发给指定用户',
	primary key (`uid`),
	key `public_uid`(public_uid),
	key `sp_uid`(sp_uid)
)engine=innodb default charset=utf8 auto_increment=1;
