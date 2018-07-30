
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">基本设置</strong> / <small></small></div>
</div>

<div class="am-form">

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            入驻审核
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label style="margin-top: 0.2em" class="am-checkbox">
                <input <?php if(!empty($data)&&(!$data['default_status'])) echo "checked" ?>  id="default-status" type="checkbox"  data-am-ucheck> 需要
            </label>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <p><button class="am-btn am-btn-lg am-btn-primary save-set">保存</button></p>
        </div>
    </div>

</div>

<script>
    var data =<?php echo(!empty($data)? json_encode($data):"null") ?>;
</script>

<?php
$extra_js =  array(
    '/app/shop/static/js/biz_set.js',
);
?>


