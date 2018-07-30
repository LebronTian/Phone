<?php 
include $tpl_path.'/header.tpl';
?>

<link rel="stylesheet" href="/app/site/view/wapsite/static/css/index.css"> 
<link rel="stylesheet" href="/app/site/view/wapsite/static/css/islider.css"/>
	<div class="main_visual">
	<p class="flicking_con">
			<!-- <p> -->
			<span class="slide_btn">
			<?php 
			$html='';
			if($slides) foreach ($slides as $s) {	
				$html.='<a href="javascript:;"></a>';
			}
			echo $html;
			?>
			</span>
			<!-- </p> -->
	</p>
	<div class="main_image">
		<ul>
			<?php 
			$html='';
			if($slides) foreach ($slides as $s) {	
				$html.='<li><a href="'.$s['link'].'"><img src="'.$s['image'].'"></a></li>';
			}
			echo $html;
			?>
		</ul>
		<?php 
			$html='';

				$html.='<a href="javascript:;" id="btn_prev"></a><a href="javascript:;" id="btn_next"></a>';
			echo $html;
		?>
		
	</div>
</div>
	<div class="detail_box">
	<div class="detail_content">
		<?php 
			$html='';
			if($parent_cats) foreach ($parent_cats as $p) {	
				$html.='<div class="content_box"><a href="/?_a=site&cid='.$p['uid'].'&_u=index.cats"><img src="'.$p['image_icon'].'" style="max-width:70%"><div >'.$p['title'].'</div></a></div>';
			}
			echo $html;
		?>
	</div>
	</div>

<?php 
	include $tpl_path.'/footer.tpl';
?>
<script src="/app/site/view/wapsite/static/js/index.js"></script>
<script type="text/javascript" src="/app/site/view/wapsite/static/js/jquery.event.drag-1.5.min.js"></script>
<script type="text/javascript" src="/app/site/view/wapsite/static/js/jquery.touchSlider.js"></script>
<script type="text/javascript" src="/app/site/view/wapsite/static/js/islider.js"></script>
<script>
	$(".main_visual").hover(function(){
		$("#btn_prev,#btn_next").fadeIn()
	},function(){
		$("#btn_prev,#btn_next").fadeOut()
	});
	window.onload=function(){
		var img_width=$('.content_box a img').width();
		$('.content_box a img').css({'height':img_width+'px'});
	}

			

</script>
