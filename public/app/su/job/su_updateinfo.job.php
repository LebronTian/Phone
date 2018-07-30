<?php
/*
	刷新用户个人资料
*/

class Su_updateinfoJob {
	public function perform($su_uid, $force = 1) {
		$ret = SuMod::update_su_by_weixin_info($su_uid, $force);
		if(!$ret && $force > 1) {
			//如果还是失败的话，再试几次
			return Queue::do_job_at(5, 'su_updateinfoJob', array($su_uid, --$force));	
		}

		return $ret;
	}
}

