<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">插件列表</strong> / <small>总计 <?php echo $data['count'];?> 个</small></div>
</div>
<?php
#var_export($option);
#var_export($cats);
#var_export($data['list']);
?>

<!-- 头部工具栏 -->
<div class="am-g">
	<div class="am-u-md-6">
	<div class="am-fl am-cf">
          <div class="am-btn-toolbar am-fl">
            <div class="am-btn-group am-btn-group-lg">
              <a  href="?_a=sp&_u=index.pluginstore" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加插件</a>
            </div>

            <div class="am-form-group am-margin-left am-fl">
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
        </div>
    </div>
    </div>

	<div class="am-u-md-3 am-cf">
        <div class="am-fr">
          <div class="am-input-group am-input-group-sm">
            <input type="text" class="am-form-field option_key" value="<?php echo $option['key'];?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
          </div>
        </div>
      </div>
</div>
<br/>
<br/>
<!-- 头部工具栏 end -->

<div class="am-u-sm-12">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<!--<th class="table-check"><input type="checkbox"></th>--><th class="table-title">名称</th>
			<th class="table-type">类别</th>
			<th class="table-date">安装日期</th><th class="table-date">到期日期</th><th class="table-date">使用次数配额</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
          <tbody>
<?php
	if(!$data['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($data['list'] as $l) {
			$html .= '	
            <tr';
			if(!$l['available']) {
				$html .= ' class="am-danger am-link-muted"';
			}
			$html .= '>
              <td><a target="_blank" href="?_a='.$l['dir'].'&_u=sp">'.$l['name'].'</a></td>
              <td><span>'.$cats[$l['type']]['name'].'</span></td>
              <td>'.date('Y-m-d H:i:s', $l['create_time']).'</td>
              <td>'.($l['expire_time'] > 0 ? date('Y-m-d H:i:s', $l['expire_time']): '无限制').'</td>
              <td>';

			if($l['count_all'] < 0) {
				$html .= '无限制';
			}
			else {
				$html .= '
					<div class="am-progress am-progress-striped " style="margin-bottom:0px;">
					  <div class="am-progress-bar-secondary" style="width: '.($l['count_all'] > 0 ? 
								ceil($l['count_used']*100/$l['count_all']) : 0).'%;color:black;">'
								.$l['count_used'].'/'.$l['count_all'].'</div>
					</div>';
			}

			$html .= '</td>
              <td>
                <div class="am-btn-toolbar">
                  <div class="am-btn-group am-btn-group-xs">
                    ';
			if($l['enabled']) { 
				$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger btn_enable" data-id="'.$l['uid'].'"><span class="am-icon-trash-o"></span> 禁用</button>';
			}
			else {
				$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-success btn_enable" data-id="'.$l['uid'].'"><span class="am-icon-trash-o"></span> 启用</button>';
			}

			if($l['can_remove']) {
			 $html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger btn_delete" data-id="'.$l['uid'].'" ><span class="am-icon-trash-o"></span> 删除</button>';
			}
			$html .= '
                  </div>
                </div>
              </td>
            </tr>
			';
		}
		echo $html;
	}
?>


          </tbody>
        </table>
</div>

<div class="am-u-sm-12">
<?php
	echo $pagination;
?>
</div>

<?php
	$extra_js = $static_path.'/js/pluginlist.js';
?>
