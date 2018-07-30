<?php
/**
 * Base Resque class.
 *
 * @package		Resque
 * @author		Chris Boulton <chris@bigcommerce.com>
 * @license		http://www.opensource.org/licenses/mit-license.php
 */

uct_use_vendor('Credis');
uct_use_vendor('Psr');

class Resque
{
	const VERSION = '1.2';

    const DEFAULT_INTERVAL = 5;

	/**
	 * @var Resque_Redis Instance of Resque_Redis that talks to redis.
	 */
	public static $redis = null;

	/**
	 * @var mixed Host/port conbination separated by a colon, or a nested
	 * array of server swith host/port pairs
	 */
	protected static $redisServer = null;

	/**
	 * @var int ID of Redis database to select.
	 */
	protected static $redisDatabase = 0;

	/**
	 * Given a host/port combination separated by a colon, set it as
	 * the redis server that Resque will talk to.
	 *
	 * @param mixed $server Host/port combination separated by a colon, DSN-formatted URI, or
	 *                      a callable that receives the configured database ID
	 *                      and returns a Resque_Redis instance, or
	 *                      a nested array of servers with host/port pairs.
	 * @param int $database
	 */
	public static function setBackend($server, $database = 0)
	{
		self::$redisServer   = $server;
		self::$redisDatabase = $database;
		self::$redis         = null;
	}

	/**
	 * Return an instance of the Resque_Redis class instantiated for Resque.
	 *
	 * @return Resque_Redis Instance of Resque_Redis.
	 */
	public static function redis()
	{
		if (self::$redis !== null) {
			return self::$redis;
		}

		if (is_callable(self::$redisServer)) {
			self::$redis = call_user_func(self::$redisServer, self::$redisDatabase);
		} else {
			self::$redis = new Resque_Redis(self::$redisServer, self::$redisDatabase);
		}

		return self::$redis;
	}

	/**
	 * fork() helper method for php-resque that handles issues PHP socket
	 * and phpredis have with passing around sockets between child/parent
	 * processes.
	 *
	 * Will close connection to Redis before forking.
	 *
	 * @return int Return vars as per pcntl_fork()
	 */
	public static function fork()
	{
		if(!function_exists('pcntl_fork')) {
			return -1;
		}

		// Close the connection to Redis before forking.
		// This is a workaround for issues phpredis has.
		self::$redis = null;

		$pid = pcntl_fork();
		if($pid === -1) {
			throw new RuntimeException('Unable to fork child worker.');
		}

		return $pid;
	}

	/**
	 * Push a job to the end of a specific queue. If the queue does not
	 * exist, then create it as well.
	 *
	 * @param string $queue The name of the queue to add the job to.
	 * @param array $item Job description as an array to be JSON encoded.
	 */
	public static function push($queue, $item)
	{
		self::redis()->sadd('queues', $queue);
		$length = self::redis()->rpush('queue:' . $queue, json_encode($item));
		if ($length < 1) {
			return false;
		}
		return true;
	}

	/**
	 * Pop an item off the end of the specified queue, decode it and
	 * return it.
	 *
	 * @param string $queue The name of the queue to fetch an item from.
	 * @return array Decoded item from the queue.
	 */
	public static function pop($queue)
	{
        $item = self::redis()->lpop('queue:' . $queue);

		if(!$item) {
			return;
		}

		return json_decode($item, true);
	}

	/**
	 * Remove items of the specified queue
	 *
	 * @param string $queue The name of the queue to fetch an item from.
	 * @param array $items
	 * @return integer number of deleted items
	 */
	public static function dequeue($queue, $items = Array())
	{
	    if(count($items) > 0) {
		return self::removeItems($queue, $items);
	    } else {
		return self::removeList($queue);
	    }
	}

	/**
	 * Remove specified queue
	 *
	 * @param string $queue The name of the queue to remove.
	 * @return integer Number of deleted items
	 */
	public static function removeQueue($queue)
	{
	    $num = self::removeList($queue);
	    self::redis()->srem('queues', $queue);
	    return $num;
	}

	/**
	 * Pop an item off the end of the specified queues, using blocking list pop,
	 * decode it and return it.
	 *
	 * @param array         $queues
	 * @param int           $timeout
	 * @return null|array   Decoded item from the queue.
	 */
	public static function blpop(array $queues, $timeout)
	{
	    $list = array();
	    foreach($queues AS $queue) {
		$list[] = 'queue:' . $queue;
	    }

	    $item = self::redis()->blpop($list, (int)$timeout);

	    if(!$item) {
		return;
	    }

	    /**
	     * Normally the Resque_Redis class returns queue names without the prefix
	     * But the blpop is a bit different. It returns the name as prefix:queue:name
	     * So we need to strip off the prefix:queue: part
	     */
	    $queue = substr($item[0], strlen(self::redis()->getPrefix() . 'queue:'));

	    return array(
		'queue'   => $queue,
		'payload' => json_decode($item[1], true)
	    );
	}

