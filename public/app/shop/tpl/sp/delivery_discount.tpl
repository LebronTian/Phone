<?php
$rule = isset($GLOBALS['arraydb_sys']['delivery_discount_'.$shop['uid']]) ? 
		$GLOBALS['arraydb_sys']['delivery_discount_'.$shop['uid']]: '';
$rule = $rule ? json_decode($rule, true) : array();
?>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"> 全场包邮设置</strong> / <small>包邮规则</small></div>
</div>

<div class="am-form">
            <div class="am-g am-margin-top-sm">
                 <div class="am-u-sm-2 am-text-right">
                 订单满多少元包邮
                 </div>
                 <div class="am-u-sm-2 am-u-end">
                   <input type="text" class="color" size="6" id="id_fee" <?php  if(!empty($rule['free_fee'])) echo 'value="'. ($rule['free_fee']/100).'"';?>>
                        <small>0表示不包邮</small>
                 </div>
            </div>

            <div class="am-g am-margin-top-sm">
                 <div class="am-u-sm-2 am-text-right">
                 订单满多少件包邮
                 </div>
                 <div class="am-u-sm-2 am-u-end">
                   <input type="text" class="color" size="6" id="id_cnt" <?php  if(!empty($rule['free_cnt'])) echo 'value="'. $rule['free_cnt'].'"';?>>
                        <small>0表示不包邮</small>
                 </div>
            </div>

        <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
          <button class="am-btn am-btn-lg am-btn-primary save">保存
          </button>
        </div>
        </div>
</div>

<?php
$extra_js =  array(
        $static_path.'/js/delivery_discount.js',
);
?>

