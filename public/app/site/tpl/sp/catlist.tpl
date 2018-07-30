<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">分类管理</strong> / </div>
</div>

<div class="am-g am-padding">
	<div class="am-fl am-cf">
    <a  href="?_a=site&_u=sp.addcat" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加分类</a>
	</div>
            <div class="am-form-group am-margin-left am-fl">
              <select data-am-selected="{btnSize: 'lg' }" class="option_cat">
				<?php
					$html = '<option value="0"';
					if($option['parent_uid']==0) $html .= ' selected ';
					$html .= '>顶级分类</option>';
					
					$html .= '<option value="-1"';
					if($option['parent_uid']<0) $html .= ' selected ';
					$html .= '>所有分类</option>';

					foreach($parents as  $p) {
					$html .= '<option value="'.$p['uid'].'"';
					if($option['parent_uid'] == $p['uid']) $html .= ' selected';
					$html .= '> -- '.$p['title'].'</option>';
					}
					echo $html;
				?>
              </select>
            </div>

    <button style="margin-left: 1em;display: none" type="button" class="am-btn am-btn-primary choose-cats">
        选择分类
    </button>



</div>

<?php
	//var_export($cats);
?>

<div class="am-u-sm-12">


<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除分类</div>
    <div class="am-modal-bd">
      确定要删除吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>


<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th>
			<th class="table-title">分类名称</th>
			<th class="table-parent">父级分类</th>
			<th class="table-image">图片</th><th class="table-order">排序</th><th class="table-status">状态</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
	<tbody>
<?php
	if(!$cats) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($cats as $c) {
			$html .= '<tr';
			if($c['status']) {
				$html .= ' class="am-danger "';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td><td>'.
					$c['title'].' ('.$c['title_en'].')</td><td>'.(!empty($c['parent_cat']['title']) ? $c['parent_cat']['title'] : '顶级').'</td><td><img src="'.$c['image'].'" style="max-width:100px;max-height:100px;"></td><td>'
					.$c['sort'].'</td><td>'.($c['status'] ? '<a data-status="'.$c['status'].'" class="cstatus am-btn am-btn-xs am-btn-danger">已禁用</a>':
					'<a data-status="'.$c['status'].'" class="cstatus am-btn am-btn-xs am-btn-success">已显示</a>').
					'</td><td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			$html .= '<a href="?_a=site&_u=sp.addcat&uid='.$c['uid']
				.'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-trash-o"></span> 编辑</a>';
			$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
		
			$html .= '</div></div></td>'.'</tr>';
					
		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>

<div class="am-modal am-modal-no-btn" tabindex="-1" id="chooseCats">
    <div class="am-modal-dialog">
        <div class="am-modal-hd">选择分类
            <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd">
            <div style="overflow: scroll;max-height: 40em">
                <select class="catList-yhc1"></select>
            </div>
        </div>
    </div>
</div>

<?php
$extra_js = array(
    '/static/js/catlist_yhc.js',
    $static_path.'/js/catlist.js',
    $static_path.'/js/catsSelect.js'
);
?>

<script>
    var catsAll =<?php echo(!empty($catsAll)? json_encode($catsAll):"null")?>;
</script>
