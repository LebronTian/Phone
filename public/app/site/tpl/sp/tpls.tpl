
<style type="text/css"> 
.moveBar {position: absolute;width:300px;height:529px;z-index:10;right:100px;
top:50px;
} 
.phone_png{width:300px;height:529px;position:absolute;z-index:-10;top:0}
#banner { cursor: move;height:75px;opacity:0;} 
.content{position:absolute;top:77px;left:23px;height:382px;width:258px;}
.close_show{position:absolute;right:15px;top:15px;cursor:pointer;border-radius:1000px}
#back{position:absolute;left:123px;bottom:13px;height:46px;width:56px;cursor:pointer;border-radius:30px;opacity:0}
.gallery-desc{min-width:222px}
.gallery-desc>button{font-size:1.3rem;}
.gallery-desc>a{font-size:1.3rem;}
.url_erweima{width:215px;height:215px;position:absolute;display:none}
</style> 

<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">模板选择</strong> / <small>总计  <?php echo $tpls['count'];?> 个</small></div>
</div>
<div class="am-u-md-6">
            <div class="am-form-group am-margin-left am-fl">
              <select data-am-selected="{btnSize: 'lg' }" class="option_type">
				<?php
					$html = '<option value="0"';
					if($option['type']==0) $html .= ' selected ';
					$html .= '>所有分类</option>';	
					$html .= '<option value="tpl_mobile"';
					if($option['type'] == "tpl_mobile") $html .= ' selected';
					$html .= '>手机模板</option>';
					$html .= '<option value="tpl"';
					if($option['type'] == "tpl") $html .= ' selected';
					$html .= '>PC模板</option>';
					echo $html;
				?>
              </select>
            </div>
        </div>
<br/><br/>
<div class="am-padding">
请选择一个模板
<?php
	if(!empty($_REQUEST['_d'])) echo '<a id="id_clear_site_data" class="am-btn-danger am-btn am-btn-large"><span class="am-icon-trash"></span> 清除全站数据</a>';
?>
</div>
<!-- 头部工具栏 end -->
<?php
#var_export($option);
#var_export($cats);
#var_export($data['list']);
?>


<ul class="am-avg-md-4 am-avg-lg-4 am-margin">
<?php
	if(!$tpls['list']) {
		echo '<li class="am-danger"><td>暂无数据！</li>';
	}
	else {
		$html = '';
		foreach($tpls['list'] as $l) {
			$html .='<li>';
		if($l['type']!='tpl'){
			if($l['url'])
			{
			$html.='<img class="url_erweima" src="?_easy=web.index.qrcode&url='.$l['url'].'">';
			}
		}
        $html.='<a><img class="am-img-thumbnail am-img-bdrs" style="width:215px;height:215px" src="'.$l['thumb'].'" alt=""></a>
          <div class="gallery-title"><strong>'.$l['name'].'</strong></div>
          <div class="gallery-title" style="width:215px"><small>'.$l['brief'].'</small></div>
          <div class="gallery-desc" style="position:relative">';

			if($l['dir']==$site['tpl']) {
				$html.='<a class="am-btn am-btn-default am-btn-lg" href="?_a=site&_u=sp">已选择</a>';
			}
			else {
				$html.='<button class="am-btn am-btn-primary am-btn-lg choose_tpl" data-name="'.$l['dir'].'">选择</button>';
			}
			if($l['type']=='tpl') {
				$html.='<a style="margin-left:10px" class="am-btn am-btn-primary am-btn-lg" target="_blank"  href="'.
						DomainMod::get_app_url('site', 0, '__tpl='.$l['dir']).'">预览</a>';
			}
			else {
				$html.='<button style="margin-left:10px" class="am-btn am-btn-primary am-btn-lg show_tpl" data-src="'.
						DomainMod::get_app_url('site', 0, '__tpl='.$l['dir']).'"  data-name="'.$l['dir'].'">预览</button>';
			}
			if($l['url']){
			if($l['type']=='tpl') {
			$html .= '<a style="margin-left:10px" class="am-btn am-btn-primary am-btn-lg" target="_blank"  href="'.$l['url'].'">参考网站</a>';
			}
			else {
			$html .= '<a style="margin-left:10px" class="am-btn am-btn-primary am-btn-lg real_url" target="_blank">参考网站</a>';
			}
			}
			$html.='</div>
      </li>
			';
		}
		echo $html;
	}
?>
</ul>

<div class="am-u-sm-12">
<?php
	echo $pagination;
?>
</div>

<script>
    var tpl_data = <?php echo(!empty($tpls)? json_encode($tpls):"null")?>;
    console.log(tpl_data)
</script>

<?php
  $extra_js =  array( 
          $static_path.'/js/tpls.js'
    );
?>