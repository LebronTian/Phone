<?php
class AjaxCtl {
	//获取所有海报
	public function posterlist() {
		$option['sp_uid'] = AccountMod::require_sp_uid();
		$option['key']       = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']      = requestInt('page');
		$option['limit']     = requestInt('limit', 10);

		//只要 使用中的 
		$option['status'] = 1;

		outRight(XcxposterMod::get_xcxposter_list($option));
	}

	public function posterlist2() {
		$ret = array(
			array('photo_info' => array('img_url' => 'http://weixin.uctphp.com/?_a=upload&_u=index.out&uidm=372198027')),
			array('photo_info' => array('img_url' => 'http://weixin.uctphp.com/?_a=upload&_u=index.out&uidm=37220b607')),
		);
		
		outRight($ret);
	}
}

