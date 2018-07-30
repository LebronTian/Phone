    <style>
    .am-tabs-d2 .am-tabs-nav li{
        background: white;
        border-bottom: 2px solid #eeeeee;
    }
    .am-tabs-d2 .am-tabs-nav{
        background: white;
    }
    .address-div p{
        margin: 0.3em 0;
    }
    .address-div p:first-child{
        margin-top: 0;
    }
    .head-img{
        width: 5em;
        height: 5em;
        border-radius: 50%;
        margin-left: 0.5em;
    }
    #chef-map{
        width: 100%;
        height: 20em;
    }
</style>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm-delivery">
    <div class="am-modal-dialog ">
        <div class="am-modal-hd">配送信息</div>
        <hr/>
        <form class="am-form am-form-horizontal">

            <div class="am-form-group">
                <label class="am-u-sm-3 am-form-label" for="id_courier_name">快递公司</label>
                <div class="am-u-sm-9">
                    <select id="id_courier_name">
                        <option value="EMS">EMS</option>
                        <option value="顺丰">顺丰</option>
                        <option value="申通">申通</option>
                        <option value="圆通">圆通</option>
                        <option value="申通">申通</option>
                        <option value="中通">中通</option>
                        <option value="汇通">汇通</option>
                        <option value="天天">天天</option>
                        <option value="韵达">韵达</option>
                        <option value="全峰">全峰</option>
                        <option value="中国邮政">中国邮政</option>
                        <option value="邮政平邮">邮政平邮</option>
                        <option value="港中能达">港中能达</option>
                        <option value="宅急送快递">宅急送快递</option>
                        <option value="-1">其他</option>
                    </select>
                    <input id="id_courier_name2"  class="am-form-field" style="display: none">
                </div>
            </div>
            <div class="am-form-group">
                <label class="am-u-sm-3 am-form-label" for="id_courier_no">快递单号</label>
                <div class="am-u-sm-9">
                    <input id="id_courier_no" class="am-form-field">
                </div>
            </div>

        </form>

        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-confirm>确定</span>
            <span class="am-modal-btn" data-am-modal-cancel>取消</span>
        </div>
    </div>
</div>

<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">订单详情</strong> / <small></small></div>
</div>

<p style="padding-left: 1.6rem;color: #0e90d2;margin-top: 0">
    <span style="padding: 0.5em;background: #0e90d2;color: white">状态</span>
    <span style="font-size: larger;font-weight: bold">
    <?php
    if(!empty($order)){
        switch ($order['status']){
            case 1:
                echo '待付款';
				if(!empty($order['pay_info'])) {
					echo ' <a class="am-icon-refresh am-btn am-text-success" id="id_update_order" data-id="'.$order['uid'].'" data-am-popover="{content: \'如果订单一直处于待付款状态，可以手动刷新一下\', trigger: \'hover focus\'}"></a>';
				}
                break;
            case 2:
                echo '待发货';
                break;
            case 3:
                echo '待收货';
                break;
            case 4:
                echo '已收货';
                break;
            case 5:
                echo '已评论';
                break;
            case 6:
                echo '已退款';
                break;
            case 8:
                echo '协商中';
                break;
            case 9:
                echo '卖家取消';
                break;
            case 10:
                echo '已取消';
                break;
            case 11:
                echo '待卖家确认';
                break;
        }
    }
    ?>
    </span>

	<a id="id_print" style="margin-left:30px;" class="am-btn am-btn-lg am-btn-warning"><span class="am-icon-print"></span> 打印订单</a>
