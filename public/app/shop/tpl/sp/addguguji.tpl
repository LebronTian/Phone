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
</style>
<div class="am-cf am-padding">
    <div class="am-fl am-cf" id="edit-id" <?php if(!empty($data)) echo 'data-id="'.$data['uid'].'"'; ?>>
        <strong class="am-text-primary am-text-lg">  <?php echo(!empty($data) ? '编辑' : '添加')?>打印机</strong> /
    </div>
</div>
<div class="am-form am-form-horizontal" data-am-validator>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            设备名称
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="id_name" minlength="1" <?php if(!empty($data)) echo 'value="'.$data['name'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            AK
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="id_ak" minlength="1" <?php if(!empty($data)) echo 'value="'.$data['ak'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            打印机设备编号
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="memobirdid" minlength="1" <?php if(!empty($data)) echo 'value="'.$data['memobirdid'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            APPID
        </div>
        <div class="am-u-sm-4 am-u-end">
            <input type="text" id="useridentifying" minlength="1" <?php if(!empty($data)) echo 'value="'.$data['useridentifying'].'"'; ?>>
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            打印联数
        </div>
        <div class="am-u-sm-2 am-u-end">
            <input type="text" id="count" minlength="1" <?php if(!empty($data)) echo 'value="'.$data['count'].'"';else echo 'value="1"'; ?>>
        </div>
			<small>可以一个订单打印2联，一联给快递，一联留底</small>
    </div>



    <div class="am-g am-margin-top-sm margin-top">
        <div class="am-u-sm-2 am-text-right">
            状态
        </div>
        <div class="am-u-sm-8 am-u-end" >
            <label class="am-radio am-radio-inline" style="padding-top: 0">
                <input type="radio" name="rad-status" value="1" checked>
                使用
            </label>
            <label class="am-radio am-radio-inline" style="padding-top: 0">
                <input type="radio" name="rad-status" value="0" data-am-ucheck>
				禁用
            </label>
        </div>
    </div>

    <div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button class="am-btn am-btn-secondary" id="saveBiz">保存</button>
            <button style="margin-left:100px;" class="am-btn am-btn-warning" id="id_test"><span class="am-icon-print"></span> 测试打印</button>
        </div>
    </div>
</div>

<?php
    echo '
    <script>
    var data = '.json_encode($data).' ;
    </script>';


    $extra_js = array(
        //'/static/js/catlist_yhc.js',
        $static_path.'/js/addguguji.js',
        );
?>