	/**
	 * Return the size (number of pending jobs) of the specified queue.
	 *
	 * @param string $queue name of the queue to be checked for pending jobs
	 *
	 * @return int The size of the queue.
	 */
	public static function size($queue)
	{
		return self::redis()->llen('queue:' . $queue);
	}

	/**
	 * Create a new job and save it to the specified queue.
	 *
	 * @param string $queue The name of the queue to place the job in.
	 * @param string $class The name of the class that contains the code to execute the job.
	 * @param array $args Any optional arguments that should be passed when the job is executed.
	 * @param boolean $trackStatus Set to true to be able to monitor the status of a job.
	 *
	 * @return string|boolean Job ID when the job was created, false if creation was cancelled due to beforeEnqueue
	 */
	public static function enqueue($queue, $class, $args = null, $trackStatus = false)
	{
		$id         = Resque::generateJobId();
		$hookParams = array(
			'class' => $class,
			'args'  => $args,
			'queue' => $queue,
			'id'    => $id,
		);
		try {
			Resque_Event::trigger('beforeEnqueue', $hookParams);
		}
		catch(Resque_Job_DontCreate $e) {
			return false;
		}

		Resque_Job::create($queue, $class, $args, $trackStatus, $id);
		Resque_Event::trigger('afterEnqueue', $hookParams);

		return $id;
	}

	/**
	 * Reserve and return the next available job in the specified queue.
	 *
	 * @param string $queue Queue to fetch next available job from.
	 * @return Resque_Job Instance of Resque_Job to be processed, false if none or error.
	 */
	public static function reserve($queue)
	{
		return Resque_Job::reserve($queue);
	}

	/**
	 * Get an array of all known queues.
	 *
	 * @return array Array of queues.
	 */
	public static function queues()
	{
		$queues = self::redis()->smembers('queues');
		if(!is_array($queues)) {
			$queues = array();
		}
		return $queues;
	}

	/**
	 * Remove Items from the queue
	 * Safely moving each item to a temporary queue before processing it
	 * If the Job matches, counts otherwise puts it in a requeue_queue
	 * which at the end eventually be copied back into the original queue
	 *
	 * @private
	 *
	 * @param string $queue The name of the queue
	 * @param array $items
	 * @return integer number of deleted items
	 */
	private static function removeItems($queue, $items = Array())
	{
		$counter = 0;
		$originalQueue = 'queue:'. $queue;
		$tempQueue = $originalQueue. ':temp:'. time();
		$requeueQueue = $tempQueue. ':requeue';
		
		// move each item from original queue to temp queue and process it
		$finished = false;
		while (!$finished) {
			$string = self::redis()->rpoplpush($originalQueue, self::redis()->getPrefix() . $tempQueue);
	
			if (!empty($string)) {
				if(self::matchItem($string, $items)) {
					self::redis()->rpop($tempQueue);
					$counter++;
				} else {
					self::redis()->rpoplpush($tempQueue, self::redis()->getPrefix() . $requeueQueue);
				}
			} else {
				$finished = true;
			}
		}

		// move back from temp queue to original queue
		$finished = false;
		while (!$finished) {
			$string = self::redis()->rpoplpush($requeueQueue, self::redis()->getPrefix() .$originalQueue);
			if (empty($string)) {
			    $finished = true;
			}
		}

		// remove temp queue and requeue queue
		self::redis()->del($requeueQueue);
		self::redis()->del($tempQueue);
		
		return $counter;
	}

	/**
	 * matching item
	 * item can be ['class'] or ['class' => 'id'] or ['class' => {:foo => 1, :bar => 2}]
	 * @private
	 *
	 * @params string $string redis result in json
	 * @params $items
	 *
	 * @return (bool)
	 */
	private static function matchItem($string, $items)
	{
	    $decoded = json_decode($string, true);

	    foreach($items as $key => $val) {
		# class name only  ex: item[0] = ['class']
		if (is_numeric($key)) {
		    if($decoded['class'] == $val) {
			return true;
		    }
		# class name with args , example: item[0] = ['class' => {'foo' => 1, 'bar' => 2}]
    		} elseif (is_array($val)) {
		    $decodedArgs = (array)$decoded['args'][0];
		    if ($decoded['class'] == $key &&
			count($decodedArgs) > 0 && count(array_diff($decodedArgs, $val)) == 0) {
			return true;
			}
		# class name with ID, example: item[0] = ['class' => 'id']
		} else {
		    if ($decoded['class'] == $key && $decoded['id'] == $val) {
			return true;
		    }
		}
	    }
	    return false;
	}

