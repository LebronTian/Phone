<?php
define('DS', '/'); //路径分隔符, 统一用/
//程序路径
define('UCT_PATH', __DIR__ . DS);

/*
//静态文件路径， css，js，img, flash等
define('STATIC_PATH', UCT_PATH . 'static'. DS);

//模板文件路径,语言文件路径，上传文件路径. 为了安全，这些文件不应该被直接访问
define('TPL_PATH',    UCT_PATH . 'safe/tpl'.   DS);
define('LANG_PATH',   UCT_PATH . 'safe/lang'.   DS);
define('UPLOAD_PATH', UCT_PATH . 'safe/upload'. DS);
*/
define('UPLOAD_PATH', realpath(UCT_PATH . '../upload') . DS);
define('CERT_PATH',   realpath(UCT_PATH . '../cert') . DS);

/*
	
*/
define('DB_USER', 'siring');//
define('DB_PASSWD', 'Siringdatabase_123');//
#define('DB_DSN', 'mysql:unix_socket=/tmp/mysql.sock;dbname=weixin_db');
#define('DB_DSN', 'mysql:dbname=weixin_db;host=10.10.1.105;port=3306');
define('DB_DSN', 'mysql:dbname=siring;host=rm-wz9l3z92630ora5wjwo.mysql.rds.aliyuncs.com;port=3306');

#define('REDIS_DSN', 'redis://user:passwd@10.10.1.105:6379/0?timeout=2.5&presisent=false');
#define('REDIS_DSN', 'redis://10.10.1.105:6379/0?timeout=2.5');
define('REDIS_DSN', 'redis://127.0.0.1:6379/0?timeout=2.5');

//true表示利用web服务器输出文件
define('USE_X_SEND_FILE', false);

//true表示启用万能验证码, 手机验证码等
define('DEBUG_CHECK_CODE', 1);

//true表示启用微信h5支付调试

define('DEBUG_WXPAY', 1);
//使用新版管理后台
define('USE_V3_TPL', 1);

//true表示启用记录错误位置信息并在ajax返回
define('DEBUG_ERROR_POS', true);

//短信宝账号密码
define('SMSBAO_ACCOUNT', 'gagaliang');
define('SMSBAO_PASSWORD', '123qwe');

//smtp ssl邮箱
define('SMTP_HOST', 'smtp.exmail.qq.com');
define('SMTP_PORT', 465);
define('SMTP_USERNAME', 'xxx.com');
define('SMTP_PASSWORD', 'xxx');

//第三方登陆平台
define('COMPONENT_TOKEN','HZiisxxxKTU9u9ba');
define('COMPONENT_APPID','wxa6dcb7uuuuuf8cd');
define('COMPONENT_APPSECRET','0c79c1fawwwwwcc0be99b20a18faeb');
define('COMPONENT_KEY','p9S3d5kb44oyvbbbbbbZiiVxsSjKTU9u9ba');

//微信文章url 自动转换
define('REPALCE_CONTEN_URL',false);


/*
	1. 微信网页授权登陆所需要的redirect_uri
	
	如果公众号是以手动方式绑定,则还要在微信官公众号方后台设置授权回调页面域名为weixin.uctphp.com
	如果是自动绑定,则不需要任何设置


	2. JS接口安全域名,
		目前用到的分享接口
		和微信jssdk支付 这些都应该在此域名下进行, 否则自动绑定的公众号会出错提示redirect_uri错误
	
	如果公众号是以手动方式绑定,则还要在微信官公众号方后台设置JS接口安全域名为uctphp.com
	如果是自动绑定, 则不需要任何设置
*/
define('WEIXIN_REDIRECT_URI', 'http://weixin.uctphp.com');

# 系统公众号原始id
define('SYS_WX_ORIGINID', 'gh_cd98f003ea7d');


/*
	本机所属顶级域名
	所有部署域名列表请参考 DomainMod::get_all_uct_top_domains
*/
define('CURRENT_TOP_DOMAIN', 'uctphp.com');

//默认应用
define('DEFAULT_APP', 'web'); //默认是前台
//define('DEFAULT_APP', 'sp'); //默认后台
//打开执行sql语句的日志
#define('LOG_DIR','log/');  //定义日志路径
#define('SQL_DEBUG', true);

include UCT_PATH.'framework/uct.php';
uct_run();

