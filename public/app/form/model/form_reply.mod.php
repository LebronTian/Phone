<?php
/**
 * form_reply
 */

class Form_ReplyMod {

    public static function func_get_form_reply($item){

        if(!empty($item['f_uid'])) $item['form'] = FormMod::get_form_by_uid($item['f_uid']);
        if(!empty($item['su_uid'])) $item['su'] = AccountMod::get_service_user_by_uid($item['su_uid']);
        if(!empty($item['uid'])) $item['reply_son'] = Form_ReplyMod::get_form_reply_son($item['uid']);

        return $item;
    }

    public static function func_get_form_reply_son($item){
        if(!empty($item['su_uid'])) $item['su'] = AccountMod::get_service_user_by_uid($item['su_uid']);
        return $item;
    }

    public static function get_form_reply_son($p_uid){
        return Dba::readRowAssoc('select * from form_reply where p_uid = '.$p_uid,'Form_ReplyMod::func_get_form_reply_son');
    }

    public static function get_form_reply_by_uid($uid){
        return Dba::readRowAssoc('select * from form_reply where uid = '.$uid,'Form_ReplyMod::func_get_form_reply');
    }

    public static function get_form_reply($option){
        $sql = 'select * from form_reply';
        if(!empty($option['sp_uid'])) {
            $where_arr[] = 'sp_uid ='.$option['sp_uid'];
        }
        if(!empty($option['f_uid'])) {
            $where_arr[] = 'f_uid ='.$option['f_uid'];
        }
        if(isset($option['p_uid'])) {
            $where_arr[] = 'p_uid ='.$option['p_uid'];
        }
        if(!empty($option['key']))
        {
            $where_arr[] = 'content like "%'.$option['key'].'%"';
        }
        if(isset($option['status']))
        {
            $where_arr[] = 'status ='.$option['status'];
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }
        $sql .= ' order by create_time desc';

        return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'Form_ReplyMod::func_get_form_reply');
    }

    public static function add_or_edit_form_reply($option){
        if(!empty($option['uid'])) {
            Dba::update('form_reply', $option, 'uid = '.$option['uid'].' and sp_uid = '.$option['sp_uid']);
        }
        else {
            $option['create_time'] = $_SERVER['REQUEST_TIME'];
            Dba::insert('form_reply', $option);
            $option['uid'] = Dba::insertID();

        }

        return $option['uid'];
    }

    public static function delete_form_reply($fids,$sp_uid){
        if(!is_array($fids)) {
            $fids = array($fids);
        }
        $real_fids = Dba::readAllOne('select uid from form_reply where uid in ('.implode(',', $fids).') && sp_uid = '.$sp_uid);
        if(!$real_fids) {
            return 0;
        }

        $sql = 'delete from form_reply where uid in ('.implode(',',$real_fids).')';
        Dba::beginTransaction(); {
            if($ret = Dba::write($sql)) {
//                $sql = 'delete from form_record where f_uid in ('.implode(',', $real_fids).')';
//                Dba::write($sql);
            }
        } Dba::commit();

        return $ret;
    }


}