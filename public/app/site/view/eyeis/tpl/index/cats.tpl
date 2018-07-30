<?php 
include $tpl_path.'/header.tpl';
?>
<link rel="stylesheet" type="text/css" href="/app/site/view/eyeis/static/css/cats.css"> 
<div class="cat_title"><div><?php echo $cat['title'];?></div>
</div>

<div class="cat_content">
	<div class="cat_list" data-uid="<?php echo $site['sp_uid']?>" data-cid="<?php echo $cat['uid']?>" data-astutas="<?php if($children_cats) echo 0; else echo 1;   ?>" >
	<?php 
		if($children_cats){
			$html = '';
			foreach ($children_cats as $c) {
				$html.='<div class="list_box"><a href="/?_a=site&sp_uid='.$site['sp_uid'].'&cid='.$c['uid'].'&_u=index.cats"><img src="'.$c['image'].'"></a><div style=""><a href="/?_a=site&sp_uid='.$site['sp_uid'].'&cid='.$c['uid'].'&_u=index.cats">'.$c['title'].'</a></div></div>';
			}
			echo $html;
		}
		else{
			$html = '';
			if($articles) foreach ($articles['list'] as $a) {
				$html.='<div class="list_box"><a href="/?_a=site&sp_uid='.$site['sp_uid'].'&cid='.$a['uid'].'&_u=index.article"><img src="'.$a['image'].'"></a><div style=""><a href="/?_a=site&sp_uid='.$site['sp_uid'].'&cid='.$a['uid'].'&_u=index.article">'.$a['title'].'</a></div></div>';
			}
			echo $html;
		}
	?>
	</div>
</div>

<?php 
include $tpl_path.'/footer.tpl';
?>

<script src="/app/site/view/eyeis/static/js/cats.js"></script>
<script type="text/javascript">



</script>
