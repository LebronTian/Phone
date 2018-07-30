create table `arraydb_pay` (
    `ukey` varchar(32) not null comment '键',
    `data` text not null  comment '值',
    `expire_time` int unsigned default '0' comment '到期时间, 0不过期',

    unique key `ukey`(`ukey`)

)engine=innodb default charset=utf8;

create table `uctpay` (
	`sp_uid` bigint not null comment '商户uid',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`disabled` tinyint unsigned not null default '0' comment '0 启用, 1 禁用',

	`wxpay` tinyint unsigned not null default '0' comment '1 启用微信支付, 0 禁用',
	`alipay` tinyint unsigned not null default '0' comment '1 启用支付宝, 0 禁用',

	`cash_remain` int unsigned not null default '0' comment '账户余额, 可提现余额',
	`cash_transfered` int unsigned not null default '0' comment '已提现总数',

    `passwd` varchar(32) not null default '' comment '提现密码',
	`transfer_info` text not null default '' comment '提现方式',

	primary key (`sp_uid`)
)engine=innodb default charset=utf8;

create table `uctpay_cash_record` (
	`uid` bigint unsigned not null auto_increment comment '记录id',
	`sp_uid` bigint unsigned not null default '0' comment '商户uid',

	`create_time` int unsigned not null default '0' comment '创建时间',
	
	`type` tinyint unsigned not null default '1' comment '类型, 1 提现减余额, 2 收入加余额',
	`cash` int unsigned not null default '0' comment '交易金额',
	`cash_remain` int unsigned not null default '0' comment '交易后的账户余额',
	`info` varchar(255) not null default '' comment '交易备注',

	primary key (`uid`),
	key `sp_uid`(`sp_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment 'uct代收款收支详情记录';

create table `sp_user_withdraw` (
	`sp_uid` bigint not null comment '商户uid',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`enabled` tinyint unsigned not null default '0' comment '1 启用, 0 禁用, 默认禁用用户提现',

	`wd_type` tinyint not null default '1' comment '提现方式, 1  微信红包， 2 微信企业付款',
	`withdraw_rule` text not null default '' comment '提现规则{min_price: 最低额度, max_price: 单笔最高限额, max_price_day: 每日限额}',

	`cash_withdrawed` int unsigned not null default '0' comment '已提现总额',

	primary key (`sp_uid`)
)engine=innodb default charset=utf8;

create table `sp_user_withdraw_record` (
	`uid` bigint unsigned not null auto_increment comment '记录id',
	`sp_uid` bigint unsigned not null default '0' comment '商户uid',
	`su_uid` bigint unsigned not null default '0' comment '用户uid',

	`create_time` int unsigned not null default '0' comment '创建时间',
	
	`status` int unsigned not null default '0' comment '提现状态0 准备中， 1 提现成功， 2 提现失败',
	`wd_type` tinyint unsigned not null default '1' comment '支付方式, 1 微信红包, 2 微信企业支付',
	`wd_info` varchar(512) not null default '' comment '提现信息',

	`cash` int unsigned not null default '0' comment '提现金额,单位为分',
	`info` varchar(255) not null default '' comment '提现备注',

	primary key (`uid`),
	key `sp_uid`(`sp_uid`, `su_uid`)
)engine=innodb default charset=utf8 auto_increment=10000 comment '用户提现记录';

