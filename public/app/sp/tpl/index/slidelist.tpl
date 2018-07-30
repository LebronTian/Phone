<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">幻灯片管理</strong> / <small>共计<?php echo $slides ? count($slides) : 0;?>张</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-fl am-cf">
    <a  href="?_a=sp&_u=index.addslide&pos=<?php echo $option['pos']?>" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加幻灯片</a>
	</div>

            <div class="am-form-group am-margin-left am-fl">
              <select data-am-selected="{btnSize: 'lg' }" class="option_cat">
				<?php
					$html = '<option value=""';
					if(!$option['pos']) $html .= ' selected ';
					$html .= '>全部</option>';
					
					foreach(SlidesMod::get_pos() as $k => $c) {
					$html .= '<option value="'.$k.'"';
					if($option['pos'] == $k) $html .= ' selected';
					$html .= '>'.$c['name'].'</option>';
					}
					echo $html;
				?>
              </select>
            </div>
<?php if(!empty($_REQUEST['_d'])) { ?>
<div class="am-form-group am-margin-left am-fl">
  <select data-am-selected="{btnSize: 'lg' }" class="option_cat2">
	<?php
		$html = '';
		foreach(SlidesMod::get_slide_tpl() as $k => $c) {
		$html .= '<option value="'.$k.'"';
		$html .= '>'.$k.'</option>';
		}
		echo $html;
	?>
  </select>
 <a class="am-btn am-btn-warning" id="id_add_tpl">添加预设幻灯片</a> 
</div>
<?php } ?>


</div>

<?php
	//var_export($cats);
?>
<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除</div>
    <div class="am-modal-bd">
      确定要删除吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>


<div class="am-u-sm-12">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th>
			<th class="table-image">图片</th>
			<th class="table-image">名称</th>
			<th class="table-image">位置</th>
			<th class="table-order">排序</th>
			<th class="table-status">状态</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
	<tbody>
<?php
	if(!$slides) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($slides as $c) {
			$html .= '<tr';
			if($c['status'] || ($c['on_time'] && $_SERVER['REQUEST_TIME'] < $c['on_time']) || 
							($c['off_time'] && $_SERVER['REQUEST_TIME'] > $c['off_time'])) {
				$html .= ' class="am-danger "';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td>'.
				'<td><img src="'.$c['image'].'" style="max-width:100px;max-height:100px;"></td>'.
				'<td><a href="'.($c['link'] ? $c['link'] : 'javascript:;').'">'.($c['title']).'</a></td>'.
				'<td>'.($c['pos'] ? SlidesMod::get_pos($c['pos']) : '-').'</td>'.'<td>'
					.$c['sort'].'</td><td>'.($c['status'] ? '<a data-status="'.$c['status'].'" class="cstatus am-btn am-btn-xs am-btn-danger">已禁用</a>':
					'<a data-status="'.$c['status'].'" class="cstatus am-btn am-btn-xs am-btn-success">已显示</a>');
			if($c['on_time']) $html .= '<br>待上线时间：'.date('Y-m-d H:i:s', $c['on_time']);
			if($c['off_time']) $html .= '<br>待下线时间：'.date('Y-m-d H:i:s', $c['off_time']);
		
			$html .=  '</td><td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			$html .= '<a href="?copy_uid='.$c['uid']
				.'&_a=sp&_u=index.addslide" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-copy"></span> 复制</a>';
			$html .= '<a href="?_a=sp&_u=index.addslide&uid='.$c['uid']
				.'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-edit"></span> 编辑</a>';
			$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
		
			$html .= '</div></div></td>'.'</tr>';
					
		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>
<script>
</script>

<?php
	$extra_js = $static_path.'/js/slidelist.js';
?>
