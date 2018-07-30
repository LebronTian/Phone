<style>
    .price-yuan {
        width: 20%;
        float: left;
        font-size: large;
        padding-left: 20px;
        height: 43px;
        line-height: 38px;
    }
</style>
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">分销管理</strong> / <small></small></div>
</div>
<hr>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><small>返利比例&模式</small></div>
</div>

<div class="am-form">
    <?php
    $html ='';
    $user_arr = array('购买者拿到的佣金','购买者上级拿到的佣金','购买者上上级拿到的佣金','购买者上上上级拿到的佣金');
    for($i =0;$i<=3;$i++)
    {
        $html .= '<div class="am-g am-margin-top-sm distribution"><div class="am-u-sm-3 am-text-right">'.$user_arr[$i].'</div><div class="am-u-sm-4 am-u-end">';
        $html .= '<input type="number" id="id_weight" min="0" max="100" step="0.01" placeholder="请填写返利比例 0-100" value="';
        $html .= (!isset($dtb['rule_data'][$i][0])?'':sprintf('%.2f',$dtb['rule_data'][$i][0]/100));
        $html .= '"><small >0-100，支付金额的百分比为佣金，0表示无比例佣金</small></div>';
	    $html .= '<div class="am-u-sm-1 am-u-end"> + </div><div class="am-u-sm-3 am-u-end">';
	    $html .= '<input type="number" id="id_fix" min="0"  step="0.01" placeholder="请设置固定佣金" value="';
	    $html .= (!isset($dtb['rule_data'][$i][1])?'':sprintf('%.2f',$dtb['rule_data'][$i][1]/100));
	    $html .= '"><small >固定分红，单元（元），0表示无固定佣金</small></div></div>';
    }
    echo $html;
    ?>

<hr>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            返利时机
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-radio" style="">
                <label>
                    <input type="radio" name="model-radio" value="0" <?php if($dtb['model']==0) echo 'checked';?>>付款成功后立即返利
                </label>
            </div>
            <div class="am-radio" style="margin-top: 10px">
                <label>
                    <input type="radio" name="model-radio" value="1" <?php if((!empty($dtb))&&($dtb['model']==1)) echo 'checked';?>>确认收货后才进行返利
                </label>
            </div>
        </div>
    </div>

<!--<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">
        成为分销商名称设置
    </div>
    <div class="am-u-sm-8 am-u-end">
        <label class="am-checkbox">
            <input type="text" id="group_name"  placeholder="请填写组名" value=""/>
       </label>
    </div>
</div>-->

<hr>
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><small>参与门槛设置</small></div>
</div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            需要人工审核
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label class="am-checkbox">
                <input type="checkbox" id="id_check" data-am-ucheck <?php if(!empty($dtb['need_check'])) echo 'checked';?>>
                新用户需要后台审核才能拥有分销资格</label>
        </div>
    </div>

<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">
        仅限会员
    </div>
    <div class="am-u-sm-8 am-u-end">
        <label class="am-checkbox">
            <input type="checkbox" id="id_vip" data-am-ucheck <?php if(empty($dtb['need_vip'])) echo 'checked';?>>
            必须先成为系统会员才有分销返利资格</label>
        <small></small>
    </div>
</div>


<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">
        小额订单不返利
    </div>
    <div class="am-u-sm-4 am-u-end">
        <div style="width: 80%;float:left;">
            <input type="text" id="fullPrice" placeholder="" pattern="^[0-9]+(.[0-9]{1,100})?$" minlength="1" <?php if(!empty($dtb)) echo'value="'.($dtb['fullprice']/100).'"';?>>
		元, 超过多少金额的订单才会进行分佣，填0代表不限制
        </div>
        <small></small>
    </div>
</div>

<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">
        开关
    </div>
    <div class="am-u-sm-8 am-u-end">
        <label class="am-checkbox">
            <input type="checkbox" id="id_status" data-am-ucheck <?php if(empty($dtb['status'])) echo 'checked';?>>
            开启分销系统</label>
    </div>
</div>


    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>
        </div>
    </div>

</div>

<?php
echo '<script>var uid = '.(empty($dtb['uid'])?0:$dtb['uid']).';</script>';
$extra_js =  array(
    $static_path .'/js/distribution.js'
);
?>
