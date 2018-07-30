<?php
$parents = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
$k = 'cfg_site_eyeis_setcolor_'.AccountMod::require_sp_uid();
$color = SpExtMod::get_sp_ext_cfg($k);
?>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" charset="utf-8" />
	<meta name="keywords" content="<?php echo $site['seo_words']?>">

	<link rel="stylesheet" type="text/css" href="/app/site/view/eyeis/static/css/style.css"> 
</head>

<body style="background-color:f9f9ef;width:100%;height:100%">
<div style="height:40px;width:100%">
	<div class="header" <?php if(!empty($color)) echo 'style="background-color:#'.$color.'"';?> >
		<div class="classify_pic"><a class="un_click"><img src="/app/site/view/eyeis/static/images/header-nav.png" ></a></div>
	<div class="company_name"><?php echo $site['title']?></div>
	</div>
</div>
	<div class="classify_detail" >
	<ul >
		<?php 
			$html='';
			foreach ($parents as $p) {
				$html.='<li><a href="/?_a=site&sp_uid='.$site['sp_uid'].'&cid='.$p['uid'].'&_u=index.cats">'.$p['title'].'</a></li>';
			}
			echo $html;
		?>
	</ul>
	</div>
