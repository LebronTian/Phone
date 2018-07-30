<?php

class IndexCtl {
	public function init_vip_card()
	{
		if (!($vip_card_sp_set = VipcardMod::get_vip_card_sp()))
		{
			if (getLastError() == ERROR_BAD_STATUS)
			{
				echo '该会员卡已经下线!';
			}
			else
			{
				echo '会员卡内部错误!' . getErrorString();
			}
			exit();
		}
		!isset($GLOBALS['_UCT']['TPL']) && ($GLOBALS['_UCT']['TPL'] = !empty($vip_card_sp_set['tpl']) ? $vip_card_sp_set['tpl'] : 'girlgroup');
		return $vip_card_sp_set;
	}


	public function index()
	{
		$vip_card_sp_set = $this->init_vip_card();
		$params = array('vip_card_sp_set' =>$vip_card_sp_set);
		render_fg('', $params);
	}

	public function form()
	{
		$vip_card_sp_set = $this->init_vip_card();
		$params = array('vip_card_sp_set' =>$vip_card_sp_set);
		render_fg('', $params);
	}

	public function result()
	{
		$vip_card_sp_set = $this->init_vip_card();
		$params = array('vip_card_sp_set'=>$vip_card_sp_set);
		render_fg('', $params);
	}
}
