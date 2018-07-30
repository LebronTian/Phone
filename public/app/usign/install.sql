create table `usign_set`(
	`uid` int unsigned not null auto_increment comment '签到设置uid',
	`sp_uid` int unsigned not null default '0' comment '商户uid',
	`create_time` int unsigned not null default '0' comment '创建时间',
	`status` tinyint(3) not null default '0' comment '状态 默认开启 0, 1 关闭',
	`rule_data` text not null default '' comment '签到规则 json{}',
	`tpl` varchar(32) not null default '' comment '前端模板',
	primary key(`uid`),
	key `sp_uid`(`sp_uid`)
)engine=innodb default charset=utf8 auto_increment =1 comment '签到设置';

create table `usign_record`(
	`uid` int unsigned not null auto_increment comment '签到记录uid',
	`su_uid` int unsigned not null default '0' comment '用户uid',
	`create_time` int unsigned not null default '0' comment '签到时间',
	`info_data` text not null default '' comment '其他信息',
	primary key(`uid`),
	key `uid`(`su_uid`)
)engine=innodb default charset=utf8 auto_increment =1 comment '签到记录';
