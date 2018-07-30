<?php

class ApiCtl {
	public function cancel_job()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if (!($uid = requestInt('uids')) ||
			!($job = JobMod::get_a_job_by_uid($uid)) ||
			!($job['sp_uid'] == $sp_uid)
		)
		{
			outError('ERROR_INVALID_REQUEST_PARAM');

		}
		outRight(JobMod::cancel_job($job));
	}

	public function delete_job()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');

		if (!($i_uid = requestIntArray('uids'))
		)
		{
			outError('ERROR_INVALID_REQUEST_PARAM');

		}
		outRight(JobMod::delete_a_job($i_uid, $sp_uid));
	}
}
