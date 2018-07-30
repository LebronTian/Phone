
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">商品分销管理</strong> / <small></small></div>
</div>

<div class="am-form">

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-3 am-text-right">
            商品uid
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="p_uid" <?php if(!empty($dtb['p_uid'])) echo 'value="'.$dtb['p_uid'].'"';?>>
        </div>
    </div>

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
        状态
    </div>
    <div class="am-u-sm-8 am-u-end">
        <label class="am-checkbox">
            <input type="checkbox" id="id_status" data-am-ucheck <?php if(empty($dtb['status'])) echo 'checked';?>>
            开启商品分销</label>
    </div>
</div>-->


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
    $static_path .'/js/adddistribution_product.js'
);
?>
