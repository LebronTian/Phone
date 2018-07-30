create table domain_bind (
	`uid` int unsigned not null auto_increment comment 'id',
    `sp_uid` bigint unsigned comment '服务商uid',

	`domain` varchar(255) not null comment '完整域名',
	`bind`   varchar(255) not null default '' comment '绑定地址 site.index.index',
	`create_time` int unsigned not null default '0' comment '绑定时间',
	`temp` varchar(255) not null default '' comment '验证状态时临时存放bind',
	
    primary key (`uid`),
    unique key `domain`(`domain`)
)engine=innodb default charset=utf8 auto_increment=1 comment '商户域名绑定';

