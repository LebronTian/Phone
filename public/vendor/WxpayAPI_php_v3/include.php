<?php

/*
	include files
*/

define('WX_BASE_DIR', dirname(__FILE__).DIRECTORY_SEPARATOR);

include_once WX_BASE_DIR.'lib/WxPay.Exception.php';
include_once WX_BASE_DIR.'lib/WxPay.Config.php';
include_once WX_BASE_DIR.'lib/WxPay.Data.php';
include_once WX_BASE_DIR.'unit/log.php';
include_once WX_BASE_DIR.'lib/WxPay.Api.php';
include_once WX_BASE_DIR.'unit/WxPay.NativePay.php';
include_once WX_BASE_DIR.'unit/WxPay.JsApiPay.php';
include_once WX_BASE_DIR.'lib/WxPay.Notify.php';
//初始化log
Log::init(new CLogFileHandler());


