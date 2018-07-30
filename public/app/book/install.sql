create table `book_cfg` (
	`sp_uid` bigint unsigned not null default '0' comment '对应的服务商id',

	`status` tinyint unsigned not null default '0' comment '0 正常, 1 已下线',
	`title` varchar(64) not null default '' comment '预约服务商名称',
	`logo` varchar(255) not null default '' comment '预约服务商logo',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`tpl` varchar(32) not null default '' comment '模板',

	`cfg` text not null default '' comment '配置json',

	primary key (`sp_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `book_item` (
	`uid` bigint unsigned not null auto_increment comment '预约项目uid',
	`sp_uid` bigint unsigned not null default '0' comment '对应的服务商id',
	`store_uid` bigint unsigned not null default '0' comment '对应门店id',

	`status` tinyint unsigned not null default '0' comment '0 正常, 1 隐藏',

	`title` varchar(64) not null default '' comment '项目名称',
	`type` varchar(64) not null default '' comment '分类名称',
	`main_img` varchar(255) not null default '' comment '项目图片',

	`images` text not null default '' comment '更多图片,分号分开多张图片',
	`brief` text not null default '' comment '项目介绍',

	`price` int unsigned not null default '0' comment '价格',
	`book_cnt` int unsigned not null default '0' comment '已预约次数',
	`comment_cnt` int unsigned not null default '0' comment '已评价次数',

	`rule` text not null default '' comment '{data:[姓名，手机, 备注]} 预约规则',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`sort` tinyint unsigned not null default '0' comment '从大到小排序',

	primary key (`uid`),
	key (`sp_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '预约项目';

create table `book_item_extra_info` (
	`uid` bigint unsigned not null auto_increment comment 'id',
	`sp_uid` bigint unsigned not null default '0' comment '商户uid',
	`b_uid` bigint unsigned not null default '0' comment '项目uid',
	`sort` int unsigned not null default '0' comment '排序,从大到小',

    `ukey` varchar(32) not null comment '键',
    `data` varchar(512) not null  comment '值',

	primary key (`uid`),
	key `sp_uid`(`sp_uid`, `b_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '预约更多信息表';

create table `book_record` (
    `uid` int unsigned not null auto_increment comment '预约uid',
	`b_uid` bigint unsigned not null default '0' comment '项目id',

	`su_uid` bigint unsigned not null default '0' comment '用户uid',
    `user_ip` varchar(16) not null default '0.0.0.0' comment '用户ip地址',

	`sp_remark` tinyint unsigned not null default '0' comment '商户标记',

    `create_time` int unsigned not null default '0' comment '提交时间',
	`data` text not null default '' comment '提交内容',

    primary key (`uid`),
    key `b_uid`(`b_uid`),
    key `su_uid`(`su_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '预约记录';

create table `book_record_order` (
	`r_uid` int unsigned not null auto_increment comment '预约记录uid',

	`paid_time` int unsigned not null default '0' comment '支付时间',

	`paid_fee` int unsigned not null default '0' comment '最终支付的总价, 单位为分',
	`pay_type` tinyint unsigned not null default '0' comment '0 未设置,  10 支付宝, 11 微信支付',
	`pay_info` varchar(512) not null default '' comment '根据pay_type有不同的数据',

    primary key (`r_uid`)
)engine=innodb default charset=utf8 comment '预约支付信息';