	/**
	 * Remove List
	 *
	 * @private
	 *
	 * @params string $queue the name of the queue
	 * @return integer number of deleted items belongs to this list
	 */
	private static function removeList($queue)
	{
	    $counter = self::size($queue);
	    $result = self::redis()->del('queue:' . $queue);
	    return ($result == 1) ? $counter : 0;
	}

	/*
	 * Generate an identifier to attach to a job for status tracking.
	 *
	 * @return string
	 */
	public static function generateJobId()
	{
		return md5(uniqid('', true));
	}

	public static function job_to_string($job) {
		$name = array('Job[defered]', 'ID: '.$job['id'], $job['class']);
		if(!empty($job['args'])) {
			$name[] = json_encode($job['args']);
		}
		return '(' . implode(' | ', $name) . ')';
	}

	/*
		定时任务使用到的redis键
		1. resque:deferedz  sorted set: score存时间, value 存任务id
		2. resque:deferedh  hash: 存job_id => payload
		3. resque:deferedhl hash: 存job_id => lock时间
		4. resque:defededzf sorted set: score存时间, value 存失败的任务id

		新增定时任务	
	*/
	public static function defered_enqueue($timestamp, $class, $args = null) {
		$id = Resque::generateJobId();
	
		self::redis()->zadd('deferedz', $timestamp, $id);
		self::redis()->hset('deferedh', $id, json_encode(array(
			'class'	=> $class,
			'args'	=> array($args),
			'id'	=> $id,
			'run_at' => $timestamp,
			'queue_time' => microtime(true),
		)));

		return $id;
	}

	/*
		取候选定时任务
		@param $score 在此之前的任务
	*/
	public static function defered_reserve($score = 0) {
		!$score && $score = time() + self::DEFAULT_INTERVAL;
		$jids = self::redis()->zrangebyscore('deferedz', 0, $score);
		if(!$jids) {
			return false;
		}
		foreach($jids as $jid) {
			if(self::defered_lock_job($jid)) {
				$job =  self::redis()->hget('deferedh', $jid);
				if($job && ($job = json_decode($job, true))) {
					return $job;
				}
			}
		}

		return false;
	}

	/*
		锁定定时任务
	*/
	public static function defered_lock_job($id) {
		$time = time();
		if(self::redis()->hsetnx('deferedhl', $id, $time)) {
			return true;
		}

		$lock_time = self::redis()->hget('deferedhl', $id);
		if($lock_time < $time - 30*60) { //30min 超时
			self::redis()->hset('deferedhl', $id, $time);
			return true;
		}

		return false;
	}

	/*
		删除定时任务
	*/
	public static function defered_delete_job($id) {
		self::redis()->zrem('deferedz', $id);
		self::redis()->zrem('deferedzf', $id);
		self::redis()->hdel('deferedh', $id);
		return true;
	}

	/*
		重新开始定时任务
	*/
	public static function defered_requeue_job($id) {
		if(!$score = self::redis()->zscore('deferedzf', $id)) {
			return false;
		}	
		
		self::redis()->zadd('deferedz', $score, $id);
		self::redis()->zrem('deferedzf', $id);
		return true;
	}

	/*
		删除任务
	*/
	public static function delete_job($id, $queue) {
		$ret = false;
		if($len = self::redis()->llen('failed'))
		for($i = 0; $i < $len; $i++) {
			$job = json_decode(self::redis()->lindex('failed', $i), true);
			if(!empty($job['payload']['id']) && ($job['payload']['id'] == $id)) {
				self::redis()->lrem('failed', 1, json_encode($job));
				$ret = true;
				break;
			}
		}

		if($len = self::redis()->llen('queue:'.$queue))
		for($i = 0; $i < $len; $i++) {
			$job = json_decode(self::redis()->lindex('queue:'.$queue, $i), true);
			if(!empty($job['payload']['id']) && ($job['payload']['id'] == $id)) {
				self::redis()->lrem('queue:'.$queue, 1, json_encode($job));
				$ret = true;
				break;
			}
		}

		return $ret;
	}

	/*
		重新开始任务
	*/
	public static function requeue_job($id, $queue = '') {
		if(!$len = self::redis()->llen('failed')) {
			return false;
		}
		for($i = 0; $i < $len; $i++) {
			$job = json_decode(self::redis()->lindex('failed', $i), true);
			if(!empty($job['payload']['id']) && ($job['payload']['id'] == $id)) {
				$find = $job['payload']; 
				!$queue && $queue = $job['queue'];
				break;
			}
		}
		if(empty($find)) {
			return false;
		}
		
		self::push($queue, $find);
		self::redis()->lrem('failed', 1, json_encode($job));
		return true;
	}

