create table `wx_code` (
    `uid` int unsigned not null auto_increment comment '场景值uid',
	`session_id` varchar(32) comment '页面session id',

    `short_code` varchar(32) comment '短验证码',
	`img_url` varchar(512) not null default '' comment '二维码地址',

    `expire_time` int unsigned not null default '0' comment '失效时间',

    `type` int unsigned not null default '0' comment '类型',
    `param` text not null default '' comment '额外参数',

    primary key (`uid`),
    unique key `session_id`(`session_id`)
)engine=innodb default charset=utf8 auto_increment=100001 comment '扫一扫关注获取验证码';

