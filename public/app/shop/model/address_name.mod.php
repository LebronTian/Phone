<?php


class Address_NameMod {
    public static function func_get_address($item){
        $item['content'] = XssHtml::clean_xss($item['content']);

        return $item;
    }


    //获取全部地址
    public static function get_shop_address_name($shop_uid){

        if(!isset($GLOBALS['arraydb_sys']['add_name'.$shop_uid])){
            $info = array(array('level'=>1,'address'=>'省'),array('level'=>2,'address'=>'市'),array('level'=>3,'address'=>'区'));
            $GLOBALS['arraydb_sys']['add_name'.$shop_uid] = json_encode($info);
        }

        $info = $GLOBALS['arraydb_sys']['add_name'.$shop_uid];

//        var_dump(json_decode($info,true));
        return (json_decode($info,true));

//        $sql = 'select * from shop_address_name';
//        if(!empty($shop_uid)) {
//            $where_arr[] = 'shop_uid = '.$shop_uid;
//        }
//        if(!empty($where_arr)) {
//            $sql .= ' where '.implode(' and ', $where_arr);
//        }
//        $sql .= ' order by level';
//        return Dba::readAllAssoc($sql);

    }

    //更新地址级名称
    public static function update_address($addr){

        $info = json_decode($GLOBALS['arraydb_sys']['add_name'.$addr['shop_uid']],true);

        foreach($info as $k=>$v){
            if($v['level'] == $addr['level']){
                $info[$k]['address'] = $addr['address'];
            }
        }

        $GLOBALS['arraydb_sys']['add_name'.$addr['shop_uid']] = json_encode($info);


        return true;

//        $content['address'] = $addr['address'];
//
//        if(!empty($addr['uid'])){
//            Dba::update('shop_address_name',$addr,'uid = '.$addr['uid'].' and shop_uid ='.$addr['shop_uid']);
//        }else{
//            Dba::insert('shop_address_name', $addr);
//            $addr['uid'] = Dba::insertID();
//        }
//
//
//        return $addr['uid'];
    }

}