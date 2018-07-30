
<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">消息通知</strong> / <small>总计 <?php echo $data['count'];?> 篇</small></div>
</div>


<div class="am-modal am-modal-no-btn" tabindex="-1" id="doc-modal-1">
  <div class="am-modal-dialog">
    <div class="am-modal-hd"><span>Modal 标题</span>
      <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
    </div>
    <div class="am-modal-bd">
      Modal 内容。本 Modal 无法通过遮罩层关闭。
    </div>
  </div>
</div>




<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">删除消息</div>
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
			<th class="table-title">标题</th>
			<th class="table-time">信息时间</th>
			<th class="table-status">状态</th>
			<th class="table-set">操作</th>
		</tr>
	</thead>
<style>
	.am-table>tbody>tr.am-danger>td{background-color:white!important}
</style>
	<tbody>
<?php
	if(!$data['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
	}
	else {
		$html = '';
		foreach($data['list'] as $c) {
			$html .= '<tr';
			if($c['read_time']==0) {
				$html .= ' class="am-danger"';
			}
			else
				$html .= ' class="am-link-muted"';
				$html .= ' data-id="'.$c['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td><td><a data-id="'.$c['uid'].'" class="btn_title" data-code=\''.$c['content'].'\'   style="cursor:pointer" data-am-modal="{target: \'#doc-modal-1\', closeViaDimmer: 0, width: 400, height: 225}">'.
					$c['title'].'</a></td><td>'.date('Y-m-d H:i:s', $c['create_time']).'</td><td>'
					.($c['read_time']==0 ? '<a data-id="'.$c['uid'].'" class="un_read cstatus am-btn am-btn-xs am-btn-danger" style="color:white">标记为已读</a>':
					'<a data-id="'.$c['uid'].'" class="is_read cstatus am-btn am-btn-xs am-btn-success" style="color:white">标记为未读</a>').
					'</td><td><button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$c['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
		
			$html .= '</td>'.'</tr>';
					
		}
		echo $html;
	}
?>
	</tbody>
</table>
</div>
<button class="readall am-btn am-btn-primary btn-loading-example" style="margin-left:1.6rem">批量标记为已读</button>
<button class="unreadall am-btn am-btn-success btn-loading-example" style="margin-left:1.6rem">批量标记为未读</button>
<div class="am-u-sm-12">
<?php
	echo $pagination;
?>
</div>

<?php
	$extra_js = '/app/sp/static/js/msg.js';
?>
