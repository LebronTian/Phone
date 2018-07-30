<?php
/*
	同步微信粉丝
*/

class Su_synwxuserJob {
    public  $public_uid;
    public  $sp_uid;
    public  $access_token;
    public $qucik;
	public function perform($sp_uid,$qucik=false) {
	    $this->sp_uid = $sp_uid;
	    $this->qucik = $qucik;
        $option = array('public_type'=>18,
            'sp_uid'=>$sp_uid);
        $public_list = WeixinMod::get_weixin_public_list($option);
        foreach ($public_list['list'] as $public)
        {
            $this->public_uid = $public['uid'];
            $this->access_token = WeixinMod::get_weixin_access_token($this->public_uid);
            $this->get_user_list();
             empty($this->qucik) && $this->get_user_info_batchget();
        }
        unset($GLOBALS['arraydb_job']['syn_fans_'.$sp_uid]);
	}
    //同步openid列表
    public function get_user_list($NEXT_OPENID='')
    {
        $ret = Weixin::weixin_get_user_list($NEXT_OPENID,$this->access_token);
        if($ret)
        {
            $NEXT_OPENID = $ret['next_openid'];
            foreach ($ret['data']['openid'] as $openid)
            {
                $this->add_weixin_fans($openid);
            }
            $this->get_user_list($NEXT_OPENID);
        }
        else
        {
            return false;
        }

	}
    //粉丝不存在时增加
	public function add_weixin_fans($open_id)
    {
        $sql = 'select * from weixin_fans where public_uid = '.$this->public_uid.' && open_id = "'.addslashes($open_id).'"';
        if(!($weixin_fan = Dba::readRowAssoc($sql))) {
            $su = array( 'sp_uid' =>$this->sp_uid );
            Dba::beginTransaction(); {
                $su_uid = AccountMod::add_or_edit_service_user($su);
                $weixin_fan = array('public_uid' => $this->public_uid,
                    'open_id' => $open_id,
                    'has_subscribed' => 0,
                    'su_uid'=>$su_uid);
                Dba::insert('weixin_fans', $weixin_fan);
            } Dba::commit();
        }
    }
    //更新信息
    public function update_weixin_fans_info($ui){
        $update = array();
        if(!empty($ui['nickname'])) {
            #$update['name'] = checkString($ui['nickname'], PATTERN_USER_NAME);
            //todo mb4
            $update['name'] = preg_replace('/[\x{10000}-\x{10FFFF}]/u', '', $ui['nickname']);
        }
        if(!empty($ui['sex'])) $update['gender'] = checkInt($ui['sex']);
        if(!empty($ui['headimgurl'])) $update['avatar'] = checkString($ui['headimgurl'], PATTERN_URL);
        Dba::update('weixin_fans',array('has_subscribed'=>$ui['subscribe']),'open_id = "'.addslashes($ui['openid']).'"');
        $su_uid  = Dba::readOne('select su_uid from weixin_fans where open_id = "'.addslashes($ui['openid']).'"');
       empty($update) || Dba::update('service_user',$update,'uid = '.$su_uid);
    }
    //批量获取粉丝信息
    public function get_user_info_batchget($page=0)
    {
        $sql = 'select open_id as openid from weixin_fans where public_uid = '.$this->public_uid;
        $ret = Dba::readCountAndLimit($sql,$page,100,'Su_synwxuserJob::func_get_weifans_open_id_list');
        if(!empty($ret['list']))
        {
            $data['user_list'] = $ret['list'];
            $data = json_encode($data);
            $ret = Weixin::weixin_get_user_info_batchget($data,$this->access_token);
            if($ret)
            {
                foreach ($ret['user_info_list'] as $fas)
                {
                    $this->update_weixin_fans_info($fas);
                }
            }
            $this->get_user_info_batchget(++$page);
        }
        else{
            return ;
        }

    }

    public static function func_get_weifans_open_id_list($item)
    {
        $item['lang'] = 'zh-CN';
        return $item;
    }

}

