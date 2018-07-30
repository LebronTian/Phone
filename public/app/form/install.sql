create table `form` (
  `uid` int unsigned not null auto_increment comment '表单uid',
	`sp_uid` bigint unsigned not null default '0' comment '对应的服务商id',

  `create_time` int unsigned not null default '0' comment '创建时间',

	`status` tinyint not null default '0' comment '0 启用， 1 关闭',
	`tpl` varchar(32) not null default '' comment '模板',

	`click_cnt` int unsigned not null default '0' comment '点击数',
	`record_cnt` int unsigned not null default '0' comment '提交数',

	`title` varchar(32) not null default '' comment '标题',
	`brief` text not null default '' comment '介绍',
	`img` varchar(255) not null default '' comment '封面图片',
	`access_rule` text not null default '' comment '{"must_login":false,"can_edit":false,"start_time":0,"end_time":0,
														"total_cnt":0,"max_cnt":0,"max_cnt_day":0,"unique_field":"","order":{"price":1}}',
	`data` text not null default '' comment '表单内容[{name:name, type:text, default:test, unique:false, notnull: false}]',
  `type` varchar(32) NOT NULL default '' COMMENT '表单类型',
  `su_uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '发起人/表单提交者',
  `admin_uids` text NOT NULL default '' COMMENT '管理员uid数组',

    primary key (`uid`),
    key `sp_uid`(`sp_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `form_record` (
    `uid` int unsigned not null auto_increment comment '表单数据uid',
	`f_uid` bigint unsigned not null default '0' comment '表单id',

    `create_time` int unsigned not null default '0' comment '提交时间',
	`su_uid` bigint unsigned not null default '0' comment '用户uid',
    `user_ip` varchar(16) not null default '0.0.0.0' comment '用户ip地址',
	
	`sp_remark` tinyint unsigned not null default '0' comment '商户标记',

	`data` text not null default '' comment '表单结果',
	`unique_field` varchar(32)  comment '表单里可以设置一个唯一字段',


    primary key (`uid`),
    key `f_uid`(`f_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `form_record_order` (
  `r_uid` int unsigned not null auto_increment comment '表单数据uid',

	`paid_time` int unsigned not null default '0' comment '支付时间',

	`paid_fee` int unsigned not null default '0' comment '最终支付的总价, 单位为分',
	`pay_type` tinyint unsigned not null default '0' comment '0 未设置,  10 支付宝, 11 微信支付',
	`pay_info` varchar(512) not null default '' comment '根据pay_type有不同的数据',

    primary key (`r_uid`)
)engine=innodb default charset=utf8 comment '表单支付信息';

CREATE TABLE `form_reply` (
  `uid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '表单提问uid',
  `p_uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '回复提问uid',
  `sp_uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户标记',
  `f_uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '表单id',
  `su_uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户uid',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '提问/回复时间',
  `content` text NOT NULL COMMENT '回复内容',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 审核中， 1 审核成功 ， 2 审核失败',
  PRIMARY KEY (`uid`),
  KEY `f_uid` (`f_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='表单提问回复';


