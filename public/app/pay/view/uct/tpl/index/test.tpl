
<?php include $tpl_path.'/header.tpl'; ?>

<style>
    .info p{
        font-weight: 400;
        font-size: 1.5em;
    }
</style>

<div class="am-u-sm-12 am-u-sm-centered info">
    <h2>订单信息</h2>
    <hr/>
    <p>订单名称: <a href="<?php echo $info['return_url'];?>"><strong class="am-text-success"><?php echo $info['title']; ?></strong></a></p>
    <p>订单金额: <strong class="am-text-warning">&yen;<?php echo $info['total_fee']/100; ?></strong></p>
    <p>下单时间: <strong><?php echo date('Y-m-d H:i:s', $info['create_time']); ?></strong></p>
    <p>订单详情: <?php echo $info['detail']; ?></p>
    <p>待收款方: <span class="am-text-primary"><?php echo $info['spname']; ?></span></p>
    <p>待付款方: <span class="am-text-primary"><?php echo $info['suname']; ?></span></p>
    <hr/>
    <a class="am-btn am-btn-lg am-btn-success" id="id_test_pay"><span class="am-icon-money"></span> 立即支付</a>
</div>
<?php
//var_export($info);
?>
<div class="am-cf"></div>


<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/amazeui2.1.min.js"></script>
<script src="/static/js/tip.js"></script>
<script>
    var g_uid = '<?php echo $info['trade_no'];?>';
    var g_return_url = '<?php echo $info['return_url'];?>';

    $('#id_test_pay').click(function(){
        var data = {oid: g_uid};
        $.post('?_a=pay&_u=index.test', data, function(ret){
            ret = $.parseJSON(ret);
            if(ret && ret.data)	{
				var url = window.localStorage.pay_return_url;
				if(url) {
					g_return_url = url;
					window.localStorage.removeItem('pay_return_url');
				}
                window.location.replace(g_return_url)
            }
        });
    });

</script>
<?php include $tpl_path.'/footer.tpl'; ?>
