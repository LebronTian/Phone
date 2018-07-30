CREATE TABLE `shop_bargain` (
  `uid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'uid',
  `sp_uid` bigint(20) NOT NULL DEFAULT '0' COMMENT '商户uid',
  `title` varchar(32) NOT NULL DEFAULT '' COMMENT '标题',
  `product_info` text NOT NULL COMMENT '商品其他信息',
  `all_quantity` int(10) NOT NULL COMMENT '总份数',
  `quantity` int(10) NOT NULL COMMENT '剩余份数',
  `ori_price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '原价格',
  `lowest_price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最低价格',
  `rule` text NOT NULL COMMENT 'json其他信息',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 启用， 1 关闭',
  `join_cnt` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '支持数量',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `info` text NOT NULL COMMENT '其他信息',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='砍价信息表';

CREATE TABLE `shop_bargain_help` (
  `uid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'uid',
  `su_uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户uid',
  `bu_uid` varchar(32) NOT NULL DEFAULT '' COMMENT '砍价uid',
  `bargain_fee` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '帮砍价格',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`uid`),
  KEY `su_uid` (`su_uid`),
  KEY `bargain_uid` (`bu_uid`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='帮砍表';

CREATE TABLE `shop_bargain_user` (
  `uid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'uid',
  `sp_uid` bigint(20) NOT NULL DEFAULT '0' COMMENT '商户uid',
  `bargain_uid` bigint(20) NOT NULL DEFAULT '0' COMMENT '砍价商品uid',
  `su_uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '顾客uid',
  `title` varchar(32) NOT NULL DEFAULT '' COMMENT '标题',
  `current_price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '当前价格',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 启用， 1 关闭',
  `support_cnt` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '支持数量',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `info` text NOT NULL COMMENT '其他信息',
  PRIMARY KEY (`uid`),
  KEY `su_uid` (`su_uid`),
  KEY `bargain_uid` (`bargain_uid`) 
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='用户砍价表';

CREATE TABLE `shop_bargain_order` (
  `b_uid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '砍价数据uid',
  `paid_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `paid_fee` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最终支付的总价, 单位为分',
  `pay_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0 未设置,  10 支付宝, 11 微信支付',
  `pay_info` varchar(512) NOT NULL DEFAULT '' COMMENT '根据pay_type有不同的数据',
  PRIMARY KEY (`b_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='砍价支付信息';