	/*
		完成	
	*/
	public static function defered_done_job($worker, $id, $failed = false) {
		if($failed)	{
			self::redis()->zadd('deferedzf', time(), $id);
			//failed
			{
				self::redis()->incr('stat:failed');
				self::redis()->incr('stat:failed:'.$worker);
				self::redis()->incr('stat:deferedfailed');
				self::redis()->incr('stat:deferedfailed:'.$worker);
			}
		}
		else {
			self::redis()->hdel('deferedh', $id);
		}
			
		self::redis()->zrem('deferedz', $id);
		self::redis()->hdel('deferedhl', $id);
		
		//doneWorking
		{
			self::redis()->incr('stat:processed');
			self::redis()->incr('stat:processed:'.$worker);
			self::redis()->incr('stat:deferedprocessed');
			self::redis()->incr('stat:deferedprocessed:'.$worker);
			Resque::redis()->del('worker:'.$worker);
		}

		return true;
	}

	/*
		检查并运行定时任务
	*/
	public static function do_defered_job($worker) {
		$worker->logger->log(Psr\Log\LogLevel::INFO, 'starting do defered job');
		if(!$job = self::defered_reserve()) {
			return false;
		}

		$sleep = $job['run_at'] - time();	
		if($sleep < 0) {
			$worker->logger->log(Psr\Log\LogLevel::WARNING, 'starting defered work LATE in '.$sleep.' seconds on '.self::job_to_string($job));
			$sleep = 0;
		}

		//workingOn
		{
			$data = json_encode(array(
				'queue' => 'defered',
				'run_at' => strftime('%a %b %d %H:%M:%S %Z %Y'),
				'payload' => $job
			));
			Resque::redis()->set('worker:' . $worker, $data);
		}

		$failed = false;
		$child = Resque::fork();
		if($child === 0 || $child === false) {
			$worker->logger->log(Psr\Log\LogLevel::NOTICE, 'starting defered work in '.$sleep.' seconds on '.self::job_to_string($job));
			if($sleep > 0) {
				sleep($sleep);
			}

			try {
				self::perform_defered_job($job);
			}
			catch(Exception $e) {
				$worker->logger->log(Psr\Log\LogLevel::CRITICAL, '{job} has failed {stack}', array('job' => self::job_to_string($job), 
														'stack' => $e->getMessage()));
				$failed = true;
			}
			if($child === 0) {
				exit(0);
			}
		}

		if($child > 0) {
			$status = '';
			pcntl_wait($status);
			$exitStatus = pcntl_wexitstatus($status);
			if($exitStatus !== 0) {
				$failed = true;
			}
		}

		self::defered_done_job($worker, $job['id'], !empty($failed));
		if(!$failed) {
			$worker->logger->log(Psr\Log\LogLevel::NOTICE, 'defered {job} has finished', array('job' => self::job_to_string($job)));
		}

		return true;
	}

	public static function perform_defered_job($job) {
		if(!class_exists($job['class'])) {
			throw new Resque_Exception(
				'Could not find defered job class ' . $job['class'] . '.'
			);
		}
		if(!method_exists($job['class'], 'perform')) {
			throw new Resque_Exception(
				'defered Job class ' . $job['class'] . ' does not contain a perform method.'
			);
		}
		$cls = new $job['class'];
		$args = empty($job['args'][0]) ? array() : $job['args'][0];
		$cls->args = $args;
		if(method_exists($cls, 'setUp')) {
			$cls->setUp();
		}

		#$cls->perform();
		call_user_func_array(array($cls, 'perform'), $args);

		if(method_exists($cls, 'tearDown')) {
			$cls->tearDown();
		}
		return true;
	}

	/*
		增加工作进程	
		nohup php ../tools/add_worker.php >> /tmp/uct_weixin_worker.log 2>&1 &
		php ../tools/add_worker.php >> /tmp/uct_weixin_worker.log 2>&1 &

		@param $queue 工作队列 默认"*"
	*/
	public static function get_cmd_add_worker($queue = '') {
		$which       = 'which';

		$nohup       = exec($which.' nohup'); #'/usr/bin/nohup';
		$php         = exec($which.' php');   #'/usr/local/bin/php';
		$script      = '"'.realpath(UCT_PATH . '../tools/worker/add_worker.php').'"';
		$args        = $queue;
		$log         = '/tmp/uctphp_weixin_worker.log';

		!$nohup && $nohup = 'nohup';
		!$php && $php = 'php';

		//从php web执行不要nohup
		#if(PHP_SAPI != 'cli') {
			$nohup = '';	
		#}
		$cmd = $nohup.' '.$php.' '.$script.' '.$args.' >> '.$log.' 2>&1 &';
		#$cmd = $php.' '.$script.' '.$args.' >> '.$log.' 2>&1 &';

		return ($cmd);	
	}

}


