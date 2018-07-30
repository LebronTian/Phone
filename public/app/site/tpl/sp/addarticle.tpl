
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">

<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($article['uid']) ? '编辑文章' : '添加文章')?></strong> / <small></small></div>
</div>

<div class="am-form">
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			标题
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="id_title" <?php if(!empty($article['title'])) echo 'value="'.$article['title'].'"';?>>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			摘要
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="id_digest" <?php if(!empty($article['digest'])) echo 'value="'.$article['digest'].'"';?>>
		</div>
	</div>


	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			分类
		</div>
		<div class="am-u-sm-8 am-u-end">
			<select data-am-selected="{btnWidth: 150, btnSize: 'lg' }" class="option_parent">
				<?php
				$html = '<option value="0"';
				if(empty($article['cat_uid'])) $html .= ' selected ';
				$html .= '>未分类</option>';

				if(!empty($parents))
					foreach($parents as $p) {
						$html .= '<option value="'.$p['uid'].'"';
						if(!empty($article['cat_uid']) && $article['cat_uid'] == $p['uid']) $html .= ' selected';
						$html .= '>'.$p['title'].'</option>';
					}
				echo $html;
				?>
			</select>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			大图
		</div>
		<div class="am-u-sm-9">
			<!-- <form action="?_a=upload&_u=index.upload" runat="server" enctype="multipart/form-data">
                <input type="file" name="file" id="file_upload"/>

            </form> -->
			<button  class="imgBoxBtn am-btn am-btn-secondary" data-addr="#id_img">从图片库选择</button>
			<div id="codeImgBox">
				<img id="id_img" <?php if(!empty($article['image'])) echo 'src="'.$article['image'].'"';?> style="width:100px;height:100px;">
			</div>
		</div>
		<div class="am-u-sm-8 am-u-end">
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			缩略小图
		</div>
		<div class="am-u-sm-9">
			<!-- <form action="?_a=upload&_u=index.upload" runat="server" enctype="multipart/form-data">
                <input type="file" name="file" id="file_upload"/>

            </form> -->
			<button  class="imgBoxBtn am-btn am-btn-secondary" data-addr="#id_img2">从图片库选择</button>
			<div id="codeImgBox2">
				<img id="id_img2" <?php if(!empty($article['image_icon'])) echo 'src="'.$article['image_icon'].'"';?> style="width:100px;height:100px;">
			</div>
		</div>
		<div class="am-u-sm-8 am-u-end">
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			发布时间
		</div>
		<div class="am-u-sm-8 am-u-end">
			<p><input type="datetime-local" id="id_create_time" value="<?php 
			echo date('Y-m-d\TH:i:s', !empty($article['create_time']) ? $article['create_time'] : 0); ?>"></p>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			作者	
		</div>
		<div class="am-u-sm-8 am-u-end">
			<p><input type="text" id="id_author" value="<?php 
			if(!empty($article)) echo $article['author'];; ?>"></p>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			排序
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="id_sort" <?php if(isset($article['sort'])) echo 'value="'.$article['sort'].'"';?>>
			<small>从大到小排序</small>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			状态
		</div>
		<div class="am-u-sm-8 am-u-end">
			<label class="am-checkbox">
				<input type="checkbox" id="id_status" data-am-ucheck <?php if(empty($article['status'])) echo 'checked';?>>
				显示到网站</label>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			SEO关键字
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="id_seo" <?php if(!empty($article['seo_words'])) echo 'value="'.$article['seo_words'].'"';?>>
		</div>
	</div>

	<div class="am-g am-margin-top-sm" style="margin-top:20px;">
		<div class="am-u-sm-2 am-text-right">
			正文
		</div>
		<!--文本编辑/-->

		<div class="am-u-sm-8 am-u-end">
			<script id="container" name="content" type="text/plain" style="height:250px;"><?php if(!empty($article['content'])) echo ''.$article['content'].'';?></script>
		</div>
	</div>


	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			<p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>
		</div>
	</div>

</div>

<?php
echo '<script>var g_uid = '.(!empty($article['uid']) ? $article['uid'] : 0).';</script>';
$extra_js =  array(
		'/static/js/ueditor/ueditor.config.js',
		'/static/js/ueditor/ueditor.all.js',

		'/app/site/static/js/addarticle.js',
);
?>

<script>
	seajs.use(['selectPic']);
</script>
