<?php
$parents = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
$catid=requestInt('cid');
$k = 'cfg_site_wapsite_setcolor_'.AccountMod::require_sp_uid();
$color = SpExtMod::get_sp_ext_cfg($k);
?>
<!DOCTYPE html>
<html style="width:100%;">
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" charset="utf-8" />
	<meta name="keywords" content="<?php echo $site['seo_words']?>">

<style>
<?php if(!empty($color)) echo 'a{color: #'.$color.';}';?>
</style>
	<link rel="stylesheet" type="text/css" href="<?php echo $static_path;?>/css/style.css"> 
	<title><?php echo $site['title'];?></title>
</head>


<div style="height:40px;width:100%;background-color:#18B4E5">
	<div class="header"  <?php if(!empty($color)) echo 'style="background-color:#'.$color.'"';?>>
	<div class="company_name"><?php if(isset($cat)) echo $cat['title']; else if(isset($article['cat']['title'])) echo $article['cat']['title']; else echo $site['title']; ?></div>
	</div>
</div>




