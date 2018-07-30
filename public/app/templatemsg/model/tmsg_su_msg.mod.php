<?php

/*
	微信消息默认处理方式
*/

class Tmsg_su_msgMod {


    // 取各板块 可被配置为模板消息数组
    public static function get_even_args_arr( $key = '')
    {
        (!empty($key) && ($key != 'key' && $key != 'title')) && $key = '';
        $get_even_args_arr = array(
            array('key' => 'create_time', 'title' => '发送时间'),
            array('key' => 'title', 'title' => '标题'),
            array('key' => 'content', 'title' => '内容'),
        );
        (!empty($type) && !empty($key)) && $get_even_args_arr = array_column($get_even_args_arr, $key);
        (!empty($type) && empty($key)) && $get_even_args_arr = $get_even_args_arr[$type];

        return $get_even_args_arr;
    }

    // 取触发模板消息时间数组  与 sp内的保持一致
    public static function get_even_arr($key = '')
    {
        (!empty($key) && ($key != 'key' && $key != 'title')) && $key = '';
        $even_arr = array(
            '0' => array('key' => 'SuMsgMod.add_su_msg', 'title' => '用户通知'),
        );
        (!empty($type) && !empty($key)) && $even_arr = array_column($even_arr[$type], $key);

        return $even_arr;
    }

    public static function get_args($args)
    {
        $args = array(
            'create_time'=>date('Y-m-d H:i:s',$args['create_time']),
            'title'=>$args['title'],
            'content'=>$args['content'],
        );
        return $args;
    }


}

