
<?php include $tpl_path.'/header.tpl'; ?>

<style>
    .info p{
        font-size: large;
    }
</style>
<div class="am-u-lg-8 am-u-md-12 am-u-sm-centered info">
    <div class="am-g">
        <div class="am-u-sm-4">
            <h2>支付宝即时到帐:</h2>
            <hr/>
            <a class="am-btn am-btn-lg am-btn-success" id="id_alipay_direct">点击去支付</a>
            <?php
            //支付未回调, 或者支付过程取消了
            //if(($info['pay_type'] == SpServiceMod::PAY_TYPE_ALIPAY) && !empty($info['pay_info']))
            //echo '<a class="am-btn am-btn-lg am-btn-danger cls_ali_pay_error"><span class="am-icon-warning"></span> 支付遇到问题</a>';
            ?>
        </div>
        <div class="am-u-sm-8">
            <h2>订单信息</h2>
            <hr/>
            <p>订单名称: <a href="<?php echo $info['return_url'];?>"><strong class="am-text-success"><?php echo $info['title']; ?></strong></a></p>
            <p>订单金额: <strong class="am-text-warning">&yen;<?php echo $info['total_fee']/100; ?></strong></p>
            <p>下单时间: <strong><?php echo date('Y-m-d H:i:s', $info['create_time']); ?></strong></p>
            <p>订单详情: <?php echo $info['detail']; ?></p>
            <p>待收款方: <span class="am-text-primary"><?php echo $info['spname']; ?></span></p>
            <p>待付款方: <span class="am-text-primary"><?php echo $info['suname']; ?></span></p>
        </div>
    </div>
    <?php
    //var_export($info);
    ?>
</div>
<div class="am-cf"></div>


<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/amazeui2.1.min.js"></script>
<script src="/static/js/tip.js"></script>
<script>
    var g_uid = '<?php echo $info['trade_no'];?>';
    var g_return_url = '<?php echo $info['return_url'];?>';
    $('#id_alipay_direct').click(function(){
        $.post('?_a=pay&_u=alipay.dodirectpay', {oid:g_uid}, function(ret){
            console.log(ret);
            ret = $.parseJSON(ret);
            if(ret && ret.errno == 0) {
                $('body').append(ret.data);
            }
            //window.location.href=g_return_url;
        });
    });


</script>
<?php include $tpl_path.'/footer.tpl'; ?>