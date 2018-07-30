<?php
//support for alipay notify url
$_GET['_a'] = $_REQUEST['_a'] = 'pay';
$_GET['_u'] = $_REQUEST['_u'] = 'alipay.direct_notify';
include '../../index.php';
