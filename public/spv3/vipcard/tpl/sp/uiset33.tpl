
		<link rel="stylesheet" href="/spv3/vipcard/static/css/vipcard.css">
		<div class="basic-info">
			<header>
				<h2 class="title">会员卡基本信息</h2>
			</header>
			<main>
				<label style="display:none;">商城名称：<input type="text" id="shopname" placeholder="请输入商城名称"/></label>
				<!-- 店铺logo -->
				<section  style="display:none;"class="setting">
					<label class="setting-title">店铺Logo:</label>
					<div class="setting-cont">
						<img id="shoplogo" src="http://via.placeholder.com/72x72">
					</div>
				</section>
				<!-- 卡片封面 -->
				<section class="setting">
					<label class="setting-title">卡片封面:</label>
					<div class="setting-pos">
						<div>
							<input type="checkbox" name="bgcolor" value="bgcolor" id="backgroundColor" />
							<label for="backgroundColor">背景色</label>
							<input type="color" id="bgcolor" value="<?php if(!empty($card['ui_set']['back_ground']['color'])) echo $card['ui_set']['back_ground']['color']; ?>" disabled/>
						</div>
						<div>
							<input type="checkbox" name="bgimg" value="<?php if(!empty($card['ui_set']['back_ground']['path'])) echo $card['ui_set']['back_ground']['path']; ?>" id="backgroundImage" />
							<label for="backgroundImage">封面图片</label>
							<input type="button" class="imgBoxBtn am-btn am-btn-secondary" data-addr=".logo-img" id="selectimg" value="选择图片" disabled />
						</div>
						<div class="image-box">
							<img style="max-height: 150px;" class="logo-img" src="<?php if(!empty($card['ui_set']['back_ground']['path'])) echo $card['ui_set']['back_ground']['path']; ?>">
						</div>
						<p>尺寸：1000*600像素，小于1M，支持jpg、png、jpeg格式</p>
					</div>
				</section>
				<!-- *会员卡名称 -->
				<section class="setting">
					<label class="setting-title">*会员卡名称:</label>
					<div class="setting-cont">
						<input class="am-form-field" type="text" id="cardname" placeholder="请输入会员卡名称" value="<?php if(!empty($card['rank_rule'][1]['rank_name'])) echo $card['rank_rule'][1]['rank_name']; ?>"/>
					</div>
				</section>
				<!-- *会员权益 -->
				<section class="setting">
					<label class="setting-title">*会员权益:</label>
					<div class="setting-cont">
						<div>
							<label>
						  <input <?php if(!empty($card['ui_set']['other_rule']['baoyou'])) echo 'checked="checked"'; ?> type="checkbox" id="mail" name="vipcheck" value="mail"/>
						  <div class="show-box"></div>
						  <span>包邮</span>
						</label>
						</div>
						<div>
							<label>
						  <input type="checkbox" <?php if(!empty($card['rank_rule'][1]['rank_discount'])) echo 'checked="checked"'; ?>  id="discount" value="discount"/>
						  <div class="show-box"></div>
						  <span>会员折扣</span>
						  <input type="number" min="0" max="10" step=".5" id="discountnum" value="<?php if(!empty($card['rank_rule'][1]['rank_discount'])) echo $card['rank_rule'][1]['rank_discount']/10; ?>" class="input50 am-form-field" disabled2 />
						  <span>折</span>
						</label>
						</div>
						<div>
							<label>
						  <input <?php if(!empty($card['ui_set']['other_rule']['youhuiquan'])) echo 'checked="checked"'; ?> type="checkbox" name="vipcheck" id="coupon" value="coupon"/>
						  <div class="show-box"></div>
						  <span>优惠券</span>
						</label>
						</div>
						<div>
							<label>
						  <input type="checkbox" <?php if(!empty($card['ui_set']['other_rule']['first_point'])) echo 'checked="checked"'; ?>  id="score" value="score" />
						  <div class="show-box"></div>
						  <span>送积分</span>
						  <span>开卡赠送</span>
						  <input type="number" min="0" step="5" id="scorenum" value="<?php if(!empty($card['ui_set']['other_rule']['first_point'])) echo $card['ui_set']['other_rule']['first_point']; ?>" class="input50 am-form-field" disabled2 />
						  <span>积分</span>
						</label>
						</div>
					</div>
				</section>
				<section class="setting">
					<label class="setting-title">*使用须知:</label>
					<div class="setting-cont">
						<textarea class="am-form-field" id="notice" name="" rows="" cols="" placeholder="请输入使用须知"><?php if(!empty($card['ui_set']['other_rule']['readme'])) echo $card['ui_set']['other_rule']['readme']; ?> </textarea>
					</div>
				</section>
				<section class="setting">
					<label class="setting-title">客服电话:</label>
					<div class="setting-cont">
						<input class="am-form-field" id="phonenum" value="<?php if(!empty($card['ui_set']['other_rule']['phone'])) echo $card['ui_set']['other_rule']['phone']; ?>"  type="tel" name="" id="" value="" placeholder="请输入电话" />
					</div>
				</section>
				<div class="vip-btn-group">
					<input type="submit" value="保存" class="submit am-btn am-btn-success" />
					<input type="reset" value="取消" class="am-btn am-btn-danger" />
				</div>
			</main>
		</div>
		<?php
$extra_js = array(
	'/spv3/vipcard/static/js/vipCard.js',
)
?>
<script>
    $(function () {
        seajs.use(['selectTpl','selectPic']);
    })
</script>
