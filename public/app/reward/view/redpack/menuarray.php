<?php

if(!$uid = requestInt('uid')) {
	$uid = requestInt('f_uid');
}

return array(
	array('name' => '预付分享模板', 'icon' => 'am-icon-gear', 'menus' => array(
		array('name' => '提交记录', 'icon' => 'am-icon-pencil', 'link' => '?_a=form&_u=sp.arecordlist'.'&f_uid='.$uid, 'activeurl' => 'sp.arecordlist'),
	)),
);
