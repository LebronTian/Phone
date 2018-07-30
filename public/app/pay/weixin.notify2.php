<?php
//support for weixin notify url
$_GET['_a'] = $_REQUEST['_a'] = 'pay';
$_GET['_u'] = $_REQUEST['_u'] = 'weixin.native2_notify';
include '../../index.php';
