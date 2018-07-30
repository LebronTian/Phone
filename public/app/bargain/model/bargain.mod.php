<?php
/*
 * 砍价
 */

class BargainMod {

    public static function func_get_bargain($item) {
        $item['title'] = htmlspecialchars($item['title']);

        if(!empty($item['product_info'])) $item['product_info'] = json_decode($item['product_info'], true);
        if(!empty($item['rule'])) $item['rule'] = json_decode($item['rule'], true);
        $item['join_cnt'] = Dba::readOne('select count(uid) from shop_bargain_user where bargain_uid='.$item['uid']);

        //已过期设置状态为1
        if(!empty($item['rule']['end_time'])&&$item['rule']['end_time']<=$_SERVER['REQUEST_TIME']){
            $item['status'] = 1;
            Dba::update('shop_bargain',array('status'=>1),'uid = '.$item['uid']);
        }

        return $item;
    }

    public static function func_get_bargain_user($item) {
        $item['title'] = htmlspecialchars($item['title']);
        $item['info'] = htmlspecialchars($item['info']);
        if(!empty($item['bargain_uid'])){
            $item['bargain'] = BargainMod::get_bargain_by_uid($item['bargain_uid']);
        }
//        $item['order'] = BargainMod::get_bargain_order_by_uid($item['uid']);
        $item['su'] = AccountMod::get_service_user_by_uid($item['su_uid']);

        $item['support_cnt'] = Dba::readOne('select count(uid) from shop_bargain_help where bu_uid='.$item['uid']);

        //已过期设置状态为1
        if(!empty($item['bargain'])){
            if(!empty($item['bargain']['rule']['end_time'])&&$item['bargain']['rule']['end_time']<=$_SERVER['REQUEST_TIME']){
                $item['status'] = 1;
                Dba::update('shop_bargain_user',array('status'=>1),'uid = '.$item['uid']);
            }
        }
        return $item;
    }

    public static function func_get_bargain_help($item){

        $item['su'] = AccountMod::get_service_user_by_uid($item['su_uid']);

        return $item;
    }

//    public static function get_bargain_order_by_uid($uid) {
//        return Dba::readRowAssoc('select * from shop_bargain_order where b_uid = '.$uid, 'BargainMod::func_get_bargain_order');
//    }

//    public static function func_get_bargain_order($item) {
//        if(!empty($item['pay_info'])) $item['pay_info'] = json_decode($item['pay_info'], true);
//        return $item;
//    }

    //获取砍价商品信息
    public static function get_bargain_by_uid($uid) {

        return Dba::readRowAssoc('select * from shop_bargain where uid = '.$uid, 'BargainMod::func_get_bargain');
    }

    //获取用户砍价商品信息
    public static function get_bargain_user_by_uid($uid) {

        return Dba::readRowAssoc('select * from shop_bargain_user where uid = '.$uid, 'BargainMod::func_get_bargain_user');
    }

    public static function get_bargain_user_by_su_uid($su_uid,$b_uid){
        return Dba::readRowAssoc('select * from shop_bargain_user where su_uid = '.$su_uid.' and bargain_uid='.$b_uid, 'BargainMod::func_get_bargain_user');
    }

