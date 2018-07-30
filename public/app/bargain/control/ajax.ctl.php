<?php
/**
 *砍价
 */
class AjaxCtl {

    /*
     * 砍价商品表
     */
    public function get_bargains(){

        $option['sp_uid'] = AccountMod::require_sp_uid();
        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', -1);
        $option['status'] = requestInt('status', 0);//默认获取进行中商品

        outRight(BargainMod::get_bargainlist($option));
    }

    /*
     * 申请砍价
     */
    public function apply_bargain_by_uid(){

        if(!($option['su_uid'] = AccountMod::has_su_login())) {
            outError(ERROR_USER_HAS_NOT_LOGIN);
        }
        //砍价商品uid
        if(!($option['bargain_uid'] = requestInt('b_uid'))) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        $option['sp_uid'] = AccountMod::require_sp_uid();
        $bargain = BargainMod::get_bargain_by_uid($option['bargain_uid']);
        if(empty($bargain)){
            outError(ERROR_OBJ_NOT_EXIST);
        }
        if(Dba::readOne('select uid from shop_bargain_user where su_uid='.$option['su_uid'].' and bargain_uid='.$option['bargain_uid'])){
            outError(ERROR_OUT_OF_LIMIT);
        }
        $option['current_price'] = $bargain['ori_price'];
        isset($_REQUEST['title']) && $option['title'] = requestString('title');

        outRight(BargainMod::add_or_edit_user_bargain($option));

    }

    /*
     * 获取用户砍价中商品
     */
    public function get_user_bargains(){

        $option['sp_uid'] = AccountMod::require_sp_uid();
        $option['bargain_uid'] = requestInt('b_uid');//砍价商品uid
        $option['status'] = requestInt('status', 0);//默认获取进行中的砍价

        $option['su_uid'] = requestInt('su_uid');//此人的砍价商品

        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', -1);

        outRight(BargainMod::user_bargainlist($option));
    }

    /*
     * 获取砍价详情
     */
    public function get_user_bargain(){
        if(!($b_uid = requestInt('b_uid'))) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        $data['bargain'] = BargainMod::get_bargain_by_uid($b_uid);

        //此人的砍价商品
        $su_uid = requestInt('su_uid');
        if(empty($su_uid)){
            $su_uid = AccountMod::has_su_login();
        }
        if(!empty($su_uid)){
            $data['bargain_user'] = BargainMod::get_bargain_user_by_su_uid($su_uid,$b_uid);
            if(!empty($data['bargain_user'])){
                //帮助列表
                $data['helplist'] = BargainMod::help_bargainlist(array('bu_uid'=>$data['bargain_user']['uid'],'page'=> 0,'limit'=>-1));
                // 检测登录用户是否砍价
                $user_id = AccountMod::has_su_login();
                if(!empty($user_id)){
                    $data['bargain_help'] = BargainMod::get_help_bargain_by_su_bu_uid($user_id,$data['bargain_user']['uid']);
                }

            }
        }

        outRight($data);

    }

