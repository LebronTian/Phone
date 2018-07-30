<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">砍价商品列表</strong> / <small>总计 <?php echo $data['count'];?> 个</small></div>
</div>
  
<div class="am-padding">
<a class="am-btn am-btn-success am-lg" href="?_a=bargain&_u=sp.add_bargain"><span class="am-icon-plus"></span>创建砍价</a>

</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除此砍价</div>
    <div class="am-modal-bd">
      确定要删除吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<div class="am-u-sm-12 fans_box">
<table class="am-table am-table-striped am-table-hover table-main">
	<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th>
			<th class="table-title">标题</th>
			<th class="table-title">图片</th>
			<th class="table-time">截止时间</th>
			<th class="table-time">剩余份数</th>
			<th class="table-time">参加数量</th>
			<th class="table-time">状态</th>
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
		foreach($data['list'] as $f) {
			$html .= '<tr';
			if($f['status']) {
				$html .= ' class="am-danger "';
			}
			if(isset($f['rule']['end_time'])&&$f['rule']['end_time']==0){
				$f['end_time']='-';
			}else{
				$f['end_time']=date('Y-m-d H:i:s', $f['rule']['end_time']);
			}

			$html .= ' data-id="'.$f['uid'].'">';
			$html .= '<td class="table-check" ><input type="checkbox" class="ccheck"></td>'.
						'<td><a>'.$f['title'].'</a></td>';


			$html .= '<td><img src="'.$f['product_info']['img'].'" style="max-width:100px;max-height:100px;"></td>';
			$html .= '<td>'.$f['end_time'].'</td>';
			$html .= '<td><a>'.$f['quantity'].'</a></td>';
			$html .= '<td><a href="?_a=bargain&_u=sp.user_bargainlist&b_uid='.$f['uid'].'">'.$f['join_cnt']
						.($f['join_cnt'] ? ' (点击查看)': '').'</a></td>';
			$html .= '<td>'.($f['status'] ? 
							'<a data-status="'.$f['status'].'" class="cstatus am-btn am-btn-xs am-btn-danger">已结束</a>':
							'<a data-status="'.$f['status'].'" class="cstatus am-btn am-btn-xs am-btn-success">进行中</a>')
					.'</td>';
			$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">'.
					'<a href="?_a=bargain&_u=sp.add_bargain&uid='.$f['uid'].
					'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-trash-o"></span> 编辑</a>'.
					'<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$f['uid'].
					'"><span class="am-icon-trash-o"></span> 删除</button>'
					.'</div></td>';

			$html .= ''.'</tr>';
		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>


<div class="am-u-sm-12 change_page">
<?php
	echo $pagination;
?>
</div>

<?php
	$extra_js = $static_path.'/js/index.js';
?>
