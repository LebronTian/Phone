<div class="am-padding">
<?php

if(!empty($_REQUEST['_d'])) {
	echo '<button id="id_test" class="am-btn am-btn-primary am-btn-large" type="button" >添加测试麦当劳抽奖</button>';
}

?>
</div>



<?php
	$extra_js = array(
		$static_path.'/js/addreward.js',
	);
?>
