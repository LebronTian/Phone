<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>
<link rel="stylesheet" href="/static/css/select_user.css"/>
<link rel="stylesheet" href="/app/shop/static/css/addproduct.css"/>
<style>
    .extra-box{
        margin-top: 1em;
    }
    #extra-input{
        display: inline-block;
    }
    #main-img {
         max-width: 200px;
    }
</style>
<div class="am-cf am-padding">
    <div class="am-fl am-cf" id="edit-id">
        <strong class="am-text-primary am-text-lg">添加设置分销成员</strong> /
    </div>
</div>
<div class="am-form am-form-horizontal" data-am-validator>
    <div class="am-g am-margin-top-sm">
<?php 
if(!empty($su)) {
?>
        <div class="am-u-sm-2 am-text-right">
            用户
        </div>
        <div class="am-u-sm-4 am-u-end select-user-box">
<p data-uid="<?php echo $su['uid']?>" class="select2-selection__choice"><?php echo $su['name'] ? $su['name'] : $su['account']; ?></p>
        </div>

<?php } else {
?>
        <div class="am-u-sm-2 am-text-right">
            选择用户
        </div>
        <div class="am-u-sm-4 am-u-end select-user-box">
            <select class="more-user" multiple="multiple">
            </select>
            <button style="margin-top: 0.5em" class="select-user am-btn am-btn-secondary am-btn-sm">选择用户</button>
        </div>
<?php } ?>
    </div>


    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            状态
        </div>
        <div class="am-u-sm-8 am-u-end" >
            <label class="am-radio am-radio-inline" style="padding-top: 0">
                <input type="radio" name="rad-status" value="1" <?php if(empty($dtb['status']) || $dtb['status'] != 2) echo 'checked'; ?>>
                通过
            </label>
            <label class="am-radio am-radio-inline" style="padding-top: 0">
                <input type="radio" name="rad-status" value="2" <?php if(!empty($dtb['status']) && $dtb['status'] == 2) echo 'checked'; ?> data-am-ucheck>
				拒绝
            </label>
        </div>
    </div>

<hr>
<div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
	<span class="am-icon-info"></span> 您可以为指定用户设置一个不同的返利比例, 留空则使用默认分成比例
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

<hr>
    <div class="am-g am-margin-top-sm" style="margin: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="am-btn am-btn-secondary" id="saveBiz">保存</button>
        </div>
    </div>
</div>

<!--虚拟弹窗-->
<div class="am-popup" id="user-popup">
    <div class="am-popup-inner">
        <div class="am-popup-hd">
            <h4 class="am-popup-title">用户列表</h4>
            <span data-am-modal-close class="am-close">&times;</span>
        </div>
        <div class="am-form">
            <input class="" type="text" placeholder="搜索">
        </div>
        <div style="padding-bottom: 3em" class="am-popup-bd">

        </div>
        <div class="user-list-foot">
            <span>取消</span><span>确定</span>
        </div>
    </div>
</div>

<?php
    $extra_js = array(
        '/static/js/ueditor/ueditor.config.js',
        '/static/js/ueditor/ueditor.all.js',
        '/static/js/select2/js/select2.min.js',

        $static_path.'/js/distribution_user_set.js',
        );
?>

