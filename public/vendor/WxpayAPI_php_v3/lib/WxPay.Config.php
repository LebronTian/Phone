<?php
/**
* 	配置账号信息
*/

define('DFT_WX_SSL_CERT_PATH', WX_BASE_DIR .'cert/apiclient_cert.pem');
define('DFT_WX_SSL_KEY_PATH', WX_BASE_DIR .'cert/apiclient_key.pem');

class WxPayConfig
{
	protected static $cfg = array(
			'APPID'     => 'mosaicmosaic',
			'MCHID'     => '1111111111',
			'KEY'       => 'mosaicmosaic',
			'APPSECRET' => 'mosaicmosaic',

			'NOTIFY_URL' => '',
			'SSLCERT_PATH' => DFT_WX_SSL_CERT_PATH,
			'SSLKEY_PATH'  => DFT_WX_SSL_KEY_PATH,
			'REPORT_LEVENL' => 1,
			'CURL_PROXY_HOST' => '0.0.0.0',
			'CURL_PROXY_PORT' => 0,
	);

	public static function getConfig($field = '') {
		return $field ? self::$cfg[$field] : self::$cfg;
	}

	public static function setConfig($c) {
		self::$cfg = array_merge(self::$cfg, $c);
	}

	//=======【基本信息设置】=====================================
	//
	/**
	 * 
	 * 微信公众号信息配置
	 * APPID：绑定支付的APPID（必须配置）
	 * MCHID：商户号（必须配置）
	 * KEY：商户支付密钥，参考开户邮件设置（必须配置）
	 * APPSECRET：公众帐号secert（仅JSAPI支付的时候需要配置）
	 * @var string
	 */
	
	//=======【证书路径设置】=====================================
	/**
	 * 
	 * 证书路径,注意应该填写绝对路径（仅退款、撤销订单时需要）
	 * @var path
	 */
	
	//=======【curl代理设置】===================================
	/**
	 * 
	 * 本例程通过curl使用HTTP POST方法，此处可修改代理服务器，
	 * 默认0.0.0.0和0，此时不开启代理（如有需要才设置）
	 * @var unknown_type
	 */
	
	//=======【上报信息配置】===================================
	/**
	 * 
	 * 上报等级，0.关闭上报; 1.仅错误出错上报; 2.全量上报
	 * @var int
	 */
	const REPORT_LEVENL = 1;
}
