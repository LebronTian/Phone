
<?php 
	 //var_export($stores);
?>
<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">门店管理</strong> / <small>总计 <?php echo $stores['count'];?> 间</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-6">
	<div class="am-fl am-cf">
    <a  href="?_a=store&_u=sp.addstore" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加门店</a>
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

<?php
	//var_export($stores);
?>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除门店</div>
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
			<th class="table-title">名称</th>
			<th class="table-image">图片</th><th class="table-order">排序</th>
			<th class="table-time">创建时间</th><th class="table-status">状态</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
	<tbody>
<?php
	if(!$stores['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($stores['list'] as $c) {
			$html .= '<tr';
			if($c['status']) {
				$html .= ' class="am-danger "';
			}
			$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td><td>'.
					$c['name'].'</td><td><img src="'.$c['main_img'].'" style="max-width:100px;max-height:100px;"></td><td>'
					.$c['sort'].'</td><td>'.date('Y-m-d H:i:s', $c['create_time']).'</td><td>'
					.($c['status'] ? '<a data-status="'.$c['status'].'" class="cstatus am-btn am-btn-xs am-btn-danger">已隐藏</a>':
					'<a data-status="'.$c['status'].'" class="cstatus am-btn am-btn-xs am-btn-success">已显示</a>').
					'</td><td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
			$html .= '<a href="?_a=store&_u=sp.addstore&uid='.$c['uid']
				.'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-trash-o"></span> 编辑</a>';
			$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
		
			$html .= '</div></div></td>'.'</tr>';
					
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
$extra_js = array(
    $static_path.'/js/storelist.js',
);
?>
