create table `sub_sp` (
    `uid` bigint unsigned not null auto_increment comment '子账号uid',
    `sp_uid` bigint unsigned not null comment '服务商uid',
	`account` varchar(32) comment '登陆账号',
	`passwd` varchar(32) comment '登陆密码md5',

	`name` varchar(64) not null comment '角色名称',
	`avatar` varchar(255) not null default '' comment '头像',
	`g_uid` int unsigned not null default '0' comment '分组id',
	`uct_tokens` text not null default '' comment '允许管理的公众号uid, 逗号分开多个uid, 空表示允许全部',
    `uct_token` varchar(64) not null default '' comment '当前的公众号token',

	`status` tinyint not null default '0' comment '0 未审核， 1 审核成功， 2 审核失败，20 被封号, > 60 账号异常被锁定',

    `create_time` int unsigned not null default '0' comment '创建时间',
    `last_time` int unsigned not null default '0' comment '最近登陆时间',
    `last_ip` varchar(16) not null default '0.0.0.0' comment '最近登陆ip',

    primary key (`uid`),
	key `sp_uid` (`sp_uid`),
	unique key `account` (`account`)
)engine=innodb default charset=utf8 auto_increment=1 comment '服务商子账号';

create table `sub_sp_group` (
    `uid` int unsigned not null auto_increment comment '分组uid',
	`sp_uid` bigint unsigned not null default '0' comment '服务商id',

	`name` varchar(64) not null comment '分组名称',
	`user_cnt` int not null default '0' comment '成员数目',

	`create_time` int unsigned not null default '0' comment '创建时间',

    primary key (`uid`),
    key `sp_uid`(`sp_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '服务商子账号分组';
