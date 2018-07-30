<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">域名绑定</strong> / <small>将您的域名绑定到一个模块或页面</small></div>
</div>
  
<form class="am-form am-form-horizontal">
  <div class="am-form-group am-form-group-sm">
    <label for="id_domain" class="am-u-sm-2 am-form-label">您的域名</label>
    <div class="am-u-sm-10">
      <input id="id_domain" class="am-form-field" placeholder="绑定域名" 
			<?php if(!empty($domain['domain'])) echo ' value="'.$domain['domain'].'"';?>>
    </div>
  </div>

  <div class="am-form-group am-form-group-lg">
    <label for="id_bind" class="am-u-sm-2 am-form-label">绑定模块</label>
    <div class="am-u-sm-10">
	<?php

	$plugin=DomainMod::get_allow_plugin_array();
	$ret=DomainMod::get_pluging_by_uid();
	if($ret){
		foreach($ret as $r)
		{	
			$pluging_list[$r['dir'].'.index.index']=$r['name'];
		}
	}
//    var_dump($plugin,$pluging_list);exit;
	$select=array_intersect($plugin,$pluging_list);//取交集

	$html='';
	if($select)
	{
		$html='<select id="id_bind">';
		foreach($select as $sk=>$s)
		{	
			$html.='<option value="'.$sk.'"';
			if(!empty($domain['bind'])&&$domain['bind']==$sk)
			$html.='selected';
			$html.='>'.$s.'</option>';
		}
		$html.='</select>';
	}
	else
	{
		$html.='<div class="am-u-sm-10">无模块可选';
		$html.='</div ">';
	}
	echo $html;
	?>

      
    </div>

  </div>
	<?php 
	$html='';
	$html.='<div class="am-form-group am-form-group-lg">';
    $html.='<label for="id_bind" class="am-u-sm-2 am-form-label">绑定模块(有我即我)</label>';

	
	
	$html.='<div class="am-u-sm-10">';
	
    $html.=' <input id="id_binds" class="am-form-field" placeholder="绑定模块如 site.index.index"';
	if(!empty($domain['bind']))
		$html.=' value="'.$domain['bind'].'" ';
	$html.=' ></div></div>';
	
	if(!empty($_REQUEST['_d'])){
	echo $html;
	}
	
?>
	
	
  <div class="am-form-group">
    <div class="am-u-sm-10 am-u-sm-offset-2">
      <a id="id_commit" class="am-btn am-btn-primary am-btn-lg" 
			<?php if(!empty($domain['uid'])) echo ' data-id="'.$domain['uid'].'"';?>
		><span class="am-icon-plus"></span> 绑定</a>
    </div>
  </div>
</form>

<?php

$extra_js = array(
				$static_path.'/js/adddomain.js',
);
?>
