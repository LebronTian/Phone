<?php
//support for weixin notify url
$_GET['_a'] = $_REQUEST['_a'] = 'pay';
$_GET['_u'] = $_REQUEST['_u'] = 'weixin.native1_notify';
include '../../index.php';
