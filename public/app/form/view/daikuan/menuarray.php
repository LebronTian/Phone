<?php

if(!$uid = requestInt('uid')) {
	$uid = requestInt('f_uid');
}

return array(
	array('name' => '活动报名模板设置', 'icon' => 'am-icon-gear', 'menus' => array(
		array('name' => '颜色设置', 'icon' => 'am-icon-pencil', 'link' => '?_a=form&_u=sp.setcolor'.'&uid='.$uid, 'activeurl' => 'sp.setcolor'),
	)),
);
