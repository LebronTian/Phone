<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">插件商城</strong> / <small>总计  <?php echo $data['count'];?> 个</small></div>
</div>

<!-- 头部工具栏 -->
<div class="am-g">
	<div class="am-u-md-6">
	<div class="am-fl am-cf">
          <div class="am-btn-toolbar am-fl">
            <div class="am-btn-group am-btn-group-lg">
            </div>

            <div class="am-form-group am-fl">
              <select data-am-selected="{btnWidth: 150, btnSize: 'lg' }" class="option_cat">
				<?php
					$html = '<option value="all"';
					if(!$option['cat']) $html .= ' selected ';
					$html .= '>全部分类</option>';
					
					foreach($cats as $k => $cat) {
					$html .= '<option value="'.$k.'"';
					if($option['cat'] == $k) $html .= ' selected';
					$html .= '>'.$cat['name'].'</option>';
					}
					echo $html;
				?>
              </select>
            </div>
              
              
            <div class=" am-fl" style="margin-left:50px;width:200px;height:45px;">
            	<select data-am-selected="{btnWidth: 150,btnSize: 'lg'}" class="install_btn">
				  <option value="totle" selected>全部</option>
				  <option value="select">已安装</option>
				  <option value="none">未安装</option>
				</select>
            </div>
            
            
        </div>

        
    </div>

    
    
    </div>

	<div class="am-u-md-3 am-cf">
        <div class="am-fr">
          <div class="am-input-group am-input-group-sm">
            <input type="text" style="height:40px;" class="am-form-field option_key" value="<?php echo $option['key'];?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" style="height:40px;" type="button">搜索</button>
                </span>
          </div>
        </div>
      </div>
</div>
<!-- 头部工具栏 end -->
<?php
#var_export($option);
#var_export($cats);
#var_export($data['list']);
?>

<ul class="am-avg-md-4 am-avg-lg-4 am-margin">
<?php

	if(!$data['list']) {
		echo '<li class="am-danger"><td>暂无数据！</li>';
	}
	else {
		$html = '';
		foreach($data['list'] as $l) {
			$html .= '
      <li>
        <a href="?_a=sp&_u=index.plugindetail&dir='.$l['dir'].'"><img class="am-img-thumbnail am-img-bdrs" src="'.$l['thumb'].'" alt=""></a>
          <div class="gallery-title"><strong>'.$l['name'].'</strong></div>
          <div class="gallery-desc">';
			if($l['has_installed']) {
				$html .= '已安装';
			}
			else {
				$html .= '未安装';
			}
			$html .= '</div>
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

<?php
	$extra_js = $static_path.'/js/pluginstore.js';
?>


