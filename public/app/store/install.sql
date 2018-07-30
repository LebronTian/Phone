create table `store` (
	`uid` bigint unsigned not null auto_increment comment '门店uid',
	`sp_uid` bigint unsigned not null default '0' comment '对应的服务商id',

	`status` tinyint unsigned not null default '0' comment '0 正常, 1 隐藏',
	`name` varchar(64) not null default '' comment '门店名称',
	`main_img` varchar(255) not null default '' comment '门店图片',
	`images` text not null default '' comment '门店更多图片,分号分开多张图片',

	`store_code` varchar(64) not null default '' comment '门店商户编码',

	`brief` text not null default '' comment '介绍',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`sort` tinyint unsigned not null default '0' comment '从大到小排序',

	`province` varchar(16) not null default '' comment '省',
	`city` varchar(16) not null default '' comment '市',
	`town` varchar(16) not null default '' comment '县',
	`address` varchar(64) not null default '' comment '详细地址',

	`lat` float(9,6) not null default '0' comment '地理位置 维度',
	`lng` float(9,6) not null default '0' comment '地理位置 经度',
	`geohash` varchar(16) not null default '' comment '经纬度hash',

	`telephone` varchar(16) not null default '' comment '门店电话号码',

	primary key (`uid`),
	key (`sp_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `store_coupon` (
	`uid` int unsigned not null auto_increment comment '优惠券id',
	`sp_uid` bigint unsigned not null default '0' comment '商户uid',

	`store_uids` text not null default '' comment '允许使用的门店id,分号分开多个门店',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`duration` int unsigned not null default '0' comment '有效期, 单位为秒, 0表示长期有效',
	`publish_cnt` int unsigned not null default '0' comment '总发放数量, 0表示不发放',
	`used_cnt` int unsigned not null default '0' comment '已发放数量',

	`title` varchar(32) not null default '' comment '优惠券名称',
	`img` varchar(255) not null default '' comment '优惠券图片',
	`brief` varchar(256) not null default '' comment '优惠券说明',
	`valuation` tinyint unsigned not null default '0' comment '类型, 0 现金券, 1 折扣券, 2 礼品劵, 3 团购券',
	`rule` text not null default '' comment '计费json {discount: 1000, max_cnt: 1, max_cnt_day: 1}',

	primary key (`uid`),
	key `su`(`sp_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '门店优惠券(线下)';

create table `store_user_coupon` (
	`uid` int unsigned not null auto_increment comment '用户优惠券id',
	`sp_uid` bigint unsigned not null default '0' comment '商户uid',
	`user_id` bigint unsigned not null default '0' comment '用户id',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`expire_time` int unsigned not null default '0' comment '到期时间,0表示永不过期',

	`used_time` int unsigned not null default '0' comment '核销时间',
	`store_uid` bigint unsigned not null default '0' comment '核销的门店id',

	`coupon_uid` bigint unsigned not null default '0' comment '优惠券id',
	`info` text not null default '' comment '计费json {title: 10元, img: xxx, valuation: 0, store_uids: {}, rule{discount: 1000}}',

	primary key (`uid`),
	key `su`(`sp_uid`, `user_id`)
)engine=innodb default charset=utf8 auto_increment=1 comment '用户优惠券';

create table `store_writeoffer` (
	`uid` bigint unsigned not null auto_increment comment '核销员id',
	`sp_uid` bigint unsigned not null default '0' comment '商户uid',
	`su_uid` bigint not null comment '用户uid',

	`store_uids` text not null default '' comment '允许核销的门店id,分号分开多个门店',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`status` tinyint unsigned not null default '0' comment '0 待审核, 1 审核成功,  2 审核失败',

	primary key (`uid`),
	unique key `su_uid`(`sp_uid`, `su_uid`)
)engine=innodb default charset=utf8 comment '优惠券核销员';



