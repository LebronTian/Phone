<?php

//一元夺宝开奖 
class Shop_Indiana_OpenJob {
	//job 里运行的内容
	public function perform($uid)
	{
		IndianaMod::do_indiana($uid);
	}

}

