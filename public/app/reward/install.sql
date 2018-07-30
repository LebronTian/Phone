create table `reward` (
    `uid` int unsigned not null auto_increment comment '抽奖uid',
	`sp_uid` bigint unsigned not null default '0' comment '对应的服务商id',

    `create_time` int unsigned not null default '0' comment '创建时间',

	`status` tinyint not null default '0' comment '0 启用， 1 关闭',
	`tpl` varchar(32) not null default '' comment '模板',

	`click_cnt` int unsigned not null default '0' comment '点击数',
	`record_cnt` int unsigned not null default '0' comment '抽奖数',
	`win_cnt` int unsigned not null default '0' comment '中奖数',

	`title` varchar(32) not null default '' comment '标题',
	`brief` text not null default '' comment '介绍',
	`img` varchar(255) not null default '' comment '封面图片',
	`access_rule` text not null default '' comment '{must_login:true, start_time:0, end_time:0, 
													max_item:1, max_cnt:1, max_cnt_day:1}',
	`win_rule` text not null default '' comment '{type:form,data:[姓名,手机,地址,邮箱]}',

    primary key (`uid`),
    key `sp_uid`(`sp_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `reward_item` (
    `uid` int unsigned not null auto_increment comment '奖品选项uid',
	`r_uid` int unsigned not null default '0' comment '抽奖id',

	`title` varchar(32) not null default '' comment '标题',
	`brief` text not null default '' comment '介绍',
	`img` varchar(255) not null default '' comment '封面图片',
	
	`total_cnt` int unsigned not null default '0' comment '奖品份数, 0不中奖',
	`weight` smallint unsigned not null default '0' comment '中奖概率 0 ~ 10000',

	`win_cnt` int unsigned not null default '0' comment '已中奖数',
	`sort` int unsigned not null default '0' comment '排序从大到小',

	`virtual_info` text not null default '' comment '虚拟奖品直接发放{name: 优惠券, ... 其他字段根据类型而不同}',

    primary key (`uid`),
    key `r_uid`(`r_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `reward_record` (
    `uid` int unsigned not null auto_increment comment '抽奖数据uid',
	`r_uid` bigint unsigned not null default '0' comment '抽奖id',

    `create_time` int unsigned not null default '0' comment '提交时间',
	`su_uid` bigint unsigned not null default '0' comment '用户uid',
    `user_ip` varchar(16) not null default '0.0.0.0' comment '用户ip地址',
	
	`sp_remark` tinyint unsigned not null default '0' comment '商户标记',

	`item_uid` int not null default 0 comment '抽奖结果, 0 未中奖',
	`data` text not null default '' comment '领奖信息, 如[姓名,手机,地址,邮箱]',

    primary key (`uid`),
    key `rs`(`r_uid`, `su_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `reward_rule_user` (
    `uid` int unsigned not null auto_increment comment '抽奖数据uid',
	`r_uid` bigint unsigned not null default '0' comment '抽奖id',

	`su_uid` bigint  comment '用户uid',
    `user_ip` varchar(16)  comment '用户ip地址',
	`access_rule` text not null default '' comment '{max_item:1, max_cnt:1, max_cnt_day:1}',
													
    primary key (`uid`),
    unique key `rs`(`r_uid`, `su_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '某个用户规则, 用于转发就加一次抽奖等';

