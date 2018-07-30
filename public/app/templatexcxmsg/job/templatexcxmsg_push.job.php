<?php
/*
	推送小程序模板消息	
*/

class Templatexcxmsg_pushJob {
	public function perform($user_template, $user_id, $public_uid) {
		#Weixin::weixin_log('heheheheeheheh send sth '.implode('|',$user_id).', '.$public_uid);
        if(!$user_id)
        {
            $page = 0;
            $count = Dba::readOne('select count(*) from weixin_fans_xiaochengxu where public_uid ='.$public_uid);
            while(($weixin_fans = Dba::readAllOne('select open_id from weixin_fans where public_uid ='.$public_uid.' limit '.($page*100).',100' )))
            {
                $this->send($weixin_fans, $public_uid, $user_template);
                $page++;
                $GLOBALS['arraydb_job']['sendtemplatemsg_send'.$public_uid] = ($page*100).'/'.$count;
            }
        }
        else{
            $weixin_fans = Dba::readAllOne('select open_id from weixin_fans_xiaochengxu where su_uid in('.implode(',',$user_id).') && public_uid = '.$public_uid);
            $this->send($weixin_fans, $public_uid, $user_template);
        }
        unset($GLOBALS['arraydb_job']['sendtemplatemsg_send'.$public_uid]);
	}

	public function send($weixin_fans, $public_uid, $user_template)
    {
		$cnt = 0;
        foreach ( $weixin_fans as $open_id)
        {
			#Weixin::weixin_log('send to openid -> '.$open_id);
			$form_id = XiaochengxuMod::get_a_form_id(Dba::readOne('select su_uid from weixin_fans_xiaochengxu where open_id = "'.$open_id.'"'));
			#Weixin::weixin_log('get a formid -> '.$form_id);
			if(!$form_id) {
				continue;
			}
			#Weixin::weixin_log('get a formid -> '.var_export($user_template, true));
            $data = array('touser'      => $open_id,
				'form_id' => $form_id,
                'template_id' => $user_template['template_id'],
                'page'        => isset($user_template['url']) ? $user_template['url'] : '',
                'data'        => $user_template['template_data']);

			if(isset($user_template['emphasis_keyword'])) {
				$data['emphasis_keyword'] = $user_template['emphasis_keyword'];
			}
			if(Templatexcx_Msg_WxPlugMod::wx_send_template_msg($public_uid, $data)) {
				$cnt++;
			}
        }

		return $cnt;
    }

}

