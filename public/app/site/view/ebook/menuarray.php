<?php
uct_use_app('sp');
$sp_uid = AccountMod::get_current_service_provider('uid');
if(!$doc = SpMod::get_document_by_title('扉页', $sp_uid)) {
	$doc = array('sp_uid' => $sp_uid, 'title' => '扉页', 'content' => '');
	$doc['uid'] = SpMod::add_or_edit_document($doc);
}

return array(
	array('name' => '电子书设置', 'icon' => 'am-icon-book', 'menus' => array(
		array('name' => '文章评论', 'icon' => 'am-icon-comment-o', 'link' => '?_a=site&_u=sp.replylist', 'activeurl' => 'sp.replylist'),
		array('name' => '扉页设置', 'icon' => 'am-icon-book', 'link' => '?_a=sp&_u=index.adddocument&readonly=1&uid='.$doc['uid'], 'activeurl' => 'index.adddocument'),
	)),
);
