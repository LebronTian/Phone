<?php 
include $tpl_path.'/header.tpl';
?>


<style>
	.article_content{width:94%;margin:0 auto;margin-left:3%;margin-top:25px;margin-bottom:60px}
	.article_top_box{width:100%;position:relative;color:#666666;}
	.article_title_box{width:75%;height:auto;font-size: 20px;margin:0;}
	.back{top:-10px;right:-4%}
	.article_info{color:#CCCCCC;margin-top:15px;}
	.article_brief_box{width:100%;margin-top:15px;height:200px;}
	.article_brief_box>div{font-size:14px;padding-bottom:50px;color:#656565}
	.article_brief_box img{width:100% !important;height:auto !important;}
</style>
<div class="article_content">
	<div class="article_top_box">
	<div class="article_title_box">
			<?php echo $article['title']?>
	</div>
	<img class="back" src="/app/site/view/wapsite/static/images/back.png">
	</div>

	<div class="article_info"><span><img src="/app/site/view/wapsite/static/images/time.png" style="width:13px;height:13px"> <?php echo date('Y-m-d',$article['create_time'])?></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span><img src="/app/site/view/wapsite/static/images/read.png" style="width:20px"> <?php echo $article['click_cnt']?></span></div>


	<div class="article_brief_box">
		<div><?php echo $article['content']?></div>
	</div>

</div>

<?php 
include $tpl_path.'/footer.tpl';
?>
<script>

</script>

