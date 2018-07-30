<?php
/*
 * 异步发送模板消息
 */

class templatemsg_sendJob {
	public function perform($data,$template_msg_set,$user_id) {
        uct_use_app('templatemsg');
        $ret = Template_Msg_WxPlugMod::wx_send_template_msg($template_msg_set['public_uid'], $data);
        if (!$ret)
        {
            return;
        }
        $remplate_msg_record = array('public_uid'  => $template_msg_set['public_uid'],
                                     'template_id' => $template_msg_set['template_id'],
                                     'su_uid'      => $user_id,
                                     'url'         => isset($template_msg_set['url']) ? $template_msg_set['url'] : '',
                                     'data'        => $data,
                                     'msg_id'      => $ret,
                                     'even'        => $template_msg_set['even'],
                                     'sp_uid'      => $template_msg_set['sp_uid'],
        );

        Template_Msg_WxPlugMod::add_template_msg_record($remplate_msg_record);
	}
}

