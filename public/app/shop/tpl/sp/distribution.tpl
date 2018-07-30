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

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            开启审核
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label class="am-checkbox">
                <input type="checkbox" id="id_check" data-am-ucheck <?php if(!empty($dtb['need_check'])) echo 'checked';?>>
                新分销用户加入是否需要审核,默认不需要</label>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            返利模式
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="am-radio" style="float: left">
                <label>
                    <input type="radio" name="model-radio" value="0" <?php if($dtb['model']==0) echo 'checked';?>>支付立即返利
                </label>
            </div>
            <div class="am-radio" style="float: left;margin-top: 10px">
                <label>
                    <input type="radio" name="model-radio" value="1" <?php if((!empty($dtb))&&($dtb['model']==1)) echo 'checked';?>>确认收货返利
                </label>
            </div>
        </div>
    </div>

<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">
        购满多少返利
    </div>
    <div class="am-u-sm-4 am-u-end">
        <div style="width: 80%;float:left;">
            <input type="text" id="fullPrice" placeholder="" pattern="^[0-9]+(.[0-9]{1,100})?$" minlength="1" <?php if(!empty($dtb)) echo'value="'.($dtb['fullprice']/100).'"';?>>
        </div>
        <div class="price-yuan">
            元
        </div>
        <small>购物满多少钱,才会获得佣金，填0代表不限制</small>
    </div>
</div>

<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">
        会员专享返利
    </div>
    <div class="am-u-sm-8 am-u-end">
        <label class="am-checkbox">
            <input type="checkbox" id="id_vip" data-am-ucheck <?php if(empty($dtb['need_vip'])) echo 'checked';?>>
            开启</label>
        <small>默认所有申请通过的用户均可享受返利</small>
    </div>
</div>

<div class="am-g am-margin-top-sm">
    <div class="am-u-sm-2 am-text-right">
        状态
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