    /*
     * 帮忙砍价
     */
    public function help_bargain(){
        if(!($option['su_uid'] = AccountMod::has_su_login())) {
            outError(ERROR_USER_HAS_NOT_LOGIN);
			#$option['su_uid'] = 305539;
        }
        $option['bu_uid'] = requestInt('bu_uid');//砍价中商品
        if(!empty($option['bu_uid'])){
            $bargain_user = BargainMod::get_bargain_user_by_uid($option['bu_uid']);
            $bargain = BargainMod::get_bargain_by_uid($bargain_user['bargain_uid']);
        }else{
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        $had_help = BargainMod::get_help_bargain_by_su_bu_uid($option['su_uid'],$option['bu_uid']);
        if(!empty($had_help)){
            //已砍过此砍价  todo  暂时去掉限制 
            outError(ERROR_OBJECT_ALREADY_EXIST);
        }
        //帮砍了多少钱
        if(empty($bargain)){
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        //超过砍价次数
        if(!empty($bargain['rule']['times'])&&($bargain_user['support_cnt']>=$bargain['rule']['times'])){
            outError(ERROR_OUT_OF_LIMIT);
        }
        //已砍到最低价
        if($bargain_user['current_price']<=$bargain['lowest_price']){
            outError(ERROR_OUT_OF_LIMIT);
        }
        //状态为1   已过期
        if($bargain_user['status']){
            outError(ERROR_BAD_STATUS);
        }

		$cnt = Dba::readOne('select count(*) from shop_bargain_help where bu_uid = '.$bargain_user['uid']);
		if($bargain['rule']['times'] - $cnt <= 1) {
            $option['bargain_fee'] = $bargain_user['current_price']-$bargain['lowest_price'];
		} else {
			$avg = ($bargain_user['current_price']-$bargain['lowest_price']) / ($bargain['rule']['times'] - $cnt);
			$option['bargain_fee'] = rand(1, min($avg*2, ($bargain_user['current_price'] - $bargain['lowest_price'] - ($bargain['rule']['times'] - $cnt))));
		}
        //砍价规则，待更新完善
		/*
        if($bargain['rule']['times']<=10&&$bargain['rule']['times']>0){
            $max_fee=($bargain['ori_price']-$bargain['lowest_price'])/$bargain['rule']['times'];
            $option['bargain_fee'] = mt_rand($max_fee-100,$max_fee);
        }else{
            #$max_fee=($bargain['ori_price']-$bargain['lowest_price'])/10;
            $max_fee=($bargain_user['current_price']-$bargain['lowest_price'])/10;
            $option['bargain_fee'] = mt_rand(10,$max_fee);
        }
		*/


        //计算现价
        $current_price = $bargain_user['current_price']-$option['bargain_fee'];
        if($current_price<=$bargain['lowest_price']){
            $current_price = $bargain['lowest_price'];
        }
        $data['success'] = BargainMod::add_help_bargain($option,$current_price);

        $data['k_fee'] = $option['bargain_fee'];

        outRight($data);
    }


    /*
     *砍价图片
    */
    public function card_image() {
        $g_width = 734;
        $g_height = 1280;
        $g_imgheight = $g_width * 0.8;

        if((!$su_uid = requestInt('su_uid')) && (!$su_uid = AccountMod::has_su_login())) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        if(!$uid = requestInt('uid')){
            outError(ERROR_INVALID_REQUEST_PARAM);
        }


        $bargain_user = BargainMod::get_bargain_user_by_su_uid($su_uid,$uid);
        if(empty($bargain_user)){
            outError(ERROR_OBJ_NOT_EXIST);
        }
        $bargain = BargainMod::get_bargain_by_uid($uid);
        //$sp_uid = AccountMod::get_current_service_provider('uid'); 小程序端没传sp_uid
		$sp_uid = $bargain['sp_uid'];
		AccountMod::set_current_service_provider($sp_uid);
		$_GET['uct_token'] = Dba::readOne('select uct_token from service_provider where uid = '.$sp_uid);

        $etag = md5($su_uid.json_encode($bargain));
        if(0&&isset($_SERVER['HTTP_IF_NONE_MATCH']) && $_SERVER['HTTP_IF_NONE_MATCH'] == $etag) {
            header('Cache-Control: public');
            header('Etag: '.$etag);
            header("HTTP/1.1 304 Not Modified");
            exit();
        }

        $key = 'bargain_card_img';
//mark todo 用户设置底图过小
        if(0&&!empty($GLOBALS['arraydb_sys'][$key])){
            $info = json_decode($GLOBALS['arraydb_sys'][$key],true);
            $public_uid = $info['public_uid'];
            uct_use_app('upload');
            $bg = UploadMod::get_file_dst_by_url($info['url']);
        }else{
            $public_uid = WeixinMod::get_current_weixin_public('uid');
            $bg = UCT_PATH.'app/bargain/static/images/bg.png';
        }

        $option = array(
            'back_ground' => array('path' => $bg),
        );

        $url1 =  'http://'.$_SERVER['HTTP_HOST'].$bargain['product_info' ]['img'];
        $url2 = DomainMod::get_app_url('bargain',$sp_uid,'_u=xiaochengxu.qrcode&path='.urlencode('/page/index/pages/bargain/bargain?id='.$uid.'&parentId='.$su_uid).'&public_uid='.$public_uid);


		#echo $url2;die;
        $ret = json_decode(curl_file_get_contents($url2),true);
        if((!isset($ret['errcode']))&&$ret['errcode']!= 40001){
            //小程序码
            $option['image'][] = array(
                'data' => curl_file_get_contents($url2),
                'size' => array(200, 200),
                'point' => array(35, $g_imgheight + 400),
            );
        }

        //商品图
        $option['image'][] = array(
            'data' => curl_file_get_contents($url1),
            #'size' => array(280, 280),
            #'point' => array(0, $g_imgheight + 426),
            'size' => array($g_width, 500),
            'point' => array(0, 0),
        );

        $option['string'][] = array(
            'content' => $bargain['title'],
            'size' => 40,
            'point' => array(61, $g_imgheight),
            'color' => '#000000',
        );


        $option['string'][] = array(
            'content' => '原价：￥'.sprintf('%.2f',$bargain['ori_price']/100),
            'size' => 20,
            'point' => array(61, $g_imgheight + 100),
            'color' => '#000000',
        );

        $option['string'][] = array(
            'content' => '最低砍购价：'."\n￥".sprintf('%.2f',$bargain['lowest_price']/100),
            'size' => 30,
            'point' => array(61, $g_imgheight + 200),
            'color' => '#000000',
        );

		#(print_r($option));die;

        include_once UCT_PATH . 'vendor/images/image.php';
        $ii = getImageineInstance();
        $img = $ii->create_vip_card($option);
        header('Content-Type: image/png');
        header('Cache-Control: public');
        header('Etag: '.$etag);
        echo $img;
        return;
    }

}
