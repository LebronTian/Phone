create table `vip_card_sp_set`(
	`uid` int unsigned not null auto_increment comment '会员卡设置uid',
	`sp_uid` int unsigned not null default '0' comment '商户uid',
	`public_uid` int unsigned not null default '0' comment '公众号uid',
	`create_time` int unsigned not null default '0' comment '创建时间',
	`status` tinyint(3) not null default '0' comment '状态 默认1 开启 0 关闭',
	`rank_rule` text not null default '' comment '登记规则 json{"rank"}',
	`rank_name` text not null default '' comment '登记名称 json{"1":{"rank_name":"普通会员","rank_discount":"100"},"2":{"rank_name":"白银会员","rank_discount":"90"},"3":{"rank_name":"黄金会员","rank_discount":"80"}}',
	`ui_set` text not null default '' comment '界面设置 json{"background_url":"","logo_url":"","QR_code_url":""}',
	`connent` text not null default '' comment '内容{"name"{"need":"1","vaule":""},...}',
	`tpl` varchar(32) not null default '' comment '界面模板',
	`vip_card_tpl_uid` int unsigned not null default '0' comment '会员卡模板',
	`need_check` tinyint(3) not null default '0' comment '是否需要审核 默认0 不需要 1 需要',
	`title` varchar(64) not null default '' comment '会员卡名称',
	primary key(`uid`),
	key `sp_uid`(`sp_uid`,`public_uid`)
)engine=innodb default charset=utf8 auto_increment =1 comment '会员卡设置';


create table `vip_card_su`(
	`uid` int unsigned not null auto_increment comment '会员卡uid',
	`su_uid` int unsigned not null default '0' comment '用户uid',
	`status` tinyint(3) not null default '0' comment '状态 默认0 通过审核 1 未审核 2 审核失败',
	`create_time` int unsigned not null default '0' comment '创建时间',
	`other_info` text not null default '' comment '其他字段信息 json{"nickname":"小昌昌"}',
	`card_url` varchar(255) not null default '' comment 'vip_card链接',
	primary key(`uid`),
	key `su_uid`(`su_uid`)
)engine = innodb default charset=utf8 auto_increment= 1 comment '会员卡信息';


create table `vip_card_tpl`(
	`uid` int unsigned not null auto_increment comment '会员卡模板uid',
	`sp_uid` int unsigned not null default '0' comment '商户uid 0 为公有',
	`original_uid` int unsigned not null default '0' comment '原模板uid',
	`data` text not null default ''  comment '会员卡原始模板 json',
	`create_time` int unsigned not null default '0' comment '创建时间',
	`status` tinyint(3) not null default '0' comment '状态 默认0 禁用 1 启用',
	`tpl_img` varchar(255) not null default '' comment '模板示例图片地址',
	`brief` text not null default '' comment '模板简介',
	primary key(`uid`),
    key `sp_uid`(`sp_uid`)
)engine = innodb default charset=utf8 auto_increment= 1 comment '会员卡模板';