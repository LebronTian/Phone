<?php
/*
	返回所有模板中可用变量 
	用于调试
*/

$all = get_defined_vars();
$exclude = array_flip(array('_GET', '_POST', '_REQUEST', '_SERVER', '_FILES', '_COOKIE',   
							'view','param', 'file',
						));
return array_diff_key($all, $exclude);