    //获取砍价商品
    public static function get_bargainlist($option){
        $sql = 'select * from shop_bargain';
        if(!empty($option['sp_uid'])) {
            $where_arr[] = 'sp_uid='.$option['sp_uid'];
        }
        if(!empty($option['key']))
        {
            $where_arr[] = 'title like "%'.$option['key'].'%"';
        }
//        if(isset($option['type']))
//        {
//            $where_arr[] = 'type ="'.addslashes($option['type']).'"';
//        }
        if(isset($option['status']))
        {
            $where_arr[] = 'status ='.$option['status'];
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }
        $sql .= ' order by create_time desc';

        return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'BargainMod::func_get_bargain');
    }

    //添加或修改砍价商品
    public static function add_or_edit_bargain($option) {
        if(!empty($option['uid'])) {
            Dba::update('shop_bargain', $option, 'uid = '.$option['uid'].' and sp_uid = '.$option['sp_uid']);
        }
        else {
            $option['create_time'] = $_SERVER['REQUEST_TIME'];
            Dba::insert('shop_bargain', $option);
            $form['uid'] = Dba::insertID();

        }

        return $option['uid'];
    }

    public static function delete_bargain($fids, $sp_uid) {
        if(!is_array($fids)) {
            $fids = array($fids);
        }
        $real_fids = Dba::readAllOne('select uid from shop_bargain where uid in ('.implode(',', $fids).') && sp_uid = '.$sp_uid);
        if(!$real_fids) {
            return 0;
        }

        $sql = 'delete from shop_bargain where uid in ('.implode(',',$real_fids).')';
        Dba::beginTransaction(); {
            if($ret = Dba::write($sql)) {
                $sql = 'delete from shop_bargain_user where bargain_uid in ('.implode(',', $real_fids).')';
                Dba::write($sql);
            }
        } Dba::commit();

        return $ret;
    }


    /*
     * 获取用户砍价信息
     */
    public static function user_bargainlist($option){
        $sql = 'select * from shop_bargain_user';
        if(!empty($option['sp_uid'])) {
            $where_arr[] = 'sp_uid='.$option['sp_uid'];
        }
        if(!empty($option['bargain_uid']))
        {
            $where_arr[] = 'bargain_uid = '.$option['bargain_uid'];
        }
        if(!empty($option['su_uid']))
        {
            $where_arr[] = 'su_uid='.$option['su_uid'];
        }
        if(isset($option['status']))
        {
            $where_arr[] = 'status ='.$option['status'];
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }
        $sql .= ' order by create_time desc';

        return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'BargainMod::func_get_bargain_user');
    }

    /*
     * 我也要砍价/添加或修改砍价
     */
    public static function add_or_edit_user_bargain($option) {
        if(!empty($option['uid'])) {
            Dba::update('shop_bargain_user', $option, 'uid = '.$option['uid'].' and sp_uid = '.$option['sp_uid']);
        }
        else {
            $option['create_time'] = $_SERVER['REQUEST_TIME'];
            Dba::insert('shop_bargain_user', $option);
            $option['uid'] = Dba::insertID();
        }

        return $option['uid'];
    }

    //删除正在砍价的
    public static function delete_bargain_user($fids, $sp_uid) {
        if(!is_array($fids)) {
            $fids = array($fids);
        }
        $real_fids = Dba::readAllOne('select uid from shop_bargain_user where uid in ('.implode(',', $fids).') && sp_uid = '.$sp_uid);
        if(!$real_fids) {
            return 0;
        }

        $sql = 'delete from shop_bargain_user where uid in ('.implode(',',$real_fids).')';
        Dba::beginTransaction(); {
            if($ret = Dba::write($sql)) {
                $sql = 'delete from shop_bargain_help where bu_uid in ('.implode(',', $real_fids).')';
                Dba::write($sql);
            }
        } Dba::commit();

        return $ret;
    }

    //获取某人是否帮xx砍过价
    public static function get_help_bargain_by_su_bu_uid($su_uid,$bu_uid){
        return Dba::readOne('select uid from shop_bargain_help where su_uid='.$su_uid.' and bu_uid='.$bu_uid);
    }

    /*
     * 帮忙砍价表
     */
    public static function help_bargainlist($option){
        $sql = 'select * from shop_bargain_help';

        if(!empty($option['bu_uid']))
        {
            $where_arr[] = 'bu_uid='.$option['bu_uid'];
        }
        if(!empty($option['su_uid']))
        {
            $where_arr[] = 'su_uid='.$option['su_uid'];
        }

        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }
        $sql .= ' order by create_time desc';

        return Dba::readCountAndLimit($sql, $option['page'], $option['limit'],'BargainMod::func_get_bargain_help');
    }

    /*
     * 帮砍
     */
    public static function add_help_bargain($option,$current_price) {
        if(!empty($option['uid'])) {
            Dba::update('shop_bargain_help', $option, 'uid = '.$option['uid']);
        }
        else {
            $option['create_time'] = $_SERVER['REQUEST_TIME'];
            Dba::insert('shop_bargain_help', $option);
            $option['uid'] = Dba::insertID();
            if($option['uid']){

                Dba::write('update shop_bargain_user set current_price = '.$current_price.' where uid = '.$option['bu_uid']);
            }
        }

        return $option['uid'];
    }

    //删除帮砍
    public static function delete_bargain_help($fids) {
        if(!is_array($fids)) {
            $fids = array($fids);
        }
        $real_fids = Dba::readAllOne('select uid from shop_bargain_user where uid in ('.implode(',', $fids).')');
        if(!$real_fids) {
            return 0;
        }

        $sql = 'delete from shop_bargain_help where uid in ('.implode(',',$real_fids).')';
        $ret = Dba::write($sql);
        return $ret;
    }


}