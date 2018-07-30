create table `groups_all` (
    `uid` int unsigned not null auto_increment comment '分组uid',
	`sp_uid` bigint unsigned not null default '0' comment '服务商id',

	`name` varchar(64) not null comment '分组名称',
	`user_cnt` int not null default '0' comment '成员数目',
    `group_type` tinyint not null default '2' comment '分组类型, 1 黑名单, 2 游客分组, 3 普通分组, 4 星标分组, 5 管理员分组',

	`create_time` int unsigned not null default '0' comment '创建时间',

    primary key (`uid`),
    key `sp_uid`(`sp_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '分组';

create table `groups_users` (
    `uid` int unsigned not null auto_increment comment '分组关系uid',
	`g_uid` bigint unsigned not null default '0' comment '分组id',
	`su_uid` bigint unsigned not null default '0' comment '用户id',

	`create_time` int unsigned not null default '0' comment '创建时间',

    primary key (`uid`),
    key `g_uid`(`g_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '用户所在分组';

create table `oauth_su_mobile` (
    `uid` int unsigned not null auto_increment comment '分组关系uid',
	`mobile` varchar(16) not null comment '手机号码',
	
	`sp_uid` bigint unsigned not null default '0' comment '所属的服务商id',
	`su_uid` bigint unsigned  comment '用户id,可以为空',

	`create_time` int unsigned not null default '0' comment '绑定时间',
	`from_name` varchar(32) not null default '' comment '来源',
	`from_url` varchar(255) not null default '' comment '来源',
	`sp_remark` tinyint unsigned not null default '0' comment '商户标记',

	primary key (`uid`),
	unique key `sm`(`sp_uid`, `mobile`),
	unique key `su_uid`(`su_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '绑定手机号码';

create table `user_location` (
    `uid` int unsigned not null auto_increment comment '记录uid',
	`sp_uid` bigint unsigned not null default '0' comment '所属的服务商id',
	`su_uid` bigint unsigned  comment '用户id',

	`create_time` int unsigned not null default '0' comment '上报时间',

	`lat` float(9,6) not null default '0' comment '地理位置 维度',
	`lng` float(9,6) not null default '0' comment '地理位置 经度',
	`geohash` varchar(16) not null default '' comment '经纬度hash',

	primary key (`uid`),
	unique key `su_uid`(`su_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '用户上报地理位置';

create table `user_points` (
	`su_uid` bigint unsigned not null comment '用户uid',

	`status` tinyint not null default '0' comment '0 会员卡未审核， 1 审核成功， 2 审核失败',
	`create_time` int unsigned not null default '0' comment '创建时间',

	`cash_remain` int unsigned not null default '0' comment '账户余额, 可使用余额',
	`cash_transfered` int unsigned not null default '0' comment '已提现总数',

	`point_max` int unsigned not null default '0' comment '积分最大值, 可用于计算等级',
	`point_remain` int unsigned not null default '0' comment '积分余额, 可用于消费',
	`point_transfered` int unsigned not null default '0' comment '已消费总数',
	
    primary key (`su_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '用户积分账号会员卡';

create table `user_point_record` (
	`uid` bigint unsigned not null auto_increment comment '记录id',
	`su_uid` bigint unsigned not null comment '用户uid',

	`create_time` int unsigned not null default '0' comment '创建时间',
	
	`type` tinyint unsigned not null default '1' comment '类型, 1 积分消费, 2 积分增加',
	`point` int unsigned not null default '0' comment '交易积分',
	`point_remain` int unsigned not null default '0' comment '交易后的积分余额',
	`info` varchar(255) not null default '' comment '交易备注',

	primary key (`uid`),
	key `su_uid`(`su_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '用户积分明细';


create table `user_cash_record` (
	`uid` bigint unsigned not null auto_increment comment '记录id',
	`su_uid` bigint unsigned not null comment '用户uid',

	`create_time` int unsigned not null default '0' comment '创建时间',
	
	`type` tinyint unsigned not null default '1' comment '类型, 1 提现或消费减余额, 2 收入增加余额',
	`cash` int unsigned not null default '0' comment '交易金额',
	`cash_remain` int unsigned not null default '0' comment '交易后的账户余额',
	`info` varchar(255) not null default '' comment '交易备注',

	primary key (`uid`),
	key `su_uid`(`su_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '用户账号收支明细';

create table `user_msg` (
    `uid` int unsigned not null auto_increment comment '消息uid',
    `su_uid` bigint unsigned not null comment '用户uid',
    `from_uid` bigint unsigned not null default '0' comment '来源, 0 系统消息',

    `create_time` int unsigned not null default '0' comment '收到时间',
    `read_time` int unsigned not null default '0' comment '阅读时间',
	
	`title` varchar(32) not null default '' comment '标题',
	`content` text not null default '' comment '正文',

    primary key (`uid`),
    key `su_uid` (`su_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '用户通知消息';

create table `user_charge_order` (
  `uid` int unsigned not null auto_increment comment 'id',
  `sp_uid` bigint unsigned comment '服务商uid',
  `su_uid` bigint unsigned comment '用户uid',

  `create_time` int unsigned not null default '0' comment '下单时间',
  `paid_time` int unsigned not null default '0' comment '支付时间',
  `paid_fee` int unsigned not null default '0' comment '最终支付的总价, 单位为分',

  `status` tinyint unsigned not null default '1' comment '1 待付款, 3 已完成 10 已取消',
  `pay_type` tinyint unsigned not null default '0' comment '0 未设置, 10 支付宝, 11 微信支付',
  `pay_info` varchar(512) not null default '' comment '根据pay_type有不同的数据',

  `charge_uid` int unsigned not null default '0' comment '充值uid,保留为0',
  `charge` text not null default '' comment '充值详细信息{uid:0, paid_price:100, 
                           					charge_price:100, quantity:1}',

  primary key (`uid`),
  key `sp_uid`(`sp_uid`, `su_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '用户余额充值订单';


create table `oauth_weixin_fans` (
	`uid` bigint unsigned not null auto_increment comment 'uid',

	`sp_uid` bigint unsigned not null default '0' comment '服务商id',
	`su_uid` bigint unsigned  comment '对应的用户id',

	`public_uid` bigint not null comment '公众号uid, 注意这个公众号通常不是sp_uid的而是系统即快马加鞭',
	`open_id` varchar(128) not null comment '粉丝openid， 此public_uid对应的open_id',

	`last_time` int unsigned not null default '0' comment '最后授权时间, 0表示未确定的绑定',

	primary key (`uid`),
	unique key `spo` (`sp_uid`,`public_uid`,`open_id`)
)engine=innodb default charset=utf8 auto_increment=1;


create table `wechat_groups_all` (
    `uid` int unsigned not null auto_increment comment '分组uid',
	`sp_uid` bigint unsigned not null default '0' comment '服务商id',

	`name` varchar(64) not null comment '微信群名称',
	`wx_group_id` varchar(128) not null comment '微信群group id',
	`user_cnt` int not null default '0' comment '成员数目',
    `group_type` tinyint not null default '2' comment '分组类型, 1 黑名单, 2 游客分组, 3 普通分组, 4 星标分组, 5 管理员分组',

	`create_time` int unsigned not null default '0' comment '创建时间',

    primary key (`uid`),
    key `sp_uid`(`sp_uid`, `wx_group_id`)
)engine=innodb default charset=utf8 auto_increment=1 comment '微信群';

create table `wechat_groups_users` (
    `uid` int unsigned not null auto_increment comment '分组关系uid',
	`g_uid` bigint unsigned not null default '0' comment '分组id',
	`su_uid` bigint unsigned not null default '0' comment '用户id',

	`create_time` int unsigned not null default '0' comment '创建时间',

    primary key (`uid`),
    key `g_uid`(`g_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '微信群成员';

CREATE TABLE `cash_rule` (
  `uid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	`sp_uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '对应的服务商id',
  `rule` text NOT NULL DEFAULT '' COMMENT '规则json{[充值金额,赠送金额]}',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1 启用，0 禁用',
  `cgroup` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否改变分组,1 是，0 否',
  PRIMARY KEY (`uid`),
  KEY `sp_uid` (`sp_uid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='充值优惠规则';

CREATE TABLE `form_id_xiaochengxu` (
  `uid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '本系统小程序粉丝uid，不同小程序唯一',
  `su_uid` bigint(20) unsigned DEFAULT NULL COMMENT '对应的用户id',
  `public_uid` bigint(20) NOT NULL COMMENT '小程序本系统公众号uid',
  `form_id` text NOT NULL COMMENT 'form_id/prepay_id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`uid`),
  KEY `su_uid` (`su_uid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='小程序form_id';





