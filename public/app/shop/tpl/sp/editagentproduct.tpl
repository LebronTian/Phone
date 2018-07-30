<link rel="stylesheet" href="/static/js/select2/css/select2.min.css"/>
<link rel="stylesheet" href="/app/shop/static/css/addproduct.css"/>

<style>
	.extra-box {
		margin-top: 1em;
	}

	#extra-input {
		display: inline-block;
	}
</style>
<div class="am-cf am-padding">
	<div class="am-fl am-cf" id="edit-id" <?php echo 'data-id="' . $agent_to_user_product['uid'] . '"'; ?>>
		<strong class="am-text-primary am-text-lg">  <?php echo '编辑'; ?>代理商的商品</strong> /
	</div>
</div>
<div class="am-form am-form-horizontal" data-am-validator>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			商品名称
		</div>
		<div class="am-u-sm-6 am-u-end">
			<input type="text" id="product_title" placeholder="必填" minlength="1" <?php
			echo 'value="' . (empty($agent_to_user_product['title']) ? $agent_to_user_product['product']['title'] : $agent_to_user_product['title']) . '"'; ?>>
		</div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			商品原价
		</div>
		<div class="am-u-sm-4 am-u-end">
			<div style="width: 80%;float:left;">
				<input type="text" id="oriPrice" placeholder="必填，展示在商品列表封面，商品吊牌价、销售指导价"
				       pattern="^[0-9]+(.[0-9]{1,100})?$" minlength="1" <?php
				echo 'value="' . sprintf('%.2f',
						(empty($agent_to_user_product['ori_price']) ?
							$agent_to_user_product['product']['ori_price'] :
							$agent_to_user_product['ori_price']) / 100) . '"'; ?>>
			</div>
			<div class="price-yuan">
				元
			</div>
		</div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			商品售价
		</div>
		<div class="am-u-sm-4 am-u-end">
			<div style="width: 80%;float:left;">
				<input type="text" id="proPrice" placeholder="必填，展示在商品列表封面，用户最终的购买价格" pattern="^[0-9]+(.[0-9]{1,100})?$"
				       minlength="1" <?php
				echo 'value="' . sprintf('%.2f', (empty($agent_to_user_product['price']) ? $agent_to_user_product['product']['price'] : $agent_to_user_product['price']) / 100) . '"'; ?>>
			</div>
			<div class="price-yuan">
				元
			</div>

		</div>
		<div class="am-u-sm-6 am-margin-top-sm am-text-left am-u-end">
			<?php echo '请设置一个大于<strong>' . sprintf('%.2f', $agent_product['price_l'] / 100) .
				'</strong>元且小于<strong>' . sprintf('%.2f',$agent_product['price_h']  / 100) . '</strong>元的价格' ?>
		</div>
	</div>

	<div class="am-g am-margin-top-sm margin-top">
		<div class="am-u-sm-2 am-text-right">
			商品主图
		</div>
		<div class="am-u-sm-8 am-u-end">
			<button class="imgBoxBtn am-btn am-btn-secondary buttonImg1" data-addr="#main-img-src" data-func="mainImg">
				从图片库选择
			</button>
			<input id="main-img-src" type="hidden" <?php
			if (!empty($agent_to_user_product['main_img']))
			{
				echo 'src="' . $agent_to_user_product['main_img'] . '"';
			}
			else
			{
				echo 'src="' . $agent_to_user_product['product']['main_img'] . '"';
			}
			?>/>

			<div id="main-img-box" style="margin: 10px 0">
				<?php if (!empty($agent_to_user_product['main_img']))
				{
					echo '<img id="main-img" src="' . $agent_to_user_product['main_img'] . '"/> ';
				}
				else
				{
					if (!empty($agent_to_user_product['product']['main_img']))
					{
						echo '<img id="main-img" src="' . $agent_to_user_product['product']['main_img'] . '"/> ';
					}
				}
				?>
			</div>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			商品图片
		</div>
		<div class="am-u-sm-8 am-u-end">
			<button class="imgBoxBtn am-btn am-btn-secondary" data-addr="#more-img-src" data-func="moreImg">从图片库选择
			</button>
			<input id="more-img-src" type="hidden"/>

			<div id="more-img-box" style="margin: 10px 0;overflow: hidden">
				<?php
				if (!empty($agent_to_user_product['images']))
				{
					foreach ($agent_to_user_product['images'] as $img)
					{
						echo '<div class="more-img-content"><img class="more-img" src="' . $img . '"/><span class="am-icon-trash del-img"></span></div>';
					}
				}
				else
				{
					if (!empty($agent_to_user_product['product']['images']))
					{
						foreach ($agent_to_user_product['product']['images'] as $img)
						{
							echo '<div class="more-img-content"><img class="more-img" src="' . $img . '"/><span class="am-icon-trash del-img"></span></div>';
						}
					}
				}

				?>
			</div>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			商品详情
		</div>
		<div class="am-u-sm-8 am-u-end">
			<script id="product-content" name="content" type="text/plain" style="height:250px">
			</script>
		</div>
	</div>
	<div class="am-g am-margin-top-sm margin-top">
		<div class="am-u-sm-2 am-text-right">
			状态
		</div>
		<div class="am-u-sm-8 am-u-end">
			<label class="am-radio am-radio-inline" style="padding-top: 0">
				<input type="radio" name="rad-status" value="1" data-am-ucheck>
				暂不上架
			</label>
			<label class="am-radio am-radio-inline" style="padding-top: 0">
				<input type="radio" name="rad-status" value="0" data-am-ucheck>
				立即上架（请确认商品价格，商品名称已填写无误）
			</label>
		</div>
	</div>

	<div class="am-g am-margin-top-sm" style="margin-bottom: 20px">
		<div class="am-u-sm-2 am-text-right">
			&nbsp;
		</div>
		<div class="am-u-sm-8 am-u-end">
			<button class="am-btn am-btn-secondary" id="saveProduct">保存</button>
		</div>
	</div>
</div>


<?php

echo '
    <script>
    var edit_product = ' . (empty($agent_to_user_product) ? "null" : json_encode($agent_to_user_product)) . ' ;
    var edit_uid = ' . (empty($agent_to_user_product['uid']) ? "null" : $agent_to_user_product['uid']) . ' ;
    var edit_a_uid = ' . (empty($agent_to_user_product['a_uid']) ? "null" : $agent_to_user_product['a_uid']) . ' ;
    var edit_p_uid = ' . (empty($agent_to_user_product['p_uid']) ? "null" : $agent_to_user_product['p_uid']) . ' ;
    var edit_price_l = ' . (empty($agent_product['price_l']) ? "null" : $agent_product['price_l']) . ' ;
    var edit_price_h = ' . (empty($agent_product['price_h']) ? "null" : $agent_product['price_h']) . ' ;
    </script>';

$extra_js = array(

	'/static/js/ueditor/ueditor.config.js',
	'/static/js/ueditor/ueditor.all.js',
	'/static/js/select2/js/select2.min.js',
	'/static/js/catlist_yhc.js',
	$static_path . '/js/district-all.js',
	$static_path . '/js/editagentproduct.js',
	//        $static_path.'/js/addinfo.js',
	//        $static_path.'/js/catsSelect.js'
);
?>
<script>
	seajs.use(['selectPic']);
</script>