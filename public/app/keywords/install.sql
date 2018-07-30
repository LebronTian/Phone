create table `keywords_reply` (
    `uid` int unsigned not null auto_increment comment '关键词规则uid',
	`public_uid` bigint unsigned not null default '0' comment '公众号id',

    `create_time` int unsigned default '0' comment '时间',
	`keyword` varchar(64) not null comment '关键词',
	`data` text not null comment '回复数据json {media_type:1, content:"hehe"}',

    primary key (`uid`),
	key `public_uid`(`public_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '关键词回复';

