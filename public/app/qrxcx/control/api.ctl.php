<?php

class ApiCtl {

    /*
    添加编辑海报
    */
    public function addxcxposter() {
        isset($_REQUEST['photo_info']) && $qp['photo_info'] = requestKvJson('photo_info');
        isset($_REQUEST['reward_info']) && $qp['reward_info'] = requestKvJson('reward_info');
        isset($_REQUEST['notice_info']) && $qp['notice_info'] = requestKvJson('notice_info');
        isset($_REQUEST['status']) && $qp['status'] = requestInt('status');

        if(empty($qp)) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        if(!empty($_REQUEST['uid'])) {
            $qp['uid'] = requestInt('uid');
        }

        isset($_REQUEST['public_uid']) && $qp['public_uid'] = requestInt('public_uid');
        if(!isset($qp['public_uid'])){
            $qp['public_uid'] = WeixinMod::get_current_weixin_public('uid');
        }
        if(!$qp['public_uid']) {
            unset($qp['public_uid']);
        }
        $qp['sp_uid'] = AccountMod::get_current_service_provider('uid');

        outRight(XcxposterMod::add_or_edit_xcxposter($qp));
    }

    /*
        删除海报
    */
    public function delqrposter() {
        if(!$uids = requestIntArray('uids')) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        $sp_uid = AccountMod::get_current_service_provider('uid');

        outRight(XcxposterMod::delete_xcxposter($uids, $sp_uid));
    }


}
