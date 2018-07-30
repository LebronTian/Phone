<?php

function getImageineInstance() {
	if(extension_loaded('gd')) {
		include_once UCT_PATH.'vendor/images/gd.php';
		return new GdHelper();
	}
	else if(extension_loaded('Gmagick')){
		include_once UCT_PATH.'vendor/images/gmagick.php';
		return GmagickHelper();
	}
	else {
		//setLastError(ERROR_DBG_STEP_2);
		echo 'imagine环境错误!';exit();
	}

}


