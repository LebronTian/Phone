<?php
if((!($f_uid = requestInt('f_uid')) && !($f_uid = requestInt('uid'))) ||
	!($form = FormMod::get_form_by_uid($f_uid)) || ($form['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
		//试着取默认商户表单
		if(!($form = FormMod::get_default_form_by_sp_uid(AccountMod::get_current_service_provider('uid')))) {
			echo '参数错误!';
			exit();
		}
}

$option['f_uid'] = $f_uid;
$option['sp_remark'] = requestInt('sp_remark', -1);
$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
$option['page'] = requestInt('page');
$option['limit'] = requestInt('limit', -1);
$records = FormMod::get_form_record_list($option);
if(!$records['list']) {
	echo '暂无数据！';
	return;
}

$header = array('姓名', '提交时间', '手机',  '推荐人',  '付款时间', );
$data = array();
uct_use_app('su');
foreach($records['list'] as $c) {
	if(($su_uid = checkInt(@$c['data'][2])) && ($p = SuMod::get_su_profile($su_uid))) {
		$from_su = $p['realname'].'/'.$p['phone'];
	}
	else {
		$from_su = '-';
	}
	$paid_time = !empty($c['order']['paid_time']) ? date('Y-m-d H:i:s', $c['order']['paid_time']) : '-';
	$item = array(
		@$c['data'][0],
		date('Y-m-d H:i:s', $c['create_time']),
		@$c['data'][1],
		$from_su,
		$paid_time,
	);
	$data[] = $item;
}

$option = array('header' => $header, 'download' => true, 'title' => '活动数据');
require_once UCT_PATH.'vendor/phpExcel/export.php';
export_to_excel($data, $option);	
exit();

