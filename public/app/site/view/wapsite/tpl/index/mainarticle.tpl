<?php 
include $tpl_path.'/header.tpl';
?>


<style>
	.article_content{width:100%;margin:0 auto;}

	.article_brief_box{width:94%;margin-top:25px;height:200px;margin:0 auto;}
	.article_brief_box>div{font-size:14px;padding-bottom:50px;color:#656565}

	.list_title span {color: gray;font-size:12px;margin-left:20px;}
	img {
		max-width: 94%;
		margin: 0 auto;
		display: block;
		text-align: center;
	}
</style>
<div class="article_content">
	<div class="title_box">
	<div class="red_box" style="margin-bottom:10px; border-bottom:2px solid #<?php echo $color;?>">
		<div class="list_title"><?php echo $article['title'].' <span style="display:block;margin:5px 0;">'.date('Y-m-d', $article['create_time']).'</span>';?></div>
	</div>
	
</div>


	<div class="article_brief_box">
		<div><?php echo $article['content']?></div>
	</div>

</div>

<?php 
include $tpl_path.'/footer.tpl';
?>
<script>

</script>

