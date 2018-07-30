create table `job` (
	`uid` int unsigned not null auto_increment comment '任务uid',
	`sp_uid` bigint unsigned not null default '0' comment '商户id',
	`public_uid` bigint unsigned not null default '0' comment '公众号id',

	`create_time` int unsigned not null default '0' comment '创建时间',
	`end_time` int unsigned not null default '0' comment '完成时间',

	`status` tinyint not null default '0' comment '状态 1、等待运行 2、完成 3、取消 4、失败',

	`dir` varchar(64) not null default ''  comment '插件',
	`name` varchar(64) not null default '' comment '任务名称',
	`job_id` varchar(64) not null default '' comment '任务id',
	`job_parent_id` varchar(64) not null default '' comment '任务父id',

	`job_queue` varchar(32) not null default '' comment '任务类型 定时任务：defered 其他：dir',
	`job_args` text not null default '' comment '任务参数',
	`job_callback` text not null default '' comment '任务回调',

	primary key (`uid`),
	key `public_uid`(`public_uid`)
)engine=innodb default charset=utf8 auto_increment=1 comment '任务管理';

