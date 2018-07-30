<?php
if($su_uid = AccountMod::has_su_login()) {
	$last_time= Dba::readOne('select data from book_record where su_uid = '.$su_uid.
				' && data != "" order by uid desc limit 1');
	if(!empty($last_time)) {
		$last_time = json_decode($last_time, true);
	}
	$last_time['预约时间'] = date('Y-m-d\TH:i:s', strtotime('tomorrow +9hour'));
}
?>

<div id="actionSheet_wrap">
    <div class="weui_mask_transition" id="mask"></div>
    <div class="weui_actionsheet" id="weui_actionsheet">
        <div class="weui_cells weui_cells_form">
            <div class="weui_cell" id="id_buy_limit">
				立即预约
            </div>
            <div class="weui_cell caddress2" style="display:none;">
                <div class="weui_cell_hd"><label class="weui_label">兑换数目</label></div>
                <a class="weui_btn weui_btn_default" id="id_minus_quantity"> - </a>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" id="id_quantity" style="text-align:center;" type="number" pattern="[0-9]*" value="1">
                </div>
                <a class="weui_btn weui_btn_default" id="id_add_quantity"> + </a>
            </div>
            <div class="weui_cell caddress">
                <div class="weui_cell_hd"><span style="color:red;float:left;">* </span> <label class="weui_label">姓名</label></div>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" type="text" placeholder="请填写姓名"
                        <?php if(!empty($last_time['姓名'])) echo 'value="'.$last_time['姓名'].'"'; ?>>
                </div>
            </div>
            <div class="weui_cell caddress">
                <div class="weui_cell_hd"><span style="color:red;float:left;">* </span> <label class="weui_label">手机号码</label></div>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" type="number" pattern="[0-9]*" placeholder="请填写手机号码"
                        <?php if(!empty($last_time['手机号码'])) echo 'value="'.$last_time['手机号码'].'"'; ?>>
                </div>
            </div>
            <div class="weui_cell caddress">
                <div class="weui_cell_hd"><span style="color:red;float:left;">* </span> <label class="weui_label">预约时间</label></div>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" type="datetime-local" placeholder="请填写预约时间"
                        <?php if(!empty($last_time['预约时间'])) echo 'value="'.$last_time['预约时间'].'"'; ?>>
                </div>
            </div>
            <div class="weui_cell caddress">
                <div class="weui_cell_hd"><label class="weui_label">备注</label></div>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" type="text" placeholder="请填写备注信息"
                        <?php if(!empty($last_time['备注'])) echo 'value="'.$last_time['备注'].'"'; ?>>
                </div>
            </div>
        </div>
        <div class="weui_actionsheet_action">
            <div class="weui_actionsheet_cell">
                <button class="weui_btn weui_btn_primary" id="id_duihuan_ok" >确定</button>
                <!--                    <button class="weui_btn weui_btn_primary" id="id_pay" style="display: none;margin-top: 0px;">积分不足，使用微信支付</button>-->
            </div>
        </div>
    </div>
</div>
