<?php 
include $tpl_path.'/header.tpl';
?>

<link rel="stylesheet" type="text/css" href="/app/site/view/eyeis/static/css/index.css"> 
<link type="text/css" href="/app/site/view/eyeis/static/css/islider.css" rel="stylesheet"/>
	<div class="main_visual">
	<div class="flicking_con">
					<?php 
			$html='';
			if($parent_cats) foreach ($slides as $s) {	
				$html.='<a href="#"></a>';
			}
			echo $html;
			?>
	</div>
	<div class="main_image">
		<ul>
			<?php 
			$html='';
			if($parent_cats) foreach ($slides as $s) {	
				$html.='<li><img src="'.$s['image'].'"></li>';
			}
			echo $html;
			?>
		</ul>
	</div>
</div>
	<div class="detail_box">
	<div class="detail_content">
		<?php 
			$html='';
			if($parent_cats) foreach ($parent_cats as $p) {	
				$html.='<div class="content_box"><a href="/?_a=site&sp_uid='.$site['sp_uid'].'&cid='.$p['uid'].'&_u=index.cats"><img src="'.$p['image_icon'].'"></a><div >'.$p['title'].'</div></div>';
			}
			echo $html;
		?>
	</div>
	</div>

<?php 
	include $tpl_path.'/footer.tpl';
?>
<script src="/app/site/view/eyeis/static/js/index.js"></script>
<script type="text/javascript" src="/app/site/view/eyeis/static/js/jquery.event.drag-1.5.min.js"></script>
<script type="text/javascript" src="/app/site/view/eyeis/static/js/jquery.touchSlider.js"></script>
<script type="text/javascript" src="/app/site/view/eyeis/static/js/islider.js"></script>
