CREATE TABLE `xcxposter` (
  `uid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '小程序码海报uid',
  `sp_uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '对应的服务商id',
  `public_uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '小程序公众号uid',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `photo_info` text NOT NULL COMMENT '背景图片及二维码位置信息json {img_url: , qrcode:{x: ,y: , w: , h: ,}}',
  `reward_info` text NOT NULL COMMENT '奖励设置json {}',
  `notice_info` text NOT NULL COMMENT '通知设置json {}',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0 隐藏, 1 使用中',
  PRIMARY KEY (`uid`),
  KEY `sp_uid` (`sp_uid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

