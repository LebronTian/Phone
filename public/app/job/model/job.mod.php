<?php


class JobMod {
	const STATUS_WAITING  = 1;
	const STATUS_RUNNING  = 2;
	const STATUS_FAILED   = 3;
	const STATUS_COMPLETE = 4;
	const STATUS_CANCEL   = 5;

	public static function add_or_edit_job($job)
	{
		if (!empty($job['uid']))
		{
			Dba::update('job', $job, 'uid = ' . $job['uid']);
		}
		else
		{
			$job['create_time'] = time();
			Dba::insert('job', $job);
			$job['uid'] = Dba::insertID();
		}

		return $job['uid'];
	}

	public static function cancel_job($job)
	{
		uct_use_app('admin');
		ResqueMonitMod::del_jobs(array($job['job_id']), $job['job_queue']);
		$job['status'] = JobMod::STATUS_CANCEL;
		unset($job['public']);

		return Dba::update('job', $job, ' uid =' . $job['uid']);

	}

	public static function get_a_job_by_uid($uid)
	{
		return Dba::readRowAssoc('select * from job where uid = ' . $uid, 'JobMod::func_get_job');
	}

	public static function delete_a_job($i_uid, $sp_uid)
	{
		if (!is_array($i_uid))
		{
			$i_uid = array(
				$i_uid,
			);
		}

		return Dba::write('delete from job where uid in (' . implode(',', $i_uid) . ') && sp_uid = ' . $sp_uid);
	}

	public static function get_job_list($option)
	{
		$sql = 'select * from job ';
		if (!empty($option['uid']))
		{
			$where_arr[] = ' uid = ' . $option['uid'];
		}
		if (!empty($option['sp_uid']))
		{
			$where_arr[] = ' sp_uid = ' . $option['sp_uid'];
		}
		if (!empty($option['public_uid']))
		{
			$where_arr[] = ' public_uid = ' . $option['public_uid'];
		}
		if (!empty($option['status']))
		{
			$where_arr[] = ' status = ' . $option['status'];
		}
		if (!empty($option['dir']))
		{
			$where_arr[] = ' dir = "' . $option['dir'] . '"';
		}
		if (!empty($where_arr))
		{
			$sql .= ' where ' . implode(' and ', $where_arr);
		}
		$sql .= ' order by uid desc';
		if (empty($option['page']))
		{
			$option['page'] = 0;
		}
		if (empty($option['limit']))
		{
			$option['limit'] = -1;
		}

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'JobMod::func_get_job');
	}

	public static function func_get_job($item)
	{
		if (!empty($item['job_args']))
		{
			$item['job_args'] = json_decode($item['job_args'], true);
		}


		if (!empty($item['job_callback']))
		{
			$item['job_callback'] = json_decode($item['job_callback'], true);
		}

		if (!empty($item['public_uid']))
		{
			$item['public'] = WeixinMod::get_weixin_public_by_uid($item['public_uid']);
		}

		return $item;
	}

	/* 设置一个队列任务  并记录
	 * $args       = array('basic_arg' => array('sp_uid' => '', 'public_uid' => '', 'job_uid' => ''),
		                    'fun_args'  => array());
	 */

	public static function add_job($class, $args = null, $queue = '', $trackStatus = false)
	{

		$sp_uid     = isset($args['basic_arg']['sp_uid']) ? $args['basic_arg']['sp_uid'] : 0;
		$public_uid = isset($args['basic_arg']['public_uid']) ? $args['basic_arg']['public_uid'] : 0;
		$job_parent_id = !empty($args['basic_arg']['job_parent_id']) ? $args['basic_arg']['job_parent_id'] : 0;
		Dba::beginTransaction();
		{
			$job     = array('sp_uid'     => $sp_uid,
			                 'public_uid' => $public_uid,
			                 'job_parent_id' => $job_parent_id,
			                 'status'     => JobMod::STATUS_WAITING,
			                 'dir'        => empty($queue) ? 'framework' : $queue,
			                 'name'       => $class,
			                 'job_queue'  => empty($queue) ? 'framework' : $queue,
			);
			$job_uid = self::add_or_edit_job($job);
			if (!$job_uid)
			{
				Dba::rollBack();

				return false;
			}
			$args['basic_arg']['job_uid'] = $job_uid;
			$job_id                       = Queue::add_job($class, $args, $queue, $trackStatus);
			$job                          = array('uid'      => $job_uid,
			                                      'job_id'   => $job_id,
			                                      'job_args' => json_encode($args),
			);
			$ret                          = self::add_or_edit_job($job);
		}
		Dba::commit();

		return $ret;
	}

	/*设置一个定时任务  并记录
	 * $args       = array('basic_arg' => array('sp_uid' => '', 'public_uid' => '', 'job_uid' => ''),
		                    'fun_args'  => array());
	 */
	public static function do_job_at($timestamp, $class, $args = null, $queue = '')
	{
		$sp_uid     = isset($args['basic_arg']['sp_uid']) ? $args['basic_arg']['sp_uid'] : 0;
		$public_uid = isset($args['basic_arg']['public_uid']) ? $args['basic_arg']['public_uid'] : 0;
		$job_parent_id = !empty($args['basic_arg']['job_parent_id']) ? $args['basic_arg']['job_parent_id'] : 0;
		Dba::beginTransaction();
		{
			$job     = array('sp_uid'     => $sp_uid,
			                 'public_uid' => $public_uid,
			                 'job_parent_id' => $job_parent_id,
			                 'status'     => JobMod::STATUS_WAITING,
			                 'dir'        => empty($queue) ? 'framework' : $queue,
			                 'name'       => $class,
			                 'job_queue'  => 'defered');
			$job_uid = self::add_or_edit_job($job);
			if (!$job_uid)
			{
				Dba::rollBack();

				return false;
			}

			$args['basic_arg']['job_uid'] = $job_uid;
			$job_id                       = Queue::do_job_at($timestamp, $class, $args);
			$args['timestamp']            = $timestamp;
			$job                          = array('uid'      => $job_uid,
			                                      'job_id'   => $job_id,
			                                      'job_args' => json_encode($args),
			);
			$ret                          = self::add_or_edit_job($job);
		}
		Dba::commit();

		return $ret;
	}
}

