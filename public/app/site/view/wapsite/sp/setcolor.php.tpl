<?php
/*
	设置颜色 
*/
if(!($site = SiteMod::get_site_by_sp_uid())){
	outError();
}

$color = requestString('color', PATTERN_COLOR);

//为避免$k命名冲突, 请遵守k的命名规则规范 cfg_{$app}_{$tpl}_{$act}_{$sp_uid}
$k = 'cfg_site_wapsite_setcolor_'.AccountMod::get_current_service_provider('uid');
outRight(SpExtMod::set_sp_ext_cfg($color, $k));

