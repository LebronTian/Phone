<div class="am-cf am-padding profile-tit">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">首页设置</strong> / <small>修改后台首页</small></div>
</div>

<div class="am-form">
            <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2 am-text-right">
				登录首页:
			</div>
            <div class="am-u-sm-8 am-u-end">
              <select data-am-selected="{btnWidth: 200, btnSize: 'lg' }" class="option_catt">
				<?php
					$cats = array(
						'redirect' => array('name' => '跳转到指定模块'),
						'recent' => array('name' => '跳转到最近使用模块'),
						'none' => array('name' => '留在首页'),
					);
					$html = '';
					empty($index['type']) && $index['type'] = 'none';
					foreach($cats as $k => $cat) {
					$html .= '<option value="'.$k.'"';
					if(!empty($index['type']) && ($index['type'] == $k)) $html .= ' selected';
					$html .= '>'.$cat['name'].'</option>';
					}
					echo $html;
				?>
              </select>
            </div>
            </div>

          <div class="am-g am-margin-top-sm divurl">
            <div class="am-u-sm-2 am-text-right">
   	         跳转url
            </div>
            <div class="am-u-sm-8 am-u-end">
              <input type="text" value="<?php if(!empty($index['url'])) echo $index['url'];?>" id="id_url"/>
            </div>
          </div>

          <div class="am-g am-margin-top-sm">
            <div class="am-u-sm-2">
			&nbsp;
            </div>
            <div class="am-u-sm-8 am-u-end">
              <button type="subimt" class="am-btn am-btn-primary btn_save">保存修改</button>
            </div>
          </div>
              
</div>  

<?php
	$extra_js = $static_path.'/js/setindex.js';
?>
