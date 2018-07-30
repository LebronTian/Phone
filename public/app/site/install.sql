create table `site` (
	`uid` bigint unsigned not null auto_increment comment '网站uid',
	`sp_uid` bigint unsigned not null default '0' comment '对应的服务商id',

	`status` tinyint unsigned not null default '0' comment '0 正常, 1 已下线',
	`title` varchar(64) not null default '' comment '网站标题',
	`logo` varchar(255) not null default '' comment '网站logo',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`tpl` varchar(32) not null default '' comment '模板',
	`tpl_mobile` varchar(32) not null default '' comment '手机模板',
	`language` varchar(8) not null default 'zh_cn' comment '默认语言zh_cn, en',

	`seo_words` varchar(255) not null default '' comment 'seo关键词',
	`stat_code` varchar(512) not null default '' comment '统计代码',
	
	`qr_code` varchar(255) not null default '' comment '二维码地址',
	`qq_code` varchar(512) not null default '' comment 'qq客服代码',
	`phone` varchar(16) not null default '' comment '电话号码',
	`location` varchar(255) not null default '' comment '公司地址',
	`brief` text not null default '' comment '公司介绍',
	`more_info` text not null default '' comment '更多信息json{latitude:111.2,longitude:80.2}',

	primary key (`uid`),
	unique key (`sp_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `site_cats` (
	`uid` bigint unsigned not null auto_increment comment '分类id',
	`site_uid` bigint unsigned not null default '0' comment '网站uid',
	`parent_uid` bigint unsigned not null default '0' comment '父分类uid',

	`title` varchar(64) not null default '' comment '分类名称',
	`title_en` varchar(128) not null default '' comment '分类名称英文',
	`image` varchar(255) not null default '' comment '图片',

	`image_icon` varchar(255) not null default '' comment '图片2',
	`brief` text not null default '' comment '分类文字',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`sort` int unsigned not null default '0' comment '排序,从大到小',
	`status` tinyint unsigned not null default '0' comment '0 正常, 1 隐藏',

	primary key (`uid`),
	key `site_uid`(`site_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `site_articles` (
	`uid` bigint unsigned not null auto_increment comment '文章id',
	`site_uid` bigint unsigned not null default '0' comment '网站uid',
	`cat_uid` bigint unsigned not null default '0' comment '分类uid',

	`title` varchar(64) not null default '' comment '文章标题',
	`content` text not null default '' comment '正文',
	`image` varchar(255) not null default '' comment '文章主图',
	`image_icon` varchar(255) not null default '' comment '文章小图',
	`seo_words` varchar(255) not null default '' comment 'seo关键词',

	`author` varchar(64) not null default '' comment '作者',
	`digest` varchar(255) not null default '' comment '摘要',
	`origin_link` varchar(255) not null default '' comment '原文链接',
	`like_cnt` int unsigned not null default '0' comment '点赞数',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`modify_time` int unsigned not null default '0' comment '编辑时间',
	`sort` int unsigned not null default '0' comment '排序,从大到小',
	`status` tinyint unsigned not null default '0' comment '0 正常, 1 隐藏',

	`click_cnt` int unsigned not null default '0' comment '阅读数',
	`reply_cnt` int unsigned not null default '0' comment '回复数',

	primary key (`uid`),
	key `site_uid`(`site_uid`, `cat_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `site_article_reply` (
	`uid` bigint unsigned not null auto_increment comment '留言id',
	`site_uid` bigint unsigned not null default '0' comment '网站uid',
	`article_uid` bigint unsigned not null default '0' comment '文章uid， 0表示网站留言',

	`su_uid` bigint unsigned not null default '0' comment '用户uid',
	`brief` text not null default '' comment '留言',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`status` tinyint unsigned not null default '0' comment '0 未审核, 1 已通过， 2 未通过',
	`sort` int unsigned not null default '0' comment '排序,从大到小',

	primary key (`uid`),
	key `site_uid`(`site_uid`, `article_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `site_slides` (
	`uid` bigint unsigned not null auto_increment comment '幻灯片id',
	`site_uid` bigint unsigned not null default '0' comment '网站uid',

	`image` varchar(255) not null default '' comment '幻灯片图片',
	`title` varchar(64) not null default '' comment '图片说明',
	`link` varchar(255) not null default '' comment '链接地址',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`sort` int unsigned not null default '0' comment '排序,从大到小',
	`status` tinyint unsigned not null default '0' comment '0 正常, 1 隐藏',

	primary key (`uid`),
	key `site_uid`(`site_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `site_kefu` (
	`uid` bigint unsigned not null auto_increment comment '客服id',
	`site_uid` bigint unsigned not null default '0' comment '网站uid',
	`type` varchar(32) not null default '' comment '分类名称',

	`title` varchar(64) not null default '' comment '客服服务名称',
	`tags` varchar(512) not null default '' comment '标签',
	`phone` varchar(16) not null default '' comment '电话',
	`brief` text not null default '' comment '介绍',
	`image` varchar(255) not null default '' comment '图片',

	`serve_point` varchar(32) not null default '' comment '服务评分',
	`serve_count` varchar(32) not null default '' comment '服务人数',
	`serve_level` varchar(32) not null default '' comment '服务级别',

	`msg_cnt` int not null default '0' comment '留言人数',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`sort` int unsigned not null default '0' comment '排序,从大到小',
	`status` tinyint unsigned not null default '0' comment '0 正常, 1 隐藏',

	primary key (`uid`),
	key `site_uid`(`site_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '客服/服务/门店';

create table `site_kefu_msg` (
    `uid` int unsigned not null auto_increment comment '客服留言uid',
	`site_uid` bigint unsigned not null default '0' comment '网站uid',
	`kf_uid` bigint unsigned not null default '0' comment '客服uid',
	`sp_remark` tinyint unsigned not null default '0' comment '商户标记',

	`su_uid` bigint unsigned not null default '0' comment '用户uid',
	`contact` varchar(64) not null default '' comment '联系方式, 手机或邮箱',
	`brief` text not null default '' comment '简单需求',
	`time` int unsigned not null default '0' comment '预约时间',

	`create_time` int unsigned not null default '0' comment '创建时间',

	primary key (`uid`),
	key `site_uid`(`site_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `site_messages` (
	`uid` bigint unsigned not null auto_increment comment '留言id',
	`site_uid` bigint unsigned not null default '0' comment '网站uid',

	`su_uid` bigint unsigned not null default '0' comment '用户uid',
	`name` varchar(32) not null default '' comment '名称',
	`contact` varchar(64) not null default '' comment '联系方式, 手机或邮箱',
	`brief` text not null default '' comment '留言',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`status` tinyint unsigned not null default '0' comment '0 正常, 1 隐藏',

	primary key (`uid`),
	key `site_uid`(`site_uid`)
)engine=innodb default charset=utf8 auto_increment=1;

create table `site_messages_reply` (
	`uid` bigint unsigned not null auto_increment comment '回复id',
	`msg_uid` bigint unsigned not null default '0' comment '留言uid',

	`su_uid` bigint unsigned not null default '0' comment '用户uid, 0 表示系统回复',
	`name` varchar(32) not null default '' comment '用户或管理员名称',
	`brief` text not null default '' comment '留言回复',

	`create_time` int unsigned not null default '0' comment '创建时间',

	primary key (`uid`),
	key `msg_uid`(`msg_uid`)
)engine=innodb default charset=utf8 auto_increment=1;



create table `site_video` (
	`uid` bigint unsigned not null auto_increment comment '视频地址id',
	`site_uid` bigint unsigned not null default '0' comment '网站uid',

	`address` varchar(100) not null default '' comment '视频地址',
	`describle` text not null default '' comment '视频描述',
	`image` varchar(255) not null default '' comment '视频的封面图片',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`sort` int unsigned not null default '0' comment '排序,从大到小',
	`status` tinyint unsigned not null default '0' comment '0 正常, 1隐藏',

	primary key (`uid`),
	key `site_uid`(`site_uid`)
)engine=innodb default charset=utf8 auto_increment=1;
