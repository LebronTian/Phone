
		<link rel="stylesheet" href="/app/vipcard/static/css/vipcard.css">

		<div class="basic-info">
			<header>
				<h2 class="title">会员卡基本信息</h2>
			</header>
			<main>
				<label>商城名称：<input type="text" id="shopname" placeholder="请输入商城名称"/></label>
				<!-- 店铺logo -->
				<section class="setting">
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
							<input type="color" id="bgcolor" disabled/>
						</div>
						<div>
							<input type="checkbox" name="bgimg" value="bgimg" id="backgroundImage" />
							<label for="backgroundImage">封面图片</label>
							<input type="button" id="selectimg" value="选择图片" disabled />
						</div>
						<p>尺寸：1000*600像素，小于1M，支持jpg、png、jpeg格式</p>
					</div>
				</section>
				<!-- *会员卡名称 -->
				<section class="setting">
					<label class="setting-title">*会员卡名称:</label>
					<div class="setting-cont">
						<input type="text" id="cardname" placeholder="请输入会员卡名称" />
					</div>
				</section>
				<!-- *会员权益 -->
				<section class="setting">
					<label class="setting-title">*会员权益:</label>
					<div class="setting-cont">
						<div>
							<label>
						  <input type="checkbox" id="mail" name="vipcheck" value="mail"/>
						  <div class="show-box"></div>
						  <span>包邮</span>
						</label>
						</div>
						<div>
							<label>
						  <input type="checkbox" id="discount" value="discount"/>
						  <div class="show-box"></div>
						  <span>会员折扣</span>
						  <input type="text" id="discountnum" placeholder="请输入折扣" class="input50" disabled />
						  <span>折</span>
						</label>
						</div>
						<div>
							<label>
						  <input type="checkbox" name="vipcheck" id="coupon" value="coupon"/>
						  <div class="show-box"></div>
						  <span>优惠券</span>
						</label>
						</div>
						<div>
							<label>
						  <input type="checkbox" id="score" value="score" />
						  <div class="show-box"></div>
						  <span>送积分</span>
						  <span>开卡赠送</span>
						  <input type="text" id="scorenum" placeholder="请输入积分" class="input50" disabled />
						  <span>积分</span>
						</label>
						</div>
					</div>
				</section>
				<section class="setting">
					<label class="setting-title">*使用须知:</label>
					<div class="setting-cont">
						<textarea id="notice" name="" rows="" cols="" placeholder="请输入使用须知"></textarea>
					</div>
				</section>
				<section class="setting">
					<label class="setting-title">客服电话:</label>
					<div class="setting-cont">
						<input id="phonenum" type="tel" name="" id="" value="" placeholder="请输入电话" />
					</div>
				</section>
				<div class="vip-btn-group">
					<input type="submit" value="保存" class="submit" class="am-btn am-btn-success" />
					<input type="reset" value="取消" class="am-btn am-btn-danger" />
				</div>
			</main>
		</div>
		<script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
		<?php
$extra_js = array(
	'/app/vipcard/static/js/vipCard.js',
)
?>