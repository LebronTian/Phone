<?php


class ActivityMod {
    public static function func_get_activity($item){
        $item['content'] = XssHtml::clean_xss($item['content']);

        return $item;
    }
    public static function func_get_document($item){
        $item['content'] = XssHtml::clean_xss($item['content']);

        return $item;
    }

    /*
    新增或修改活动
    */
    public static function add_or_edit_activity($product) {

        //保证uid存在
        if(!empty($product['uid'])) {
            $su = Dba::readOne('select shop_uid from shop_activity where uid = '.$product['uid']);
            if($su != $product['shop_uid']) {
                setLastError(ERROR_PERMISSION_DENIED);
                return false;
            }
        }

        if(!empty($product['uid'])) {
            Dba::update('shop_activity', $product, 'uid = '.$product['uid'].' and shop_uid = '.$product['shop_uid']);
        }
        else {
            Dba::insert('shop_activity', $product);
            $product['uid'] = Dba::insertID();
			
        }

        return $product['uid'];
    }

    /*
    删除活动
    返回删除的条数
    */
    public static function delete_activities($aids, $shop_uid) {
        if(!is_array($aids)) {
            $aids = array($aids);
        }
        $sql = 'delete from shop_activity where uid in ('.implode(',',$aids).') and shop_uid = '.$shop_uid;
        $ret = Dba::write($sql);

        return $ret;
    }




    //获取全部商店活动
    public static function get_shop_activity($option){
        $sql = 'select * from shop_activity';

        if(!empty($option['shop_uid'])) {
            $where_arr[] = 'shop_uid = '.$option['shop_uid'];
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }

        $sql .= ' order by start_time desc';
        $option['page']  = isset($option['page']) ? $option['page'] : 0;
        $option['limit'] = isset($option['limit']) ? $option['limit'] : 10;

        return Dba::readCountAndLimit($sql, $option['page'], $option['limit']);
//        return Dba::readAllAssoc($sql);

    }
    /*
    获取所有活动详情；
    */
    public static function get_activity($item){
        $sql = 'select * from product where uid in ('.$item['p_uid'].')';

        return Dba::readAllAssoc($sql,'ActivityMod::func_get_activity');
    }
    /*
    获取所有活动内容；
    */
    public static function get_activity_all(){

        $sql = 'select * from shop_activity';

        return Dba::read($sql,'ActivityMod::func_get_activity');

    }
    /*
    获取不同类型活动内容；
    */
    public static function get_activity_by_type($type){

        $sql = 'select * from shop_activity where type ='.$type;

        $option = Dba::readAllAssoc($sql,'ActivityMod::func_get_activity');
        //搜索额外信息
        foreach($option as $k => $va){
            if(!empty($va['p_uid'])) {
                $option[$k]['product'] = self::get_activity($va);
            }
        }

        return $option;

    }
    /*
    根据商店获取活动内容；
    */
    public static function get_activity_by_sp_uid($sp_uid){

        $sql = 'select * from shop_activity where shop_uid = '.$sp_uid;

        return Dba::readAllAssoc($sql,'ActivityMod::func_get_activity');
    }

    /*
        活动详情
    */
    public static function get_shop_activity_by_uid($uid) {
        $sql = 'select * from shop_activity ';
        if(!empty($uid)) {
            $where_arr[] = ' uid =' . $uid;
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }

//		var_dump(__file__.' line:'.__line__,$sql);exit;
        return Dba::readRowAssoc($sql);
    }

    /*
    获取所有文案内容
    */
    public static function get_document_all(){
        $sql = 'select * from service_document';
        return Dba::readAllAssoc($sql,'ActivityMod::func_get_document');
    }

    /*
    根据商品文案的uid来获取内容；
    */
    public static function get_document_by_uid($document_uid){
        $sql = 'select * from service_document where uid = '.$document_uid;
        return Dba::readRowAssoc($sql,'ActivityMod::func_get_document');
    }


    public static function get_document_by_sp_uid($sp_uid){
         $sql = 'select * from service_document where uid = '.$sp_uid;
        return Dba::readAllAssoc($sql,'ActivityMod::func_get_document');
    }




}