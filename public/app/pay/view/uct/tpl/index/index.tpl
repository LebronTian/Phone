
<?php include $tpl_path.'/header.tpl'; ?>

<style>
    .info p{font-size: large;}
</style>
<link rel="stylesheet" href="/app/pay/view/uct/pay.css">
<div class="am-u-lg-8 am-u-md-12 am-u-sm-centered info">
    <div class="am-g">
        <div class="am-u-sm-4 left-box">
            <?php
            //var_export($info);
            ?>
            <h2>请选择支付方式:</h2>
            <hr/>
            <?php
            
            if($info['paid_time']) {
                //已支付
                $html = '<p><a href="'.$info['return_url'].'" class="am-btn am-btn-lg am-btn-success"><span class="am-icon-check"></span> 已付款</a>
      <p>付款时间: <strong>'.date('Y-m-d H:i:s', $info['paid_time']).'</strong></p>';
                $html .='<p>付款方式: ';
                if($info['pay_type'] == SpServiceMod::PAY_TYPE_WEIXINPAY) {
                    $html .= '<button class="am-btn am-btn-primary am-btn-sm"><span class="am-icon-weixin"></span> 微信支付</button>';
                }
                else if($info['pay_type'] == SpServiceMod::PAY_TYPE_TESTPAY) {
                    $html .= '<button class="am-btn am-btn-primary am-btn-sm"><span class="am-icon-money"></span> 测试支付</button>';
                }
                else if($info['pay_type'] == SpServiceMod::PAY_TYPE_ALIPAY) {
                    $html .= '<button class="am-btn am-btn-primary am-btn-sm"><span class="am-icon-shield"></span> 支付宝</button>';
                }
                else if($info['pay_type'] == SpServiceMod::PAY_TYPE_BALANCEPAY) {
                    $html .= '<button class="am-btn am-btn-primary am-btn-sm"><span class="am-icon-credit-card"></span> 余额支付</button>';
                }
                else {
                    $html .= '未知';
                }
                $html .= '<p>';

            }
            else {
                $html = '';
                //根据商户配置情况显示不同的支付方式
				
                if(PayMod::is_sp_weixinpay_available($info['sp_uid'])) {
					//代收款按二维码支付
                	if(PayMod::is_sp_uctpay_available($info['sp_uid'])) {
		                if(!isWeixinBrowser() ||
						(($info['pay_type'] == SpServiceMod::PAY_TYPE_WEIXINPAY) && !empty($info['pay_info']))) {
       		             $html .= '<p><a href="?_a=pay&_u=index.wxnative2&oid='.$info['trade_no'].
'" class="cpaytype cwxnative2 am-btn am-btn-lg am-btn-primary"><span class="am-icon-weixin"></span> 微信支付 (扫码)</a></p>';
						}
						if(isWeixinBrowser()) {
						//if(in_array($info['su_uid'], array('95067'))) 
       		   		          $html .= '<p><a href="?_a=pay&_u=index.wxjs&oid='.$info['trade_no'].
'" class="cpaytype cwxjs am-btn am-btn-lg am-btn-primary"><span class="am-icon-weixin"></span> 微信支付 (jssdk)</a></p>';
						}
					}
					else {
		                if(!isWeixinBrowser() ||
						(($info['pay_type'] == SpServiceMod::PAY_TYPE_WEIXINPAY) && !empty($info['pay_info']))) {
       		             $html .= '<p><a href="?_a=pay&_u=index.wxnative2&oid='.$info['trade_no'].
'" class="cpaytype cwxnative2 am-btn am-btn-lg am-btn-primary"><span class="am-icon-weixin"></span> 微信支付 (扫码)</a></p>';
						}

		                if(isWeixinBrowser() || (defined('DEBUG_WXPAY') && DEBUG_WXPAY)) {
       		   		          $html .= '<p><a href="?_a=pay&_u=index.wxjs&oid='.$info['trade_no'].
'" class="cpaytype cwxjs am-btn am-btn-lg am-btn-primary"><span class="am-icon-weixin"></span> 微信支付 (jssdk)</a></p>';
						}
					}

                //微信支付未回调, 或者支付过程取消了
                if(($info['pay_type'] == SpServiceMod::PAY_TYPE_WEIXINPAY) && !empty($info['pay_info'])) {
                    $html .= '<a class="cpaytype cwxerror am-btn am-btn-lg am-btn-danger cls_weixin_pay_error"><span class="am-icon-warning"></span> 微信支付遇到问题</a>';
				}

				}

                if(PayMod::is_sp_alipay_available($info['sp_uid'])) {
                $html .= '<p><a href="?_a=pay&_u=index.alipaydirect&oid='.$info['trade_no'].
'" class="cpaytype calipaydirect am-btn am-btn-lg am-btn-primary"><span class="am-icon-shield"></span> 支付宝 (即时到帐)</a></p>';
				}

                //测试支付
                if(PayMod::is_sp_testpay_available($info['sp_uid']) || (defined('DEBUG_WXPAY') && DEBUG_WXPAY)) {
                    $html .= '<p><a href="?_a=pay&_u=index.test&oid='.$info['trade_no'].
 '" class="cpaytype ctest am-btn am-btn-lg am-btn-primary"><span class="am-icon-money"></span> 测试支付 </a></p>';
				}

                //余额支付
                if(PayMod::is_sp_balancepay_available($info['sp_uid'])) {
                    $html .= '<p><a href="?_a=pay&_u=index.balance&oid='.$info['trade_no'].
 '" class="cpaytype cbalance am-btn am-btn-lg am-btn-primary"><span class="am-icon-credit-card"></span> 余额支付 </a></p>';
				}

            }

            echo $html;
            ?>
        </div>
        <div class="am-u-sm-8 right-box">
            <h2>订单信息</h2>
            <hr/>
            <p>订单名称: <a href="<?php echo $info['return_url'];?>"><strong class="am-text-success"><?php echo $info['title']; ?></strong></a></p>
            <p>订单金额: <strong class="am-text-warning">&yen;<?php echo $info['total_fee']/100; ?></strong></p>
            <p>下单时间: <strong><?php echo date('Y-m-d H:i:s', $info['create_time']); ?></strong></p>
            <p>待收款方: <span class="am-text-primary"><?php echo $info['spname']; ?></span></p>
            <p>待付款方: <span class="am-text-primary"><?php echo $info['suname']; ?></span></p>
        </div>
    </div>

    <script src="/static/js/jquery2.1.min.js"></script>
    <script src="/static/js/amazeui2.1.min.js"></script>
    <script src="/static/js/tip.js"></script>
    <script>
        var g_uid = '<?php echo $info['trade_no'];?>';
        var g_return_url = <?php echo json_encode($info['return_url']);?>;
		var g_autopay = <?php echo json_encode(requestString('autopay', PATTERN_NORMAL_STRING))?>;
		
        $('.cls_weixin_pay_error').click(function(){
            var data = {oid: g_uid};
            $.post('?_a=pay&_u=weixin.update_order', data, function(ret){
                console.log(ret);
                ret = $.parseJSON(ret);
                if(ret.data) {
					//交给前端处理
					var url = window.localStorage.pay_return_url;
					if(url) {
						g_return_url = url;
						window.localStorage.removeItem('pay_return_url');
					}
                    window.location.replace(g_return_url);//15.11.17,返回按钮优化
                }
                else {
                    alert('微信订单查询失败! 请联系客服!');
                }
            });
        });
		
		/*
			自动跳转
		*/
		if(g_autopay) {
			window.location.href = $('.c'+g_autopay).attr('href');
		}	
		if($('.cpaytype').length == 1) {
			window.location.href = $('.cpaytype').attr('href');
		}
		
    </script>

</div>

<?php include $tpl_path.'/footer.tpl'; ?>
