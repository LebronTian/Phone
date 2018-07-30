<?php

class DocumentMod{

    public static function func_get_document($item){
        $item['content'] = XssHtml::clean_xss($item['content']);

        return $item;
    }
    /*
    购前须知、红包公告、公告管理
    */
    public static function get_documents_know($option){
        $sql = 'select * from shop_document';

        if(!empty($option['shop_uid'])) {
            $where_arr[] = 'shop_uid = '.$option['shop_uid'];
        }
        if(!empty($option['type_in'])) {
            $where_arr[] = 'type_in = '.$option['type_in'];
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }

        return Dba::readRowAssoc($sql,'DocumentMod::func_get_document');
    }
    /*
    购前须知
    */
    public static function get_before_know($option){
        $sql = 'select * from shop_document';

        if(!empty($option['shop_uid'])) {
            $where_arr[] = 'shop_uid = '.$option['shop_uid'];
        }
        if(!empty($option['type_in'])) {
            $where_arr[] = 'type_in = '.$option['type_in'];
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }

        return Dba::readAllAssoc($sql,'DocumentMod::func_get_document');
    }
    /*
    获取广告
    */
    public static function get_documents_radio($option){
        $sql = 'select * from shop_document';

        if(!empty($option['shop_uid'])) {
            $where_arr[] = 'shop_uid = '.$option['shop_uid'];
        }
        if(isset($option['type_in'])) {
            $where_arr[] = 'type_in = '.$option['type_in'];
        }
        if(!empty($where_arr)) {
            $sql .= ' where '.implode(' and ', $where_arr);
        }

        $option['page']  = isset($option['page']) ? $option['page'] : 0;
        $option['limit'] = isset($option['limit']) ? $option['limit'] : 10;

        return Dba::readCountAndLimit($sql, $option['page'], $option['limit']);
    }

    /*
    根据uid来获取内容；
    */
    public static function get_document_by_uid($document_uid){
        $sql = 'select * from shop_document where uid = '.$document_uid;
        return Dba::readRowAssoc($sql,'DocumentMod::func_get_document');
    }

    /*
    添加或者编辑文案
    */
    public static function add_or_edit_document($document){
        if(!empty($document['uid'])){
            Dba::update('shop_document', $document, 'uid = '.$document['uid'].' and shop_uid = '.$document['shop_uid']);
        }else{
            unset($document['uid']);
            $document['create_time'] = $_SERVER['REQUEST_TIME'];
            Dba::insert('shop_document',$document);
            $document['uid'] = Dba::insertID();
        }

        return $document['uid'];
    }
    /*
        删除广播
    */
    public static function delete_radio($dids){
        if(!is_array($dids)){
            $dids = array($dids);
        }
        $sql = 'delete from shop_document where uid in ('.implode(',',$dids).')';
        $ret = Dba::write($sql);

        return $ret;
    }

}