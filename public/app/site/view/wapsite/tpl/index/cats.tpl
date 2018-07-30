<?php 
	if(!$children_cats && $articles['count'] == 1 && !empty($articles['list'][0])) {
		echo '<script> window.location.href="?_a=site&cid='.$articles['list'][0]['uid'].'&_u=index.mainarticle";</script>';
		#redirectTo('window.location.href="?_a=site&cid='.$articles['list'][0]['uid'].'&_u=index.mainarticle');
	}

include $tpl_path.'/header.tpl';
?>
<link rel="stylesheet" type="text/css" href="<?php echo $static_path;?>/css/cats.css"> 
<style>
	.content_box{
 		position:relative;width:30%;margin:15px 1% 0 2%;float:left;text-align: center;
	}
	.content_box img{
		 max-width:80%;max-height: 80%
	}
	.content_box div{
		width:100%;height:20px;/*color:#65ADC3;*/text-align:center;position: absolute;bottom: -5px;
	}
</style>

</div>

<div class="cat_content">
	<div class="cat_list" data-uid="<?php echo $site['sp_uid']?>" data-cid="<?php echo $cat['uid']?>">
	<?php 
			$html = '';
			//分类列表
			if($children_cats)
			foreach ($children_cats as $c) {
				$html.='<div class="content_box"><a href="/?_a=site&cid='.$c['uid'].'&_u=index.articlelist"><img src="'.
						$c['image_icon'].'"><div >'.$c['title'].'</div></a></div>';
			}

			//文章列表
			if($articles['list'])
			foreach ($articles['list'] as $a) {
				$html.='<div class="content_box"><a href="/?_a=site&cid='.$a['uid'].'&_u=index.mainarticle"><img src="'.
						$a['image_icon'].'"><div >'.$a['title'].'</div></a></div>';
			}


		echo $html;
	?>



	</div>
</div>



<?php 
include $tpl_path.'/footer.tpl';
?>

<script src="/app/site/view/wapsite/static/js/cats.js"></script>

