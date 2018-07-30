<?php
$free = isset($GLOBALS['arraydb_sys']['shop_discount_'.$shop['uid']]) ? 
		$GLOBALS['arraydb_sys']['shop_discount_'.$shop['uid']] : '';
$free = json_decode($free, true);
?>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"> 全场满减</strong> / <small>全场满减优惠设置</small></div>
</div>
<?php
$html = '';
if($free)
foreach($free as $f) {
$html .= '<div class="am-padding" class="am-text-primary">';
$html .= '<b class="am-text-primary"> 满 </b> ';
$html .= $f['man']/100;
$html .= '<b class="am-text-primary"> 减 </b> ';
$html .= $f['jian']/100;
$html .='<a class="am-btn am-btn-danger am-btn-xs cdel" style="margin-left:50px;" data-id="'.$f['man'].'">删除</a></div>';
}                                
echo $html;
?>  
    
<hr/>
<div class="am-form">
            <div class="am-g am-margin-top-sm">
                 <div class="am-u-sm-6 am-u-end">
					全场订单满&nbsp;
                   <input type="text" class="color" size="6" style="width:10%;display:inline-block;" id="id_man" placeholder="">
					&nbsp;元,
                 <b2> 减&nbsp; </b2>
                   <input type="text" class="color" size="6" style="width:10%;display:inline-block;"  id="id_jian" placeholder="">
					&nbsp;元
                 </div>
            </div>

        <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
          <button class="am-btn am-btn-lg am-btn-primary save">新增全场满减规则
          </button>
        </div>
        </div>
</div>

<?php
$extra_js =  array(
        $static_path.'/js/shop_discount.js',
);
?>

