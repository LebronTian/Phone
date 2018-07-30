
<style>
	.table-main tr{
		cursor: pointer;
	}

</style>
<link rel="stylesheet" href="/app/shop/static/css/fadeInBox.css"/>

<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">提问回复</strong> / <small>总计 <?php echo $comment['count'];?> 篇</small></div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-6">
	</div>

	<div class="am-u-md-3 am-cf">
		<div class="am-fr">
			<div class="am-input-group am-input-group-sm">
				<input type="text" class="am-form-field option_key" placeholder="评论内容搜索" value="<?php echo $option['key'];?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn"  type="button">搜索</button>
                </span>
			</div>
		</div>
	</div>

</div>

<?php
	//var_export($comment);
?>

<div class="am-u-sm-12">
	<table style="table-layout:fixed" class="am-table am-table-striped am-table-hover table-main">
		<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
			</th>
			<th>ID</th>
			<th class="table-name">用户名</th>
			<th class="table-brief">评论表单</th>
			<th class="table-brief">评论内容</th>
			<th class="table-time">评论时间</th>
			<!--<th class="table-status">状态</th>-->
			<th class="table-set">操作</th>
		</tr>
		</thead>
		<tbody>
		<?php
	if(!$comment['list']) {
		echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
		}
		else {
		$reviews = array(
		0 => 'am-btn-default',
		1 => 'am-btn-success',
		20 => 'am-btn-danger',
		);
		$btn_word = array(
		0 => '未审核',
		1 => '通过',
		2 => '失败',
		);
		$html = '';
		foreach($comment['list'] as $m) {
		$html .= '<tr ';

		if($m['status']==2){$html .= ' class="am-danger "';}
		elseif($m['status']==1){$html.='class="am-success"';}

		$html .= ' data-id="'.$m['uid'].'"><td class="table-check"><input type="checkbox" class="ccheck"></td><td>'.$m['uid'].'</td><td><a href="?_a=su&_u=sp.fansdetail&uid='.$m['su_uid'].'">'.$m['su']['name'].'</a></td>';
		$html .= '<td><a href="?_a=form&_u=sp.addform&uid='.$m['f_uid'].'">点击查看详情</a></td>';
		$html .= '<td style="overflow:hidden;">';
		$html .= $m['content'].'</td>';
		$html .= '<td>'.date('Y-m-d H:i:s', $m['create_time']).'</td>
		<td>
			<div class="am-dropdown" data-am-dropdown>
				<button class="'.(isset($reviews[$m['status']]) ? $reviews[$m['status']] : "am-btn-white").' am-btn am-btn-sm am-dropdown-toggle" data-am-dropdown-toggle >
				'.(isset($btn_word[$m['status']]) ? $btn_word[$m['status']]:"").'
				</button>
				<ul data-uid="'.$m['uid'].'" style="min-width:100%;text-align:center" class="am-dropdown-content status-sel">
					<li data-pass="1" class="am-btn-success">通过</li>
					<li data-pass="2" class="am-btn-danger">失败</li>
				</ul>
			</div>
		</td>

		<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';
					$html .= '<button class="am-btn am-btn-secondary am-btn-xs message-more" onclick="window.location.href=\'?_a=form&_u=sp.add_reply&uid='.$m['uid'].'\'">回复</button>';
					$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$m['uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';

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
    '/app/form/static/js/form_reply.js'
);
?>
<script>

</script>
