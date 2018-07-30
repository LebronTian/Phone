<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">基本设置</strong> / <small></small></div>
</div>

<div class="am-form">
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			网站名称
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="id_title" <?php if(!empty($site['title'])) echo 'value="'.$site['title'].'"';?>>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			SEO关键词
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="id_seo" <?php if(!empty($site['seo_words'])) echo 'value="'.$site['seo_words'].'"';?>>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			统计代码
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="id_stat" <?php if(!empty($site['stat_code'])) echo 'value="'.$site['stat_code'].'"';?>>
		</div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			联系电话
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text"  id="id_phone" <?php if(!empty($site['phone'])) echo 'value="'.$site['phone'].'"';?>>
		</div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			网站语言
		</div>
		<div class="am-u-sm-8 am-u-end">
			<select data-am-selected="{btnWidth: 150, btnSize: 'lg' }" class="option_parent">
				<?php
				if(!empty($language))
					foreach($language as $l) {
						$html .= '<option value="'.$l['uid'].'"';
						if(!empty($site['language']) && $site['language'] == $l['uid']) $html .= ' selected';
						$html .= '>'.$l['title'].'</option>';
					}
				echo $html;
				?>
			</select>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			logo
		</div>
		<div class="am-u-sm-8 am-u-end">
			<button class="imgBoxBtn am-btn am-btn-primary" data-addr="#id_img">从图片库选择</button>
			<div id="idImgBox">
				<img id="id_img" src="<?php if(!empty($site['logo'])) echo $site['logo'] ?>"  style="width:100px;height:100px;">
			</div>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			状态
		</div>
		<div class="am-u-sm-8 am-u-end">
			<label class="am-checkbox">
				<input type="checkbox" id="id_status" data-am-ucheck <?php if(empty($site['status'])) echo 'checked';?>>
				显示网站</label>
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
		'/app/site/static/js/set.js'
);
?>

<script>
	seajs.use(['selectPic']);
</script>