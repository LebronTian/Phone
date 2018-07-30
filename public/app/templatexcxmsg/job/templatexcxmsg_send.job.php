<?php
/*
 * 异步发送模板消息
 */

class templatexcxmsg_sendJob {
	public function perform($data,$templatexcx_msg_set,$user_id) {
        uct_use_app('templatexcxmsg');
        $ret = Templatexcx_Msg_WxPlugMod::wx_send_template_msg($templatexcx_msg_set['public_uid'], $data);
        if ($ret != 'ok')
        {
            return;
        }
        $remplate_msg_record = array('public_uid'  => $templatexcx_msg_set['public_uid'],
                                     'template_id' => $templatexcx_msg_set['template_id'],
                                     'su_uid'      => $user_id,
                                     'page'         => isset($templatexcx_msg_set['page']) ? $templatexcx_msg_set['page'] : '',
                                     'data'        => $data,
                                     'even'        => $templatexcx_msg_set['even'],
                                     'sp_uid'      => $templatexcx_msg_set['sp_uid'],
        );

        Templatexcx_Msg_WxPlugMod::add_templatexcx_msg_record($remplate_msg_record);
	}
}