</p>
<div id="id_print_area" class="am-g am-padding" style="padding-top: 0">
    <div data-am-widget="tabs" class="am-tabs am-tabs-d2 my-tab" data-am-tabs-noswipe="1">
        <ul class="am-tabs-nav am-cf">
            <li class="am-active">
                <a href="[data-tab-panel-0]">基本资料</a>
            </li>
            <li class="">
                <a href="[data-tab-panel-1]">买家资料</a>
            </li>
        </ul>
        <div class="am-tabs-bd">
            <div data-tab-panel-0 class="am-tab-panel am-active">
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        订单号：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php if(!empty($order)) echo $order['uid']; ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        订单创建时间：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php if(!empty($order)) echo date("Y年m月d日 H:i:s",$order['create_time']); ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        商品信息：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <table class="am-table am-table-striped am-table-hover" style="margin-bottom: 0">
                            <thead>
                            <tr>
                                <th>商品名称</th>
                                <th style="text-align: center">商品主图</th>
                                <th style="text-align: center">商品价格</th>
                                <th style="text-align: center">商品数量</th>
                                <th style="text-align: center">其他信息</th>
                            </tr>
                            </thead>
                            <tbody style="text-align: center">
                                <?php
                                    if(!empty($order['products'])){
//                                        var_dump(__file__.' line:'.__line__,$order['products']);exit;
                                        foreach($order['products'] as $product){
                                            ?>
                                            <tr>
                                                <td style="text-align: left"><?php echo $product['title']?></td>
                                                <td><img style="height: 3em" src="<?php echo $product['main_img']?>"/></td>
                                                <td><?php echo sprintf("%.2f", $product['paid_price']/100) ?></td>
                                                <td><?php echo $product['quantity']?></td>
                                                <td><?php if($product['sku_uid'] = explode(';',$product['sku_uid']))
                                            {
                                                unset($product['sku_uid'][0]);
                                                echo implode(',',$product['sku_uid']);
                                                }


                                        ?></td>
                                            </tr>
                                <?php
                                        }
                                    }
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        收货日期：
                    </div>
                    <div class="am-u-sm-8 am-u-end address-div">
                        <p><?php if(!empty($order['date_time'])) echo $order['date_time'] ?></p>

                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        收货人信息：
                    </div>
                    <div class="am-u-sm-8 am-u-end address-div">
                        <p>详细地址：<?php
                            echo (empty($order['address']['province'])?'':$order['address']['province']).
				//前端搞反了
                                (empty($order['address']['city'])?'':$order['address']['city']).
                                (empty($order['address']['town'])?'':$order['address']['town']).
                                (empty($order['address']['address'])?'':$order['address']['address']);
                            ?></p>
                        <p>收件人：<?php if(!empty($order['address']['name'])) echo $order['address']['name'] ?></p>
                        <p>联系电话：<?php if(!empty($order['address']['phone'])) echo $order['address']['phone'] ?></p>
                    </div>
                </div>

                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        订单留言：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php  if(!empty($order['info']['massage'])) echo $order['info']['massage']; ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        订单备注：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php  if(!empty($order['info']['remark'])) echo $order['info']['remark']; ?>
                    </div>
                </div>
                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        配送时间：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php
                        if(!empty($order['info']['delivery_time'])){
                            $odate = date("Y年m月d日 H:i:s",$order['info']['delivery_time']);
                            if($odate){
                                echo $odate;
                            }
                        }
                        ?>
                    </div>
                </div>

                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        支付信息：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <table class="am-table am-table-striped am-table-hover">
                            <thead>
                            <tr>
                                <th>支付状态</th>
                                <th style="text-align: center">支付总额</th>
                                <th style="text-align: center">余额抵扣</th>
                                <th style="text-align: center">运费</th>
                                <th style="text-align: center">优惠</th>
                                <th style="text-align: center">支付时间</th>
                            </tr>
                            </thead>
                            <tbody style="text-align: center">
                                    <tr>
                                        <td class="am-warning" style="text-align: left"><?php if(!empty($order)&&(!($order['paid_time']=="0"))) {echo "已支付";}else{echo "未支付";} ?></td>
                                        <td><?php if(!empty($order)) echo sprintf("%.2f", $order['paid_fee']/100) ?></td>
                                        <td><?php if(!empty($order)) echo sprintf("%.2f", $order['cash_fee']/100) ?></td>
                                        <td><?php if(!empty($order)) echo sprintf("%.2f", $order['delivery_fee']/100) ?></td>
                                        <td><?php if(!empty($order)) echo sprintf("%.2f", $order['discount_fee']/100)  ?></td>
                                        <td><?php if(!empty($order['paid_time'])) echo date("Y年m月d日 H:i:s",$order['paid_time']);?></td>
                                    </tr>
                            </tbody>
                        </table>
                        <?php
                        if(!empty($order['refund'])){
                            if(!empty($order['refund']['create_time'])&&empty($order['refund']['accept_time'])){
                                ?>
                                <span style="padding: 0.5em;background:#dd514c ;color: white">退款中</span>
                                <span style="margin-left: 0.5em">申请退款时间：<?php echo date("Y年m月d日 H:i:s",$order['refund']['create_time']) ?></span>
                                <span style="margin-left: 1em">退款金额：<?php echo sprintf("%.2f", $order['refund']['refund_fee']/100)  ?></span>
								
                                <?php
                            }
                            elseif(!empty($order['refund']['accept_time'])){
                                ?>
                                <span style="padding: 0.5em;background:#dd514c ;color: white">已退款</span>
                                <span style="margin-left: 0.5em">退款时间：<?php echo date("Y年m月d日 H:i:s",$order['refund']['refund_time']) ?></span>
                                <span style="margin-left: 1em">退款金额：<b><?php echo sprintf("%.2f", $order['refund']['refund_fee']/100)  ?></b></span>
                                <?php
                            }
							if(!empty($order['refund']['refund_info']['refund_info'])) 
							echo '<p>退款理由：<b>'.htmlspecialchars($order['refund']['refund_info']['refund_info']).'</b></p>';
                            ?>

                        <?php
                        }
                        ?>

                        <?php
                        if(!($order['recv_time']==0)){
                            ?>
                            <span style="padding: 0.5em;background:#5eb95e;color: white">已收货</span>
                            <span>收货时间：<?php echo date("Y年m月d日 H:i:s",$order['recv_time']) ?></span>
                        <?php
                        }else if(!($order['send_time']==0)){
                            ?>
                            <span style="padding: 0.5em;background:#f37b1d ;color: white">已发货</span>
                            <span>发货时间：<?php echo date("Y年m月d日 H:i:s",$order['send_time']) ?></span>
			<?php if(!empty($order['delivery_info'])) {
				foreach($order['delivery_info'] as $k => $v) {
					if($k == '快递单号') {
					echo '<p>'.$k.': <a target="_blank" href="https://m.kuaidi100.com/result.jsp?nu='.$v.'">'.$v.'</a></p>';
					}
					else 
					echo '<p>'.$k.': '.$v.'</p><a class="cdodelivery am-btn am-btn-secondary">修改快递信息</a>';
				}
			}
			?>

                        <?php
                        }
                        ?>
                    </div>
                </div>

            </div>

            <div data-tab-panel-1 class="am-tab-panel ">

                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right" style="height: 5em;line-height: 5em">
                        买家名称：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php if(!empty($order)) echo $order['user']['name'] ?>
                        <img class="head-img" src="<?php echo$order['user']['avatar'] ?>" />
                    </div>
                </div>

                <div class="am-g am-margin-top-sm">
                    <div class="am-u-sm-2 am-text-right">
                        性别：
                    </div>
                    <div class="am-u-sm-8 am-u-end">
                        <?php echo(($order['user']['gender']=="1") ?  "女":"男")?>
                    </div>
                </div>


            </div>
        </div>
    </div>
</div>
<script>
    var order_data =<?php echo(!empty($order)) ? json_encode($order) : "null" ?>;
    console.log(order_data)
$(function(){
$('#id_update_order').click(function(){
	var uid = $(this).attr('data-id');
	$.get('?_a=pay&_u=index.wxxiaochengxu_update_order&oid=b'+uid, function(ret){
		console.log(ret);
		window.location.reload();
	})
});
});
</script>

<?php
	$extra_js =  array(
			'/static/js/jquery.jqprint-0.3.js',
		  $static_path.'/js/orderdetail.js?1',
);
?>
