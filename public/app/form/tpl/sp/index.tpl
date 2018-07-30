<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php
if($option['type'] == 'activity') {
echo '活动列表';
} else {
echo '通用表单';
}
?></strong> / <small>总计 <?php echo $forms['count'];?> 个</small></div>
</div>
  
<div class="am-padding">
<a class="am-btn am-btn-success am-lg" href="?_a=form&_u=sp.addform"><span class="am-icon-plus"></span> 创建表单</a>
	<a class="am-btn am-btn-success am-lg" href="?_a=form&_u=sp.addform&type=activity"><span class="am-icon-plus"></span> 创建活动</a>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm	">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除表单</div>
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
			<th class="table-title">编号</th>
			<th class="table-title">名称</th>
			<th class="table-title">表单项编辑</th>
			<th class="table-title">图片</th>
			<th class="table-time">创建时间</th>
			<th class="table-time">提交数目</th>
			<th class="table-time">提问数</th>
			<th class="table-time">状态</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
	<tbody>
<?php
	if(!$forms['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($forms['list'] as $f) {
			$html .= '<tr';
			if($f['status']) {
				$html .= ' class="am-danger "';
			}
			$reply_cnt = Dba::readOne('select * from form_reply where f_uid = '.$f['uid']);
			$html .= ' data-id="'.$f['uid'].'">';
			$html .= '<td class="table-check" ><input type="checkbox" class="ccheck"></td>'.
					'<td>[ '.$f['uid'].' ]</td>'.
						'<td class="showerweima2"><a href2="?_a=form&f_uid='
						.$f['uid'].'">'.$f['title'].'</a>';
			$html .= '<div class="wap_erweima" style="display: none;z-index:9999;position:absolute"><img 	style="width:120px;height:120px; max-width:none;  " src="?_a=form&_u=index.qrcode&f_uid='.$f['uid'].'">
			<div>扫一扫手机浏览</div>
			</div></td>';
			$html .= '<td><div class="am-btn-toolbar"><a href="?_a=form&_u=sp.itemlist&f_uid='.$f['uid'].
			'" target="_self" class="am-btn am-btn-warning am-btn-xs "><span class="am-icon-plus"></span> 表单项</a></div></td>';
						
			$html .= '<td><img src="'.$f['img'].'" style="max-width:100px;max-height:100px;"></td>';
			$html .= '<td>'.date('Y-m-d H:i:s', $f['create_time']).'</td>';
			$html .= '<td><a href="?_a=form&_u=sp.recordlist&f_uid='.$f['uid'].'">'.$f['record_cnt'].($f['record_cnt'] ? ' (点击查看)': '').'</a></td>';
$html .= '<td><a href="?_a=form&_u=sp.form_reply&f_uid='.$f['uid'].'">'.$reply_cnt
		.($reply_cnt? ' (点击查看)': '0').'</a></td>';
			$html .= '<td>'.($f['status'] ?
							'<a data-status="'.$f['status'].'" class="cstatus am-btn am-btn-xs am-btn-danger">已禁用</a>':
							'<a data-status="'.$f['status'].'" class="cstatus am-btn am-btn-xs am-btn-success">已显示</a>')
					.'</td>';
			$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">'.
					'<a href="?_a=form&_u=sp.addform&uid='.$f['uid'].
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
