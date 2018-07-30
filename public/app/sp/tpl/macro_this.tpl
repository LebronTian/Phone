<?php

/*
	模板中获取ctl控制器的this对象
*/
	
if(isset($this)) { //在ctl中
	return $this;
}
if(isset($_this)) { //easy模式下，注意只能访问public成员
	return $_this;
}

echo 'fatal error! no $this in current scope! ';
if(defined('DEBUG_ERROR_POS') && DEBUG_ERROR_POS) {
	$info = debug_backtrace();
	echo substr($info[0]['file'], strlen(UCT_PATH)).' +'.$info[0]['line'];
}

exit(1);
