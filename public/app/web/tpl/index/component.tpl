<a target="_blank" href="https://mp.weixin.qq.com/cgi-bin/componentloginpage?component_appid=wxa6dae76787aaf8cd&pre_auth_code=<?php 
echo empty($component['pre_auth_code'])?'':$component['pre_auth_code'];
 ?>&redirect_uri=<?php 
 echo urlencode('http://weixin.uctoo.com/rewrite.web.component.uricallbcak.sp_uid='.(empty($component['sp_uid'])?'':$component['sp_uid'])).'.php'; ?>">
<img src="<?php echo $static_path;?>/images/icon_button3_1.png"></a>

<?php //var_dump($GLOBALS);?>


