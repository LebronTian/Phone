<div class="am-cf am-padding">
	<div class="am-fl am-cf">
			<strong class="am-text-primary am-text-lg">模板设置列表</strong>
		<span class="am-icon-angle-right"></span>
		<strong class="am-text-default am-text-lg"><?php echo $option['title']; ?> </strong>
		/
		<small>总计 <?php echo $template_user_set_list['count']; ?> 个</small>
	</div>
</div>
<div class="am-padding" >
	<div class="am-u-md-1">
		<a class="am-btn am-btn-success am-lg" href="?_a=templatexcxmsg&_u=sp.templateset&even=<?php echo $_REQUEST['even']; ?>">
			<span class="am-icon-plus"></span> 创建模板消息</a>
	</div>
</div>

<!--	<div class="am-u-md-3 am-cf">
        <div class="am-fr">
          <div class="am-input-group am-input-group-sm">
            <input type="text" class="am-form-field option_key" value="<?php //echo $option['key'];?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
          </div>
        </div>
	</div>-->


<div class="am-u-sm-12 fans_box">
	<table class="am-table am-table-striped am-table-hover table-main">
		<thead>
		<tr>
			<th class="table-check">
				<input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span
						class="am-icon-trash"></span></a>
			</th>
			<th class="table-public">小程序号</th>
			<th class="table-create_time">创建时间</th>
			<th class="table-status">状态</th>
			<th class="table-set">操作</th>
		</tr>
		</thead>
		<tbody>
		<?php
		if (!$template_user_set_list['list'])
		{
			echo '<tr class="am-danger"><td>请先创建一个模板设置！</td></tr>';
		}
		else
		{
			$html = '';
			foreach ($template_user_set_list['list'] as $t)
			{
				$html .= '<tr '.(empty($t['status'])?"":"class='am-danger'").' data-id="'.$t['uid'].'">';
				$html .= '<td class="table-check"><input type="checkbox" class="ccheck"></td>';
				$html .= '<td>' . $t['public']['public_name'] . '</td>';

				$html .= '<td>' . date('Y-m-d H:i:s',$t['create_time']) . '</td>';

				$html .= '<td>' . (empty($t['status'])?'<button class="statusBtn am-btn am-btn-success">启用</button>':'<button class="statusBtn am-btn am-btn-danger">禁用</button>') . '</td>';

				$html .= '<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">' .
					'<a href="?_a=templatexcxmsg&_u=sp.templateset&uid=' . $t['uid'] . '&public_uid=' . $t['public']['uid'] . '&even=' .$_REQUEST['even'].
					'" target="_self" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-edit"></span> 编辑</a>' .
					'<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="' . $t['uid'] .
					'"><span class="am-icon-trash-o"></span> 删除</button>' .
					'</div></td>';

				$html .= '' . '</tr>';
			}
			echo $html;
		}
		?>
		</tbody>
	</table>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
    <div class="am-modal-dialog">
        <div class="am-modal-bd">
            你，确定要删除这条记录吗？
        </div>
        <div class="am-modal-footer">
            <span class="am-modal-btn" data-am-modal-cancel>取消</span>
            <span class="am-modal-btn" data-am-modal-confirm>确定</span>
        </div>
    </div>
</div>

<div class="am-u-sm-12 change_page">
	<?php
	echo $pagination;
	?>
</div>
<script>
    var template_user_set_list = <?php echo(!empty($template_user_set_list)? json_encode($template_user_set_list):"null")?>;
//    console.log(template_user_set_list)
</script>
<?php
$extra_js = $static_path . '/js/templatelist.js';
?>
