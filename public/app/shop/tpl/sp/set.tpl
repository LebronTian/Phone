
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">基本设置</strong> / <small></small></div>
</div>

<div class="am-form">
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            店铺名称
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="id_title" value="<?php if(!empty($shop['title'])) echo $shop['title'] ?>">
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            logo图片
        </div>
        <div class="am-u-sm-8 am-u-end">
            <button style="margin-bottom: 0.5em" class="imgBoxBtn am-btn am-btn-secondary" data-addr=".logo-img">从图片库选择</button>
            <div class="image-box" style="width: 50%">
                <img style="max-height: 3rem;" class="logo-img" src="<?php if(!empty($shop['logo'])) echo $shop['logo'] ?>">
            </div>
			建议尺寸  64*64
        </div>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            店铺状态
        </div>
        <div class="am-u-sm-8 am-u-end">
            <label style="margin-top: 0.2em" class="am-checkbox">
                <input <?php if(!empty($shop)&&(!$shop['status'])) echo "checked" ?>  id="shop-status" type="checkbox"  data-am-ucheck> 正常营业
            </label>
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            店铺公告
        </div>
        <div class="am-u-sm-8 am-u-end">
            <input type="text" id="id_notice" value="<?php if(!empty($shop['notice'])) echo $shop['notice'] ?>">
        </div>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
		&nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
			<a href="?_a=pay&_u=sp" target="_blank">点击去设置支付方式</a>
        </div>
    </div>

<hr>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            订单积分抵扣
        </div>
        <div class="am-u-sm-2 am-u-end" style="display: flex;">
            <input type="number" id="discount"  value="<?php echo(!empty($point['discount']))? $point['discount'] : '' ; ?>" >
        </div><small> 积分抵扣1元 (0表示关闭积分抵扣)</small>
    </div>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            抵扣上限
        </div>
        <div class="am-u-sm-2 am-u-end" style="display: flex;">
            <input type="number" id="point_limit"  value="<?php echo(!empty($point['point_limit']))? $point['point_limit'] : '' ; ?>" >
        </div><small>&nbsp;(%) (0-100, 即最多能抵扣商品价格的百分比)</small>
    </div>
    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            抵扣条件
        </div>
        <div class="am-u-sm-2 am-u-end" style="display: flex;">
            <input type="number" id="discount_limit"  value="<?php echo(!empty($point['discount_limit']))? $point['discount_limit']/100 : '' ; ?>" >
        </div><small>&nbsp;(元), 即超过一定金额的订单才能使用积分抵扣</small>
    </div>
<hr>

    <div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            店铺模板
        </div>
        <div class="am-u-sm-8 am-u-end">
            <div class="tpl-container" data-url="<?php echo '?_a='.$_REQUEST['_a'].'&_u=api.get_tpls' ?>" data-selected="<?php echo(!empty($shop['tpl'])? $shop['tpl']:"") ?>">   
            </div>
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
    var shop =<?php echo(!empty($shop)? json_encode($shop):"null") ?>;
    var tpl_url =<?php echo '"?_a='.$_REQUEST['_a'].'&_u=api.get_tpls"' ?>;
</script>

<?php
$extra_js =  array(
    '/app/shop/static/js/set.js',
);
?>

<script>
    $(function () {
        seajs.use(['selectTpl','selectPic']);
    })
</script>
