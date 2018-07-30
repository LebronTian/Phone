<?php
/*
	配送员订单
*/

class DeliveriesMod {
    public static function func_get_deliveries($item) {
        $item['title'] = htmlspecialchars($item['title']);
        $item['content'] = XssHtml::clean_xss($item['content']);
        return $item;
    }
    /*
        获取配送员订单列表
    */
    public static function get_deliveries($option = null){
        $sql = 'select od.uid,od.su_uid,od.order_uid,od.create_time,su.name from shop_order_delivery as od' . ' left join  service_user as su on od.su_uid=su.uid' ;
        if(!empty($option['uid'])) {
            $where_arr[] = 'uid = '.$option['uid'];
        }
        if(!empty($option['su_uid'])) {
            $where_arr[] = 'su_uid = '.$option['su_uid'];
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }
        $sort = ' order by od.create_time desc';
        $sql .= $sort;

        $option['page']  = isset($option['page']) ? $option['page'] : 0;
        $option['limit'] = isset($option['limit']) ? $option['limit'] : 10;

        return Dba::readCountAndLimit($sql, $option['page'], $option['limit']);

//        return Dba::readAllAssoc($sql);
    }
    /*
    获取配送员信息
    */
    public static function get_deliveries_user($su_uid = null){
        $sql = 'select * from service_user';
        if(!empty($option['$su_uid'])) {
            $where_arr[] = 'uid = '.$option['uid'];
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }
        $sort = ' order by uid desc';
        $sql .= $sort;

        return Dba::readAllAssoc($sql);
    }
    /*
        获取配送员订单列表
    */
    public static function get_deliveries_by_uid($uid){
        $sql = 'select so.uid,so.su_uid,so.order_uid,su.name,su.avatar from shop_order_delivery as so ' . ' left join  service_user as su on so.su_uid=su.uid' ;;
        if(!empty($uid)) {
            $where_arr[] = 'so.uid = '.$uid;
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }
        $sort = ' order by uid desc';
        $sql .= $sort;

        return Dba::readRowAssoc($sql);
    }
    /*
    添加或修改配送员订单
    */
    public static function add_or_edit_deliveries($product){
        $sql = 'select uid from shop_order_delivery where order_uid = '.$product['order_uid'];
        if(Dba::readOne($sql)){
            return false;
        }
        //保证uid存在
        if(!empty($product['uid'])) {
            Dba::update('shop_order_delivery', $product, 'uid = '.$product['uid']);
        }
        else {
            $product['create_time'] = time();
            Dba::insert('shop_order_delivery', $product);
            $product['uid'] = Dba::insertID();
        }

        return $product['uid'];
    }

    /*
    删除配送员订单
    返回删除的条数
    */
    public static function delete_deliveries($aids) {
        if(!is_array($aids)) {
            $aids = array($aids);
        }
        $sql = 'delete from shop_order_delivery where uid in ('.implode(',',$aids).')';
        $ret = Dba::write($sql);

        return $ret;
    }



}

