
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">
            <div class="am-fl am-cf" id="edit-id" <?php if(!empty($address)) echo 'data-id="'.$address['uid'].'"'; ?>>
            <strong class="am-text-primary am-text-lg">  <?php echo(!empty($addr) ? '编辑' : '添加')?>地址</strong> /
    </div>
    </strong> </div>
</div>

<div class="am-form">

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            配送距离
        </div>
        <div class="am-u-sm-2 am-u-end" style="display: flex;">
            <input type="number" id="sendscope" placeholder="必填"  <?php if(!empty($address['address_data']['sendscope'])) echo 'value="'.$address['address_data']['sendscope'].'"';?> >
        </div><small>公里(大于0)</small>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            配送时间
        </div>
        <div class="am-u-sm-2 am-u-end" style="display: flex;">
            <input type="number" id="sendtime" placeholder="必填"  <?php if(!empty($address['address_data']['sendtime'])) echo 'value="'.$address['address_data']['sendtime'].'"';?> >
        </div><small>分钟</small>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            地址
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="address" placeholder="必填" <?php if(!empty($address['address_data']['address'])) echo 'value="'.$address['address_data']['address'].'"';?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            经度
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input type="number" id="p_lng" <?php if(!empty($address['address_data']['lng'])) echo 'value="'.$address['address_data']['lng'].'"';?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            纬度
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input type="number" id="p_lat" <?php if(!empty($address['address_data']['lat'])) echo 'value="'.$address['address_data']['lat'].'"';?>>
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

$extra_js =  array(

        'http://api.map.baidu.com/api?v=2.0&ak=O2TlUoWwlRSpccEMM2Kr5fpZ',
        '/static/js/baidumap/SearchInfoWindow_min.js',
        '/static/js/choose_address.js',
        '/static/js/geo.js',

		'/app/shop/static/js/addaddress.js',
);
?>


