<?php 
include $tpl_path.'/header.tpl';

#var_export($article);
?>
<div style="width:90%;margin-left:5%;height:500px;margin-top:15px;">
	<div style="height:auto">
		<?php
		if(!empty($article['cat'])) {
		echo '
		<span style="font-weight:700">
			<a style="text-decoration: none;color:black" href="/?_a=site&sp_uid='.$site['sp_uid']
				.'&cid='.$article['cat']['uid'].'&_u=index.cats">'.$article['cat']['title']
				.'</a></span><span><img style="height:10px;margin:0 5px" src="/app/site/view/eyeis/static/images/r-arrow.png">
		</span>';
		}
		?>
		<span style="font-size:14px"><?php echo $article['title']?></span>
	</div>
	<div style="height:200px;margin-top:15px;">
		<img style="width:100%;height:100%;" src="<?php echo $article['image']?>">
	</div>
	<div style="width:90%;margin:15px 5% 0 5%;height:200px;">
		<div><?php echo $article['title']?></div>
		<div style="font-size:14px;margin-bottom:30px"><?php echo $article['content']?></div>
	</div>

</div>

<?php 
include $tpl_path.'/footer.tpl';
?>
<script>

</script>

