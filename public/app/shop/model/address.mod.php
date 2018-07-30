<?php


class AddressMod {
    public static function func_get_address($item){

        if(!empty($item['address_data'])) $item['address_data'] = json_decode($item['address_data'],true);

        return $item;
    }

    //获取全部地址
    //分页
    public static function get_shop_address($option){
        $sql = 'select * from shop_address';

        if(!empty($option['shop_uid'])) {
            $where_arr[] = 'shop_uid = '.$option['shop_uid'];
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }
//        $sql .= ' order by sort desc';
        $option['page']  = isset($option['page']) ? $option['page'] : 0;
        $option['limit'] = isset($option['limit']) ? $option['limit'] : -1;

        return Dba::readCountAndLimit($sql, $option['page'], $option['limit'],'AddressMod::func_get_address');
//        return Dba::readAllAssoc($sql);
    }
    //根据uid 获取地址
    public static function get_shop_address_by_uid($shop_uid,$uid){
        $sql = 'select * from shop_address where shop_uid = '.$shop_uid.' and uid = '.$uid;
        return Dba::readRowAssoc($sql,'AddressMod::func_get_address');
    }


    /*
    新增或修改地址
    */
    public static function add_or_edit_address($addr) {
        //保证uid存在
        if(!empty($addr['uid'])) {
            $su = Dba::readOne('select shop_uid from shop_address where uid = '.$addr['uid']);
            if($su != $addr['shop_uid']) {
                setLastError(ERROR_PERMISSION_DENIED);
                return false;
            }
        }

        if(!empty($addr['uid'])) {
            Dba::update('shop_address', $addr, 'uid = '.$addr['uid'].' and shop_uid = '.$addr['shop_uid']);
        }
        else {
            Dba::insert('shop_address', $addr);
            $addr['uid'] = Dba::insertID();
        }

        return $addr['uid'];
    }

    /*
    删除地址
    返回删除的条数
    */
    public static function delete_address($aids, $shop_uid) {
        if(!is_array($aids)) {
            $aids = array($aids);
        }
        $sql = 'delete from shop_address where uid in ('.implode(',',$aids).') and shop_uid = '.$shop_uid;
        $ret = Dba::write($sql);

        return $ret;
    }


}